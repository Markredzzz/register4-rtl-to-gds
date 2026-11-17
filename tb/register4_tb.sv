/*
 * Lesson 06: Register Self-Checking Testbench
 *
 * 中文目的：
 * 驗證 Clock Enable、同步 Reset、
 * 資料擷取與暫存器狀態保持功能。
 *
 * English Objective:
 * Verify reset priority, register update,
 * and hold behavior under clock enable.
 *
 * Compile from repository root / 從專案根目錄編譯：
 * iverilog -g2012 -Wall -s register4_tb -o register4_sim \
 *   rtl/register4.sv tb/register4_tb.sv
 *
 * Run / 執行：
 * vvp register4_sim
 *
 * Waveform / 波形：
 * gtkwave register4.vcd
 */

`timescale 1ns/1ps

module register4_tb;

    logic clk = 1'b0;
    logic rst = 1'b0;
    logic en  = 1'b0;
    logic [3:0] d = 4'b0000;

    wire [3:0] q;

    integer pass_count;

    register4 dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .d(d),
        .q(q)
    );

    // Clock generation:
    // 每隔 5 ns 反相，週期為 10 ns。
    // Toggle every 5 ns, giving a 10 ns period.
    always #5 clk = ~clk;

    // Reusable self-checking task:
    // expected is 4-bit because q is 4-bit.
    task check_q;
        input  [3:0] expected;

        begin
            // !==:
            // Case inequality detects X/Z mismatches.
            if (q !== expected) begin
                $fatal(1,
                    "FAIL t=%0t rst=%b en=%b d=%h q=%h expected=%h",
                    $time, rst, en, d, q, expected);
            end

            // %h:
            // Display values in hexadecimal.
            $display(
                "PASS t=%0t rst=%b en=%b d=%h q=%h",
                $time, rst, en, d, q
            );

            pass_count = pass_count + 1;
        end
    endtask

    initial begin

        pass_count = 0;

        $dumpfile("register4.vcd");
        $dumpvars(0, register4_tb);

        // Test 1: Reset at positive edge.
        rst = 1'b1;
        en  = 1'b1;
        d   = 4'hA;

        @(posedge clk);
        #1;
        check_q(4'h0);

        // Test 2: Set data before next posedge.
        @(negedge clk);
        rst = 1'b0;
        en  = 1'b1;
        d   = 4'hA;

        #1;
        check_q(4'h0);

        // Test 3: Capture data at posedge.
        @(posedge clk);
        #1;
        check_q(4'hA);

        // Test 4:
        // At negedge, en=0 and d=3.
        // q should remain A before next posedge.
        @(negedge clk);
        en = 1'b0;
        d  = 4'h3;
        #1;
        check_q(4'hA);


        // Test 5:
        // At next posedge, q should still be A.
        @(posedge clk);
        #1;
        check_q(4'hA);


        // Test 6:
        // At negedge, en=1 and d=5.
        // q should still be A before next posedge.
        @(negedge clk);
        en = 1'b1;
        d  = 4'h5;
        #1;
        check_q(4'hA);


        // Test 7:
        // At next posedge, q should become 5.
        @(posedge clk);
        #1;
        check_q(4'h5);


        // Test 8:
        // At negedge, assert rst=1 and en=0.
        // q should remain 5 before next posedge.

        @(negedge clk);
        rst = 1'b1;
        en  = 1'b0;
        #1;
        check_q(4'h5);


        // Test 9:
        // At next posedge, q should become 0.

        @(posedge clk);
        #1;
        check_q(4'h0);


        if (pass_count != 9)
            $fatal(1,
                "Incomplete test: %0d/9",
                pass_count);

        $display("REGISTER4 TEST PASS: 9/9");

        $finish;
    end

endmodule
