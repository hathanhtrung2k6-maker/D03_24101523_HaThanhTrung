module d03_reference (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] n_in,
    input  logic       load_n,
    output logic       out_ref,
    output logic [6:0] count_ref
);
    logic [7:0] n_reg;
    logic [7:0] phase;
    logic [7:0] half_len;

    always_comb begin
        if (n_reg <= 8'd1)
            half_len = 8'd1;
        else if (out_ref)
            half_len = n_reg - (n_reg / 2);
        else
            half_len = n_reg / 2;
    end

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            n_reg <= 8'd1;
            phase <= 8'd0;
            out_ref <= 1'b0;
        end else if (load_n) begin
            n_reg <= (n_in == 8'd0) ? 8'd1 : n_in;
            phase <= 8'd0;
            out_ref <= 1'b0;
        end else if (n_reg == 8'd1) begin
            phase <= 8'd0;
            out_ref <= 1'b1;
        end else if (phase == half_len - 8'd1) begin
            phase <= 8'd0;
            out_ref <= ~out_ref;
        end else begin
            phase <= phase + 8'd1;
        end
    end

    always_comb begin
        if (n_reg == 8'd1)
            count_ref = 7'd0;
        else if (phase > 8'd127)
            count_ref = 7'h7f;
        else begin
            count_ref[0] = phase[0];
            count_ref[1] = phase[1];
            count_ref[2] = phase[2];
            count_ref[3] = phase[3];
            count_ref[4] = phase[4];
            count_ref[5] = phase[5];
            count_ref[6] = phase[6];
        end
    end
endmodule
