$display("=>Running sweep testcases");
$display("========================================");

apb_write(12'h004, 32'hFFFF_FF00, 4'b1110);
apb_write(12'h004, 32'hFFFF_00FF, 4'b1101);

@(posedge sys_clk);
tim_paddr=12'hFFF; tim_pwrite=1'b1;
@(posedge sys_clk);
tim_psel=1'b0; tim_penable=1'b1;
@(posedge sys_clk);
tim_paddr=12'hFFF; tim_pwrite=1'b1;
@(posedge sys_clk);
tim_psel=1'b0; tim_penable=1'b0;
@(posedge sys_clk);
tim_psel=1'b0; tim_penable=1'b0;

apb_write(12'h000, 32'h0000_0101, 4'b1111);
apb_write(12'h000, 32'h0000_0001, 4'b1111);
apb_write(12'h000, 32'h0000_0100, 4'b1111);

apb_write(12'h000, 32'h0000_0103, 4'b1111);
repeat(15) @(posedge sys_clk);
apb_write(12'h000, 32'h0000_0003, 4'b1111);

apb_write(12'h014, 32'h0000_0001, 4'b1111);
apb_write(12'h004, 32'h0000_0000, 4'b1111);
apb_write(12'h00C, 32'h0000_0005, 4'b1111);
apb_write(12'h018, 32'h0000_0000, 4'b1111);
apb_write(12'h000, 32'h0000_0001, 4'b1111);

repeat(10) @(posedge sys_clk);
apb_write(12'h018, 32'h0000_0001, 4'b1111);