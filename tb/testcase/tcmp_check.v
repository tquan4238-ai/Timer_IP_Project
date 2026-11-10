$display("========================================");
$display("STARTING TEST SUITE: TCMP REGISTER CHECK(0x00C)");
$display("========================================");
apb_read(12'h00C, read_val);
check_result(32'hFFFF_FFFF, read_val, "TCMP-RESET VALUE CHECK(0xFFFF_FFFF)");

apb_write(12'h00C, 32'hA5A5_5A5A, 4'b1111);
apb_read(12'h00C, read_val);
check_result(32'hA5A5_5A5A, read_val, "TCMP-FULL 32 BIT R/W ACESSS(W/R A5A5_5A5A)");

apb_write(12'h00C, 32'h0000_0000, 4'b1111);

apb_write(12'h00C, 32'hBC12_3456, 4'b1000);
apb_read(12'h00C, read_val);
check_result(32'hBC00_0000, read_val, "TCMP-BYTE 0 ACCESS(STRB=1000,WRITE=BC12_3456=>Read BC00_0000)");


apb_write(12'h00C, 32'h0000_0000, 4'b1111);
apb_write(12'h00C, 32'hAAFE_DCBB, 4'b0110);
apb_read(12'h00C, read_val);
check_result(32'h00FE_DC00, read_val, "TCMP-BYTE 1&2 ACCESS (STRB=0110,WRITE AAFE_DCBB=>READ 00FE_DC00)");

apb_write(12'h00C, 32'hFFFF_FFFF, 4'b1111);