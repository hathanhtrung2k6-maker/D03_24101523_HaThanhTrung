module d03_core_tb;
    logic clk, rst_n, load_n;
    logic [7:0] n_in;
    logic out, out_ref;
    logic [6:0] count, count_ref;

    d03_core dut(
        .clk(clk), .rst_n(rst_n), .n_in(n_in), .load_n(load_n),
        .out(out), .count(count)
    );

    d03_reference ref_i(
        .clk(clk), .rst_n(rst_n), .n_in(n_in), .load_n(load_n),
        .out_ref(out_ref), .count_ref(count_ref)
    );

    always #5 clk = ~clk;

    task automatic load_and_check(input logic [7:0] n);
        begin
            n_in = n;
            load_n = 1;
            @(posedge clk);
            #1;
            assert(out === out_ref);
            assert(count === count_ref);
            load_n = 0;
        end
    endtask

    task automatic check;
        begin
            @(posedge clk);
            #1;
            assert(out === out_ref)
                else $fatal(1, "D03 output mismatch N=%0d", n_in);
            assert(count === count_ref)
                else $fatal(1, "D03 count mismatch");
        end
    endtask

    initial begin
        clk = 0;
        rst_n = 0;
        load_n = 0;
        n_in = 8'd1;

        repeat(2) check();
        rst_n = 1;

        load_and_check(8'd1);
        repeat(4) check();

        load_and_check(8'd2);
        repeat(8) check();

        load_and_check(8'd3);
        repeat(12) check();

        load_and_check(8'd255);
        repeat(20) check();

        load_and_check(8'd5);
        repeat(7) check();
        load_and_check(8'd2);
        repeat(8) check();

        load_and_check(8'd4);
        repeat(12) check();

        load_and_check(8'd254);
        repeat(20) check();

        $display("D03 core verification PASS");
        $finish;
    end

    initial begin
        $dumpfile("waveforms/d03_wave.vcd");
        $dumpvars(0, d03_core_tb);
    end
endmodule
