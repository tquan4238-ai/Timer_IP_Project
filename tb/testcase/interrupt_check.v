$display("========================================");
$display("STARTING TEST SUITE: INTERRUPT CHECK");
$display("========================================");

apb_write(12'h000, 32'h0000_0100, 4'b1111); // STOP TIMER
apb_write(12'h004, 32'h0000_0000, 4'b1111);
apb_write(12'h014, 32'h0000_0001, 4'b1111);

$display("Configuring TCMP=16 AND ENABLING INTERRUPT (TIER) ...");
apb_write(12'h00C, 32'h0000_0032, 4'b1111);
apb_write(12'h010, 32'h0000_0000, 4'b1111);

$display("=> Starting Timer..");
apb_write(12'h000, 32'h0000_0001, 4'b1111);

repeat(2000) @(posedge sys_clk);

apb_read(12'h004, read_val);
$display("DEBUG:TDR (COUNT)=%d", read_val);
apb_read(12'h00C, read_val);
$display("DEBUG:Tcmp0 =%d", read_val);

apb_read(12'h00C, read_val);
apb_read(12'h018, read_val);
check_result(32'h0000_0001, read_val, "INTERRUPT- Tisr Flag set to 1 after reaching TCMP");

$display("=> Clearing Interrupt flag(W1C)...");
apb_write(12'h018, 32'h0000_0001, 4'b1111);
apb_read(12'h018, read_val);
check_result(32'h0000_0000, read_val, "INTERRRUPT-TISR FLAG CLEARED TO 0 AFTER W1C");

apb_write(12'h000, 32'h0000_0100, 4'b1111);
apb_write(12'h010, 32'h0000_0000, 4'b1111);