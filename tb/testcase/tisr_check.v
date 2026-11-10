$display("========================================");
$display("STARTING TEST SUITE: TISR REGISTER CHECK(0x018)");
$display("========================================");
apb_read(12'h018, read_val);
check_result(32'h0000_0000, read_val, "TISR-RESET VALUE CHECK(0x0000_0000)");

apb_write(12'h018, 32'h0000_0001, 4'b1111);
apb_read(12'h014, read_val);
check_result(32'h0000_0000, read_val, "TISR-SW canot set flag (WRITE 0001=>READ 0000)");

apb_write(12'h018, 32'hFFFF_FFFF,4'b1111);
apb_read(12'h018,read_val);
check_result(32'h0000_0000, read_val, "TISR-RESERVED BITS RAZ/WI (WRITE FFFF_FFFF=>READ 0000)");