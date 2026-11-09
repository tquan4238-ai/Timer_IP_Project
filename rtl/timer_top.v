`timescale 1ns/1ps
module timer_top(
    input wire sys_clk,
    input wire sys_rst_n, tim_psel, tim_penable, tim_pwrite,
    input wire [11:0] tim_paddr,
    input wire [31:0] tim_pwdata,
    input wire [3:0] tim_pstrb,
    output wire [31:0] tim_rdata,
    output wire tim_pready, tim_pslverr, tim_int,
    input wire dbg_mode
);
wire wr_en;
wire rd_en;
wire reg_err;
wire timer_en;
wire [3:0] div_val;
wire div_en;
wire halt_req;
wire halt_ack;
wire tdr0_wr_sel;
wire tdr1_wr_sel;
wire [31:0] tdr_wr_data;
wire [3:0] tdr_wr_strb;
wire [63:0] count;
wire cnt_en;
wire timer_en_fall;
wire [63:0] cmp_val;
wire int_en;
wire int_st;
wire tisr_wr_sel;
wire tisr_wr_data;
wire tisr_wr_strb;

apb_slave u_apb_slave(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .tim_psel(tim_psel),
    .tim_penable(tim_penable),
    .tim_pwrite(tim_pwrite),
    .reg_err(reg_err),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .tim_pready(tim_pready),
    .tim_pslverr(tim_pslverr)
);

register u_register(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .addr(tim_paddr),
    .wdata(tim_pwdata),
    .wstrb(tim_pstrb),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .rdata(tim_rdata),
    .reg_err(reg_err),
    .timer_en(timer_en),
    .div_en(div_en),
    .div_val(div_val),
    .halt_req(halt_req),
    .halt_ack(halt_ack),
    .tdr0_wr_sel(tdr0_wr_sel),
    .tdr1_wr_sel(tdr1_wr_sel),
    .tdr_wr_data(tdr_wr_data),
    .tdr_wr_strb(tdr_wr_strb),
    .count(count),
    .cmp_val(cmp_val),
    .int_en(int_en),
    .int_st(int_st),
    .tisr_wr_sel(tisr_wr_sel),
    .tisr_wr_data(tisr_wr_data),
    .tisr_wr_strb(tisr_wr_strb)
);

counter_control u_counter_control(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .timer_en(timer_en),
    .div_en(div_en),
    .div_val(div_val),
    .halt_req(halt_req),
    .dbg_mode(dbg_mode),
    .cnt_en(cnt_en),
    .timer_en_fall(timer_en_fall),
    .halt_ack(halt_ack)
);

counter u_counter(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .cnt_en(cnt_en),
    .timer_en_fall(timer_en_fall),
    .tdr0_wr_sel(tdr0_wr_sel),
    .tdr1_wr_sel(tdr1_wr_sel),
    .tdr_wr_data(tdr_wr_data),
    .tdr_wr_strb(tdr_wr_strb),
    .count(count)
);

interrupt u_interrupt(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .count(count),
    .cmp_val(cmp_val),
    .int_en(int_en),
    .tisr_wr_sel(tisr_wr_sel),
    .tisr_wr_strb(tisr_wr_strb),
    .tisr_wr_data(tisr_wr_data),
    .int_st(int_st),
    .tim_int(tim_int)
);

endmodule