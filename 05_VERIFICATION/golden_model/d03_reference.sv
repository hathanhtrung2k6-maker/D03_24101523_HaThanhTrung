module d03_reference (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] n_in,
    input  logic       load_n,
    output logic       out_ref,
    output logic [6:0] count_ref
);
    integer n_ref;
    integer phase_ref;
    integer interval_ref;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            n_ref     <= 1;
            phase_ref <= 0;
            out_ref   <= 0;
        end else if (load_n) begin
            n_ref     <= (n_in == 0) ? 1 : n_in;
            phase_ref <= 0;
            out_ref   <= 0;
        end else if (n_ref == 1) begin
            n_ref     <= 1;
            phase_ref <= 0;
            out_ref   <= 1;
        end else begin
            if (out_ref)
                interval_ref = n_ref - (n_ref / 2);
            else
                interval_ref = n_ref / 2;

            if (phase_ref == interval_ref - 1) begin
                phase_ref <= 0;
                out_ref   <= ~out_ref;
            end else begin
                phase_ref <= phase_ref + 1;
            end
        end
    end

    always_comb begin
        if (phase_ref > 127)
            count_ref = 7'h7f;
        else
            count_ref = phase_ref[6:0];
    end
endmodule
