$display("========================================");
$display("STARTING TEST SUITE: TDR1 REGISTER CHECK(0x008)");
$display("========================================");
sys_reset();

apb_read(12'h008, read_val);
check_result(32'h0000_0000, read_val, "TDR1-RESET VALUE CHECK(0X0000_0000)");

apb_write(12'h008, 32'hDEAD_BEEF, 4'b1111);
apb_read(12'h008, read_val);
check_result(32'hDEAD_BEEF,read_val, "TDR1-FULL 32 BIT R/W ACESSS(W/R DEAD_BEEF)");

apb_write(12'h008,32'h0000_0000,4'b1111);

apb_write(12'h008, 32'h1234_ABCD,4'b0001);
apb_read(12'h008,read_val);
check_result(32'h0000_00CD, read_val, "TDR1-BYTE 0 ACCESS(STRB=0001,WRITE=1234_ABCD=>Read 00CD)");


apb_write(12'h008, 32'h8765_4321,4'b0011);
apb_read(12'h008,read_val);
check_result(32'h0000_4321, read_val, "TDR1-HALF-WORD ACCESS (STRB=0011,WRITE 8765_4321=>READ 4321");

apb_write(12'h008, 32'h0000_0000, 4'b1111);