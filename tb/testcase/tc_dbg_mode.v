$display("STARTING TEST SUITE: DEBUG MODE (HALTED)");
$display("========================================");
apb_write(12'h000, 32'h0000_0100, 4'b1111);
apb_write(12'h004, 32'h0000_0000, 4'b1111);
apb_write(12'h000, 32'h0000_0001, 4'b1111);

repeat(20) @(posedge sys_clk);
$display("=> Entering Debug Mode and Requesting Halt...");
dbg_mode=1'b1;

apb_write(12'h01C, 32'h0000_0001,4'b1111);

repeat(5) @(posedge sys_clk);
apb_read(12'h01C, read_val);
check_result(32'h0000_0003, read_val, "DBG_MODE-halt_req and halt_ack must be 1");

apb_read(12'h004, read_val);
$display("=> Counter Value when halted: %d",read_val);

repeat(50) @(posedge sys_clk);
apb_read(12'h004, read_val);
$display("=> Counter Value after 50 wait cycles: %d", read_val);

$display("Exiting Halt Mode...");
apb_write(12'h01C, 32'h0000_0000,4'b1111);
dbg_mode=1'b0;

repeat(20) @(posedge sys_clk);
$display("TEST SUIT DBG_MODE COMPLETED");