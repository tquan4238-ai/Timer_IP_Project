`timescale 1ns/1ps
module register (
    input wire sys_clk, sys_rst_n,
    input wire [11:0] addr,
    input wire [31:0] wdata,
    input wire [3:0] wstrb,
    input wire wr_en, rd_en,
    output wire [31:0] rdata,
    output wire reg_err,

    output wire timer_en, div_en,
    output wire [3:0] div_val,
    output wire halt_req,
    input wire halt_ack,

    output wire tdr0_wr_sel, tdr1_wr_sel,
    output wire [31:0] tdr_wr_data,
    output wire [3:0] tdr_wr_strb,
    input wire [63:0] count,

    output wire [63:0] cmp_val,
    output wire int_en,
    input wire int_st,
    output wire tisr_wr_sel,
    output wire tisr_wr_data,
    output wire tisr_wr_strb
);

wire tcr_wr_sel;
wire tcmp0_wr_sel;
wire tcmp1_wr_sel;
wire tier_wr_sel;
wire thcsr_wr_sel;

assign tcr_wr_sel   = wr_en && (addr == 12'h000);
assign tdr0_wr_sel  = wr_en && (addr == 12'h004);
assign tdr1_wr_sel  = wr_en && (addr == 12'h008);
assign tcmp0_wr_sel = wr_en && (addr == 12'h00C);
assign tcmp1_wr_sel = wr_en && (addr == 12'h010);
assign tier_wr_sel  = wr_en && (addr == 12'h014);
assign tisr_wr_sel  = wr_en && (addr == 12'h018);
assign thcsr_wr_sel = wr_en && (addr == 12'h01C);

//wire addr_invalid;
//assign addr_invalid=(addr>12'h01C) | (addr[1:0] !=2'b00);
//assign addr_invalid=(addr[11:2]>10'd7);

assign tdr_wr_data = wdata;
assign tdr_wr_strb = wstrb;

wire err_div_val_invalid;
wire err_div_val_busy;
wire err_div_en_busy;
wire tcr_wr_valid;

assign err_div_val_invalid = tcr_wr_sel && wstrb[1] && (wdata[11:8] > 4'h8);
assign err_div_val_busy    = tcr_wr_sel && timer_en && wstrb[1] && (wdata[11:8] != div_val);
assign err_div_en_busy     = tcr_wr_sel && timer_en && wstrb[0] && (wdata[1] != div_en);
assign reg_err             = err_div_val_invalid | err_div_val_busy | err_div_en_busy;
assign tcr_wr_valid        = tcr_wr_sel && !reg_err;

reg timer_en_reg;
reg div_en_reg;
reg [3:0] div_val_reg;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        timer_en_reg <= 1'b0;
        div_en_reg   <= 1'b0;
        div_val_reg  <= 4'h1;
    end
    else if (tcr_wr_valid) begin
        if (wstrb[0]) begin
            timer_en_reg <= wdata[0];
            div_en_reg   <= wdata[1];
        end
        if (wstrb[1]) begin
            div_val_reg  <= wdata[11:8];
        end
    end
end

assign timer_en = timer_en_reg;
assign div_en   = div_en_reg;
assign div_val  = div_val_reg;

reg [31:0] tcmp0_reg;
reg [31:0] tcmp1_reg;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        tcmp0_reg <= 32'hFFFF_FFFF;
    end
    else if (tcmp0_wr_sel) begin
        if (wstrb[0]) tcmp0_reg[7:0]   <= wdata[7:0];
        if (wstrb[1]) tcmp0_reg[15:8]  <= wdata[15:8];
        if (wstrb[2]) tcmp0_reg[23:16] <= wdata[23:16];
        if (wstrb[3]) tcmp0_reg[31:24] <= wdata[31:24];
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        tcmp1_reg <= 32'hFFFF_FFFF;
    end
    else if (tcmp1_wr_sel) begin
        if (wstrb[0]) tcmp1_reg[7:0]   <= wdata[7:0];
        if (wstrb[1]) tcmp1_reg[15:8]  <= wdata[15:8];
        if (wstrb[2]) tcmp1_reg[23:16] <= wdata[23:16];
        if (wstrb[3]) tcmp1_reg[31:24] <= wdata[31:24];
    end
end

assign cmp_val = {tcmp1_reg, tcmp0_reg};

reg int_en_reg;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        int_en_reg <= 1'b0;
    end else if (tier_wr_sel && wstrb[0]) begin
        int_en_reg <= wdata[0];
    end
end

assign int_en = int_en_reg;

assign tisr_wr_data = wdata[0];
assign tisr_wr_strb = wstrb[0];

reg tisr_reg;
reg int_st_d;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        tisr_reg <= 0;
        int_st_d <= 1'b0;
    end else begin
        int_st_d <= int_st;
        if (tisr_wr_sel && wstrb[0] && wdata[0]) begin
            tisr_reg <= 1'b0;
        end
        else if (int_st && !int_st_d) begin
            tisr_reg <= 1'b1;
        end
    end
end

reg halt_req_reg;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        halt_req_reg <= 1'b0;
    end else if (thcsr_wr_sel && wstrb[0]) begin
        halt_req_reg <= wdata[0];
    end
end

assign halt_req = halt_req_reg;

reg [31:0] read_mux_out;

always @(*) begin
    case (addr)
        12'h000: read_mux_out = {20'h0, div_val_reg, 6'h0, div_en_reg, timer_en_reg};
        12'h004: read_mux_out = count[31:0];
        12'h008: read_mux_out = count[63:32];
        12'h00C: read_mux_out = tcmp0_reg;
        12'h010: read_mux_out = tcmp1_reg;
        12'h014: read_mux_out = {31'h0, int_en_reg};
        12'h018: read_mux_out = {31'h0, tisr_reg};
        12'h01C: read_mux_out = {30'h0, halt_ack, halt_req_reg};
        default: read_mux_out = 32'h0000_0000;
    endcase
end

assign rdata = rd_en ? read_mux_out : 32'h0000_0000;

endmodule