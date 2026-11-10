$display("========================================");
$display("STARTING TEST SUITE: TIER REGISTER CHECK(0x014)");
$display("========================================");
apb_read(12'h014, read_val);
check_result(32'h0000_0000, read_val, "TIER-RESET VALUE CHECK(0x0000_0000)");

apb_write(12'h014, 32'h0000_0001, 4'b1111);
apb_read(12'h014, read_val);
check_result(32'h0000_0001,read_val, "TIER-VALID  R/W ACESSS(Write 0001 => Read 0001)");


apb_write(12'h014, 32'hFFFF_FFFF,4'b1111);
apb_read(12'h014,read_val);
check_result(32'h0000_0001, read_val, "TIER-RESERVED BITS RAZ/WI (WRITE FFFF_FFFF=>READ 0001)");


apb_write(12'h014, 32'h0000_0000, 4'b1111);