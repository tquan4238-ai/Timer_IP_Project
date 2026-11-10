$display("=>Starting test suite: PERIPHERAL COVERAGE");
$display("========================================");

$display("=> TESTING PARTIAL BYTE WRITES (WSTRB)...");
apb_write(12'h004, 32'hFFFF_FF00, 4'b1110);
apb_write(12'h004, 32'hFFFF_00FF, 4'b1101);

$display("TESTING APB PROTOCOL ILLEGAL STATES....");
@(posedge sys_clk);
tim_psel=1'b1;
tim_penable=1'b0;
tim_pwrite=1'b1;
tim_paddr=12'hFFF;

@(posedge sys_clk);
//tim_pwrite=1'b0;
tim_penable=1'b1;
tim_psel=1'b0;

@(posedge sys_clk);
tim_paddr=12'hFFF;
tim_pwrite=1'b1;
tim_penable=1'b0;
tim_psel=1'b1;

@(posedge sys_clk);
//tim_paddr=12'hFFF;
//tim_pwrite=1'b1;
tim_psel=1'b1;
tim_penable=1'b0;

@(posedge sys_clk);
tim_psel=1'b0;
tim_penable=1'b0;

$display("=>TESTING TESTBENCH CHECKER (NEGATIVE CHECK)....");
//check_result(32'hDEAD_BEEF, 32'h0000_0000,"TB_SELF_CHECK: INTENTIONAL MISMATCH");