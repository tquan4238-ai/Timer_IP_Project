$display("========================================");
$display("STARTING TEST SUITE: RESERVED ADDRESS CHECK");
$display("========================================");

//apb_write_expect_err(12'h020,32'hDEAD_BEEF,4'b1111,"RESERVED - WRITE TO INTERNAL GAP (0x008)");

//apb_write_expect_err(12'h100, 32'h1234_5678, 4'b1111,"RESERVED - WRITE TO OUT OF BOUNDS ADDRESS (0x100)");

//apb_write_expect_err(12'h3FC,32'hABCD_EFEF,4'b1111,"RESERVED - WRITE TO LAST RESERVED ADDR (0x3FC)");
apb_read(12'h020, read_val);
check_result(32'h0000_0000,read_val, "RESERVED-READ FROM UNMAPPED ADDRESS RETURNS 0 (0x020)");