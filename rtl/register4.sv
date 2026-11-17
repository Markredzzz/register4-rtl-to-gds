/*
 * Lesson 06: 4-bit Register with Enable
 *
 * 中文目的：
 * 利用 DFF 與 Enable 控制建立 4-bit Register。
 * 練習狀態保持、同步 Reset 與多位元資料擷取。
 *
 * English Objective:
 * Implement a 4-bit register with synchronous
 * active-high reset and clock enable.
 *
 * Requirements / 規格：
 * 1. rst=1 at posedge: q becomes 0.
 * 2. rst=0, en=1 at posedge: q captures d.
 * 3. rst=0, en=0 at posedge: q holds its value.
 * 4. Reset has higher priority than Enable.
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


module register4 (
    input logic clk ,
    input logic rst ,
    input logic en ,
    input logic [3:0] d,
    output logic [3:0] q  
);

    // always_ff:
    // 正緣觸發的時序邏輯。
    // Executes on the rising edge of clk.

    always_ff @(posedge clk) begin

        // Check synchronous reset first.
        // Reset has the highest priority.

        if (rst) begin
            q <= 4'b0000 ;
        end


        // If reset is inactive, check enable.
        // Capture d when en=1.

        else if (en) begin
            q <= d ;
        end

        // When en=0, q must hold its value.
        // Think about whether an else is needed.

    end

endmodule



