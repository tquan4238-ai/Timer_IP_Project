$display("========================================");
$display("STARTING TEST SUITE: PSTRB SIGNAL CHECK");
$display("========================================");

apb_write(12'h004, 32'h1234_5678, 4'b1111);
apb_read(12'h004, read_val);
check_result(32'h1234_5678, read_val, "PSTRB-VALID 32-BIT WRITE TO TDR(STRB=1111)");

//apb_read(12'h000, read_val);

apb_write(12'h018, 32'h0000_0001, 4'b1111);
apb_read(12'h018, read_val);
check_result(32'h0000_0000, read_val, "PSTRB- VALID STRB TO TISR(W1C)");

apb_write(12'h004, 32'h0000_0000, 4'b1111);