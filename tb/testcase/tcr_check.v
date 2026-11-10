$display("========================================");
$display("STARTING TEST SUITE: TCR REGISTER CHECK(0x000)");
$display("========================================");
apb_read(12'h000, read_val);
check_result(32'h0000_0100, read_val, "TCR-Reset Value Check(0x0100)");
apb_write(12'h000, 32'hFFF_F602, 4'b1111);
apb_read(12'h000, read_val);
check_result(32'h0000_0602, read_val, "TCR-Valid R/W &RAZ/WI(Write FFF_F602 => Read 0602)");
apb_write(12'h000,32'h0000_0100,4'b1111);

apb_write_expect_err(12'h000,32'h0000_0900, 4'b1111, "TCR-Catch invalid div_val write=9(>8)");
apb_read(12'h000, read_val);
check_result(32'h0000_0100, read_val, "TCR- Reject div_val>8, value remains 0x0100");

apb_write(12'h000, 32'h0000_0501,4'b1111);
apb_read(12'h000,read_val);
check_result(32'h0000_0501, read_val, "TCR-Initialize Timer running (TCR=0X0501)");

apb_write_expect_err(12'h000, 32'h0000_0601,4'b1111, "TCR - Catch div_val modification while Timer is running");
apb_read(12'h000,read_val);
check_result(32'h0000_0501, read_val, "TCR-div_val protected, value remains 0X0501");

apb_write_expect_err(12'h000, 32'h0000_0503,4'b1111, "TCR - Catch div_val modification while Timer is running");
apb_read(12'h000,read_val);
check_result(32'h0000_0501, read_val, "TCR-div_val protected, value remains 0X0501");

apb_write(12'h000, 32'h0000_0100, 4'b1111);