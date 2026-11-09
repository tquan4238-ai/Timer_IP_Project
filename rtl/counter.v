`timescale 1ns/1ps
module counter(
    input wire sys_clk, sys_rst_n, cnt_en, timer_en_fall, tdr0_wr_sel, tdr1_wr_sel,
    input wire [31:0] tdr_wr_data,
    input wire [3:0] tdr_wr_strb,
    output wire [63:0] count
);
reg [31:0] tdr0_reg;
reg [31:0] tdr1_reg;
assign count={tdr1_reg, tdr0_reg};
wire [63:0] count_plus_1=count+64'd1;
wire [31:0] tdr0_mux1_out;
assign tdr0_mux1_out=cnt_en ? count_plus_1[31:0]: tdr0_reg;
wire [31:0] tdr0_mux2_out;
assign tdr0_mux2_out[7:0]=(tdr_wr_sel & tdr_wr_strb[0]) ? tdr_wr_data[7:0]: tdr0_mux1_out[7:0];
assign tdr0_mux2_out[15:8]=(tdr_wr_sel & tdr_wr_strb[1]) ? tdr_wr_data[15:8]: tdr0_mux1_out[15:8];
assign tdr0_mux2_out[23:16]=(tdr_wr_sel & tdr_wr_strb[2]) ? tdr_wr_data[23:16]: tdr0_mux1_out[23:16];
assign tdr0_mux2_out[31:24]=(tdr_wr_sel & tdr_wr_strb[3]) ? tdr_wr_data[31:24]: tdr0_mux1_out[31:24];
wire [31:0] tdr0_mux3_out;
assign tdr0_mux3_out=timer_en_fall ? 32'h0000_0000:tdr0_mux2_out;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        tdr0_reg<=32'h0000_0000;
    else begin
        tdr0_reg<=tdr0_mux3_out;
    end
end
wire [31:0] tdr1_mux1_out;
assign tdr1_mux1_out = cnt_en ? count_plus_1[63:32]: tdr1_reg;
wire [31:0] tdr1_mux2_out;
assign tdr1_mux2_out[7:0]=(tdr1_wr_sel & tdr_wr_strb[0]) ? tdr_wr_data[7:0]: tdr1_mux1_out[7:0];
assign tdr1_mux2_out[15:8]=(tdr1_wr_sel & tdr_wr_strb[1]) ? tdr_wr_data[15:8]: tdr1_mux1_out[15:8];
assign tdr1_mux2_out[23:16]=(tdr1_wr_sel & tdr_wr_strb[2]) ? tdr_wr_data[23:16]: tdr1_mux1_out[23:16];
assign tdr1_mux2_out[31:24]=(tdr1_wr_sel & tdr_wr_strb[3]) ? tdr_wr_data[31:24]: tdr1_mux1_out[31:24];
wire [31:0] tdr1_mux3_out;
assign tdr1_mux3_out=timer_en_fall ? 32'h0000_0000: tdr1_mux2_out;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        tdr1_reg<=32'h0000_0000;
    else begin
        tdr1_reg <= tdr1_mux3_out;
    end
end
endmodule