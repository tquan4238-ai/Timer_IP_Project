$display("=>Starting test suite: CORE TIMER COVERAGE");
$display("========================================");
sys_reset();
apb_write(12'h000, 32'h0000_0100, 4'b1110);
apb_write(12'h000, 32'h0000_0000, 4'b1101);
apb_write(12'h000, 32'h0000_0000, 4'b0000);

apb_write(12'h004, 32'hFFFF_FF00, 4'b1110);
apb_write(12'h008, 32'hFFFF_FF00, 4'b1110);
apb_write(12'h0014, 32'h0000_0001, 4'b1110);
apb_write(12'h018, 32'h0000_0001, 4'b1110);
apb_write(12'h01C, 32'h0000_0001, 4'b1110);

apb_write(12'h014, 32'h0000_0001, 4'b1111);
sys_reset();

apb_write(12'h000, 32'h0000_0000,4'b1111);
apb_write(12'h000, 32'h0000_0002,4'b1111);
apb_write(12'h000, 32'h0000_0003,4'b1111);
repeat(5) @(posedge sys_clk);
apb_write(12'h000,32'h0000_0002,4'b1111);
apb_write(12'h000,32'h0000_0001,4'b1111);

sys_reset();
apb_write(12'h000,32'h0000_0000,4'b1111);
apb_write(12'h000,32'h0000_0802,4'b1111);
apb_write(12'h000,32'h0000_0803,4'b1111);
repeat(270) @(posedge sys_clk);
apb_write(12'h000, 32'h0000_0802,4'b1111);
apb_write(12'h000, 32'h0000_0000,4'b1111);


sys_reset();
apb_write(12'h018,32'h0000_0000,4'b1111);
apb_write(12'h004,32'h0000_0000,4'b1111);
apb_write(12'h008,32'h0000_0000,4'b1111);
apb_write(12'h00C,32'h0000_0005,4'b1111);
apb_write(12'h010,32'h0000_0000,4'b1111);
apb_write(12'h000,32'h0000_0001,4'b1111);
repeat(10) @(posedge sys_clk);
apb_write(12'h014, 32'h0000_0000,4'b1111);
apb_write(12'h014, 32'h0000_0001,4'b1111);