// i2c_slave.sv
module i2c_slave #(
    parameter SLAVE_ADDR = 7'h55
)(
    input  logic clk,
    input  logic rst_n,
    inout  wire  sda,
    input  logic scl
);

    typedef enum logic [2:0] {
        S_IDLE     = 3'd0,
        S_ADDR     = 3'd1,
        S_ADDR_ACK = 3'd2,
        S_DATA     = 3'd3,
        S_DATA_ACK = 3'd4
    } state_t;

    state_t     state;
    logic [7:0] shift_reg;
    logic [3:0] bit_cnt;
    logic       sda_oe, sda_out;
    logic       rw_bit;
    logic [7:0] mem;

    logic       scl_prev, sda_prev;
    logic       start_det, stop_det;
    logic       scl_rise, scl_fall_s;

    // Tri-state SDA
    assign sda = sda_oe ? sda_out : 1'bz;

    // Sample scl and sda for edge detection
    // Use logic intermediate to avoid reading inout wire directly
    logic sda_in;
    assign sda_in = sda;   // buffer inout → logic for Vivado compatibility

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scl_prev <= 1'b1;
            sda_prev <= 1'b1;
        end else begin
            scl_prev <= scl;
            sda_prev <= sda_in;
        end
    end

    assign start_det  =  scl  &&  sda_prev && !sda_in;   // SDA falls, SCL high
    assign stop_det   =  scl  && !sda_prev &&  sda_in;   // SDA rises, SCL high
    assign scl_rise   =  scl  && !scl_prev;
    assign scl_fall_s = !scl  &&  scl_prev;

    // FSM
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= S_IDLE;
            sda_oe    <= 1'b0;
            sda_out   <= 1'b1;
            mem       <= 8'hA5;
            bit_cnt   <= 4'd7;
            shift_reg <= 8'd0;
            rw_bit    <= 1'b0;
        end else begin
            case (state)

                S_IDLE: begin
                    sda_oe    <= 1'b0;
                    sda_out   <= 1'b1;
                    bit_cnt   <= 4'd7;
                    shift_reg <= 8'd0;
                    if (start_det) begin
                        state   <= S_ADDR;
                        bit_cnt <= 4'd7;
                    end
                end

                S_ADDR: begin
                    if (scl_rise) begin
                        shift_reg <= {shift_reg[6:0], sda_in};
                        if (bit_cnt == 4'd0)
                            state <= S_ADDR_ACK;
                        else
                            bit_cnt <= bit_cnt - 4'd1;
                    end
                    if (stop_det) state <= S_IDLE;
                end

                S_ADDR_ACK: begin
                    if (shift_reg[7:1] == SLAVE_ADDR) begin
                        rw_bit  <= shift_reg[0];
                        sda_oe  <= 1'b1;
                        sda_out <= 1'b0;            // ACK = pull SDA low
                        if (scl_fall_s) begin
                            state   <= S_DATA;
                            bit_cnt <= 4'd7;
                            if (shift_reg[0])
                                shift_reg <= mem;   // preload for read
                            else
                                shift_reg <= 8'd0;
                        end
                    end else begin
                        sda_oe <= 1'b0;
                        state  <= S_IDLE;           // address mismatch
                    end
                    if (stop_det) state <= S_IDLE;
                end

                S_DATA: begin
                    if (rw_bit) begin
                        // Master READ - slave drives SDA
                        sda_oe  <= 1'b1;
                        sda_out <= shift_reg[7];
                        if (scl_fall_s) begin
                            if (bit_cnt == 4'd0) begin
                                state  <= S_DATA_ACK;
                                sda_oe <= 1'b0;
                            end else begin
                                shift_reg <= shift_reg << 1;
                                bit_cnt   <= bit_cnt - 4'd1;
                            end
                        end
                    end else begin
                        // Master WRITE - slave samples SDA
                        sda_oe <= 1'b0;
                        if (scl_rise) begin
                            shift_reg <= {shift_reg[6:0], sda_in};
                            if (bit_cnt == 4'd0)
                                state <= S_DATA_ACK;
                            else
                                bit_cnt <= bit_cnt - 4'd1;
                        end
                    end
                    if (stop_det) state <= S_IDLE;
                end

                S_DATA_ACK: begin
                    if (!rw_bit) mem <= shift_reg;  // latch written byte
                    sda_oe  <= 1'b1;
                    sda_out <= 1'b0;                // ACK
                    if (scl_fall_s) begin
                        sda_oe <= 1'b0;
                        state  <= S_IDLE;
                    end
                    if (stop_det) state <= S_IDLE;
                end

                default: state <= S_IDLE;

            endcase
        end
    end

endmodule
