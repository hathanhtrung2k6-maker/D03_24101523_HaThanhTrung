module d03_core (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] n_in,
    input  logic       load_n,
    output logic       out,
    output logic [6:0] count
);
    logic [7:0] n_reg;
    logic [7:0] phase;
    logic [7:0] half_len;

    always_comb begin
        if (n_reg <= 8'd1)
            half_len = 8'd1;
        else if (out)
            half_len = n_reg - (n_reg / 2);
        else
            half_len = n_reg / 2;
    end

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            n_reg <= 8'd1;
            phase <= 8'd0;
            out   <= 1'b0;
        end else if (load_n) begin
            n_reg <= (n_in == 8'd0) ? 8'd1 : n_in;
            phase <= 8'd0;
            out   <= 1'b0;
        end else if (n_reg == 8'd1) begin
            phase <= 8'd0;
            out   <= 1'b1;
        end else if (phase == half_len - 8'd1) begin
            phase <= 8'd0;
            out   <= ~out;
        end else begin
            phase <= phase + 8'd1;
        end
    end

    always_comb begin
        if (n_reg == 8'd1)
            count = 7'd0;
        else if (phase > 8'd127)
            count = 7'h7f;
        else
            count = phase[6:0];
    end
endmodule
