$display("========================================");
$display("STARTING TEST SUITE: TIMER COUNT & PRESCALER CHECK");
$display("========================================");

apb_write(12'h000,32'h0000_0100,4'b1111);
apb_write(12'h004,32'h0000_0000,4'b1111);

$display("=> Testing Basic Counter (No Prescaler) ...");
apb_write(12'h000, 32'h0000_0101,4'b1111);
repeat(20) @(posedge sys_clk);
apb_read(12'h004,read_val);
$display("TDR counted to: %0d (EXPECTED: ~20)", read_val);

apb_write(12'h000,32'h0000_0100,4'b1111);
apb_write(12'h004,32'h0000_0000,4'b1111);

$display("=> Testing Counter with Prescaler (divide by 5) ...");
apb_write(12'h000,32'h0000_0503,4'b1111);

repeat(50) @(posedge sys_clk);

apb_read(12'h004, read_val);
$display("TDR counted to: %0d (Expected: ~10)", read_val);

apb_write(12'h000,32'h0000_0100,4'b1111);
apb_write(12'h004,32'h0000_0000,4'b1111);