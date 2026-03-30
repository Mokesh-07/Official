// i2c_master.sv
module i2c_master #(
    parameter CLK_DIV = 4
)(
    input  logic       clk,
    input  logic       rst_n,
    input  logic       start,
    input  logic       rw,
    input  logic [6:0] addr,
    input  logic [7:0] wdata,
    output logic [7:0] rdata,
    output logic       done,
    output logic       ack_err,
    inout  wire        sda,
    output logic       scl
);

    // ── State enum - ALL states declared including STOP_HOLD ──
    typedef enum logic [3:0] {
        IDLE       = 4'd0,
        START_C    = 4'd1,
        ADDR_PHASE = 4'd2,
        ADDR_ACK   = 4'd3,
        DATA_PHASE = 4'd4,
        DATA_ACK   = 4'd5,
        STOP_C     = 4'd6,
        STOP_HOLD  = 4'd7,
        DONE_S     = 4'd8
    } state_t;

    state_t     state;          // removed unused 'next'

    logic [3:0] clk_cnt;
    logic       scl_r;
    logic       sda_oe;
    logic       sda_out;
    logic [3:0] bit_cnt;
    logic [7:0] shift_reg;
    logic       scl_rise, scl_fall;

    // Tri-state SDA
    assign sda = sda_oe ? sda_out : 1'bz;

    // SCL generation
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_cnt <= 4'd0;
            scl_r   <= 1'b1;
        end else begin
            if (state == IDLE || state == DONE_S) begin
                clk_cnt <= 4'd0;
                scl_r   <= 1'b1;
            end else begin
                if (clk_cnt == CLK_DIV - 1) begin
                    clk_cnt <= 4'd0;
                    scl_r   <= ~scl_r;
                end else begin
                    clk_cnt <= clk_cnt + 4'd1;
                end
            end
        end
    end

    assign scl      = scl_r;
    assign scl_rise = (clk_cnt == CLK_DIV - 1) && (~scl_r);
    assign scl_fall = (clk_cnt == CLK_DIV - 1) &&   scl_r;

    // FSM
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            bit_cnt   <= 4'd0;
            shift_reg <= 8'd0;
            sda_oe    <= 1'b1;
            sda_out   <= 1'b1;
            rdata     <= 8'd0;
            done      <= 1'b0;
            ack_err   <= 1'b0;
        end else begin
            done    <= 1'b0;
            ack_err <= 1'b0;

            case (state)

                IDLE: begin
                    sda_oe  <= 1'b1;
                    sda_out <= 1'b1;
                    if (start) begin
                        state     <= START_C;
                        shift_reg <= {addr, rw};
                        bit_cnt   <= 4'd7;
                    end
                end

                // SDA falls while SCL high = START condition
                START_C: begin
                    sda_oe  <= 1'b1;
                    sda_out <= 1'b0;
                    if (clk_cnt == CLK_DIV - 1)
                        state <= ADDR_PHASE;
                end

                // Shift out 7-bit addr + R/W MSB first
                ADDR_PHASE: begin
                    sda_oe  <= 1'b1;
                    sda_out <= shift_reg[7];
                    if (scl_fall) begin
                        if (bit_cnt == 4'd0) begin
                            state  <= ADDR_ACK;
                            sda_oe <= 1'b0;
                        end else begin
                            shift_reg <= shift_reg << 1;
                            bit_cnt   <= bit_cnt - 4'd1;
                        end
                    end
                end

                // Sample ACK from slave on SCL rise
                ADDR_ACK: begin
                    sda_oe <= 1'b0;
                    if (scl_rise) begin
                        if (sda !== 1'b0) begin
                            ack_err <= 1'b1;
                            state   <= STOP_C;
                        end else begin
                            state     <= DATA_PHASE;
                            shift_reg <= rw ? 8'hFF : wdata;
                            bit_cnt   <= 4'd7;
                        end
                    end
                end

                // Write: drive SDA. Read: sample SDA
                DATA_PHASE: begin
                    if (rw) begin
                        sda_oe <= 1'b0;
                        if (scl_rise)
                            rdata <= {rdata[6:0], sda};
                    end else begin
                        sda_oe  <= 1'b1;
                        sda_out <= shift_reg[7];
                    end
                    if (scl_fall) begin
                        if (bit_cnt == 4'd0) begin
                            sda_oe <= 1'b0;
                            state  <= DATA_ACK;
                        end else begin
                            shift_reg <= shift_reg << 1;
                            bit_cnt   <= bit_cnt - 4'd1;
                        end
                    end
                end

                DATA_ACK: begin
                    sda_oe <= 1'b0;
                    if (scl_rise) begin
                        if (!rw && sda !== 1'b0)
                            ack_err <= 1'b1;
                        state <= STOP_C;
                    end
                end

                // SDA rises while SCL high = STOP condition
                STOP_C: begin
                    sda_oe  <= 1'b1;
                    sda_out <= 1'b0;
                    if (scl_rise) begin
                        sda_out <= 1'b1;
                        state   <= STOP_HOLD;
                    end
                end

                // Hold STOP condition for one half-period
                STOP_HOLD: begin
                    sda_oe  <= 1'b1;
                    sda_out <= 1'b1;
                    if (clk_cnt == CLK_DIV - 1)
                        state <= DONE_S;
                end

                DONE_S: begin
                    done  <= 1'b1;
                    state <= IDLE;
                end

                default: state <= IDLE;

            endcase
        end
    end

endmodule
