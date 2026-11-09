`timescale 1ns/1ps
module interrupt (
    input wire sys_clk, sys_rst_n,
    input wire [63:0] count,
    input wire [63:0] cmp_val,
    input wire int_en, tisr_wr_sel, tisr_wr_strb, tisr_wr_data,
    output wire int_st, tim_int
);
wire int_set;
assign int_set = (count == cmp_val);
wire int_clear;
reg int_st_reg;
assign int_clear = tisr_wr_sel & tisr_wr_strb & (tisr_wr_data == 1'b1) & int_st_reg;
wire mux1_out;
assign mux1_out = int_set ? 1'b1 : int_st_reg;
wire mux2_out;
assign mux2_out = int_clear ? 1'b0 : mux1_out;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        int_st_reg <= 1'b0;
    end else begin
        int_st_reg <= mux2_out;
    end
end
assign int_st = int_st_reg;
assign tim_int = int_st & int_en;
endmodule