`timescale 1ns/1ps
module tb_timer_top();
reg sys_clk;
reg sys_rst_n;
reg dbg_mode;
reg tim_psel;
reg tim_penable;
reg tim_pwrite;
reg [11:0] tim_paddr;
reg [31:0] tim_pwdata;
reg [3:0] tim_pstrb;
wire [31:0] tim_prdata;
wire tim_pready;
wire tim_pslverr;
wire tim_int;
reg [31:0] read_val;
integer err_count=0;
timer_top dut (
    .sys_clk(sys_clk),
    .sys_rst_n (sys_rst_n),
    .tim_psel(tim_psel),
    .tim_penable(tim_penable),
    .tim_pwrite(tim_pwrite),
    .tim_paddr(tim_paddr),
    .tim_pwdata(tim_pwdata),
    .tim_pstrb(tim_pstrb),
    .dbg_mode(dbg_mode),
    .tim_rdata(tim_prdata),
    .tim_pready(tim_pready),
    .tim_pslverr(tim_pslverr),
    .tim_int(tim_int)
);

initial begin
    sys_clk=0;
    forever #5 sys_clk=~sys_clk;
end

task sys_reset;
    begin
        sys_rst_n=0;
        dbg_mode=0;
        tim_psel=0;
        tim_penable= 0;
        tim_pwrite=0;
        tim_paddr=12'h0;
        tim_pwdata=32'h0;
        tim_pstrb=4'h0;
        #30;
        sys_rst_n=1;
        #20;
    end
endtask

task apb_write(input [11:0] addr, input [31:0] data, input [3:0] strb);
    begin
        @(posedge sys_clk); #1;
        tim_psel=1;
        tim_pwrite=1;
        tim_penable=0;
        tim_paddr=addr;
        tim_pwdata=data;
        tim_pstrb=strb;
        @(posedge sys_clk); #1;
        tim_penable=1;
        wait(tim_pready==1);
        @(posedge sys_clk); #1;
        tim_psel=0;
        tim_penable=0;
        tim_pwrite=0;
        tim_paddr=12'h0;
        tim_pwdata=32'h0;
        tim_pstrb=4'h0;
    end
endtask

task apb_read(input [11:0] addr, output [31:0] rdata);
    begin
        @(posedge sys_clk); #1;
        tim_psel=1;
        tim_pwrite=0;
        tim_penable=0;
        tim_paddr=addr;
        @(posedge sys_clk); #1;
        tim_penable=1;
        wait(tim_pready==1); #1;
        rdata=tim_prdata;
        @(posedge sys_clk); #1;
        tim_psel=0;
        tim_penable=0;
        tim_paddr=12'h0;
        #10;
    end
endtask

task apb_write_expect_err(input [11:0] addr, input [31:0] data, input [3:0] strb, input [255:0] test_name);
    begin
        @(posedge sys_clk); #1;
        tim_psel=1;
        tim_pwrite=1;
        tim_penable=0;
        tim_paddr=addr;
        tim_pwdata=data;
        tim_pstrb=strb;
        @(posedge sys_clk); #1;
        tim_penable=1;
        wait(tim_pready==1); #1;
        if(tim_pslverr===1'b1) begin
            $display("[PASS] %s (pslverr=1)", test_name);
        end else begin
            $display("[FAIL] %s EXPECTED pslverr=1, Got=%b", test_name, tim_pslverr);
            err_count=err_count+1;
        end
        @(posedge sys_clk); #1;
        tim_psel=0;
        tim_pwrite=0;
        tim_penable=0;
        tim_paddr=12'h0;
        tim_pwdata=32'h0;
        tim_pstrb=4'h0;
        #10;
    end
endtask

task apb_protocol_err(input [11:0] addr, input [31:0] data, input write_en, input psel_val, input penable_val);
    begin
        @(posedge sys_clk); #1;
        tim_psel=psel_val;
        tim_pwrite=write_en;
        tim_penable=0;
        tim_paddr=addr;
        tim_pwdata=data;
        tim_pstrb=4'b1111;
        @(posedge sys_clk); #1;
        tim_penable=penable_val;
        repeat(3) @(posedge sys_clk); #1;
        tim_psel=0;
        tim_pwrite=0;
        tim_penable=0;
        tim_paddr=12'h0;
        tim_pwdata=32'h0;
        tim_pstrb=4'h0;
        #10;
    end
endtask

task check_result(input [31:0] expected, input [31:0] actual, input[255:0] test_name);
    begin
        if(expected===actual) begin
            $display("[PASS] %s | Value= 32'h%h", test_name, actual);
        end else begin
            $display("[FAIL] %s | expected=32'h%h, Actual=32'h%h", test_name, expected, actual);
            err_count=err_count+1;
        end
    end
endtask

task check_signal(input expected, input actual, input [255:0] test_name);
    begin
        if(expected === actual) begin
            $display("[PASS] %s | Expected=%b, Actual=%b", test_name, expected,actual);
        end else begin
            $display("[FAIL] %s | Expected=%b, Actual=%b", test_name, expected,actual);
            err_count=err_count+1;
        end
    end
endtask

initial begin
    $dumpfile("timer_top.vcd");
    $dumpvars(0, tb_timer_top);
    $display("       STARING TIMER UP VERTIFICATION   ");
    sys_reset();
    `include "tcr_check.v"
    `include "tdr_check.v"
    `include "tcmp_check.v"
    `include "tier_check.v"
    `include "tisr_check.v"
    `include "thcsr_check.v"
    `include "pstrb_check.v"
    `include "reserved_reg.v"
    `include "apb_check.v"
    `include "timer_count_check.v"
    `include "interrupt_check.v"
    `include "tdr1_check.v"
    `include "tcmp1_check.v"
    `include "tc_dbg_mode.v"
    `include "tc_full_cov.v"
    `include "tc_apb_violation.v"
    `include "tc_peripheral_cov.v"
    `include "tc_sweep_all.v"
    `include "tc_core_cov.v"
    #50;
    $display("\n=======================================================");
    if (err_count==0)
        $display("=================== VERTIFICATION PASSED================== ");
    else
        $display("===================VERTIFICATION FAILED (%0d ERRORS)=====", err_count);
    $finish;
end
endmodule