$display("========================================");
$display("STARTING TEST SUITE: THCSR REGISTER CHECK(0x01C)");
$display("========================================");
apb_read(12'h01C,read_val);
check_result(32'h0000_0000, read_val, "THCSR-RESET VALUE CHECK(0x0000_0000)");

apb_write(12'h01C, 32'h0000_0001, 4'b1111);
apb_read(12'h01C, read_val);
check_result(32'h0000_0001,read_val, "THCSR-VALID R/W ACCESS (WRITE 0001=>READ 0001)");


apb_write(12'h01C, 32'hFFFF_FFFF,4'b1111);
apb_read(12'h01C,read_val);
check_result(32'h0000_0001, read_val, "THCSR-RESERVED BITS RAZ/WI (WRITE FFFF_FFFF=>READ 0001)");

apb_write(12'h01C, 32'h0000_0000,4'b1111);