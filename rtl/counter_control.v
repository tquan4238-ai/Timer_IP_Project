`timescale 1ns/1ps

module counter_control (
    input wire sys_clk, sys_rst_n, timer_en, div_en,
    input wire [3:0] div_val,
    input wire halt_req,
    input wire dbg_mode,
    output wire cnt_en, timer_en_fall, halt_ack
);

wire [7:0] limit;
assign limit = (8'd1 << div_val) - 8'd1;

reg [7:0] int_cnt;
wire cnt_rst;

assign cnt_rst = (~timer_en) | (~div_en) | (int_cnt == limit);

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        int_cnt <= 8'h00;
    end
    else begin
        if (halt_ack) begin
            int_cnt <= int_cnt;
        end
        else if (cnt_rst) begin
            int_cnt <= 8'h00;
        end
        else begin
            int_cnt <= int_cnt + 8'd1;
        end
    end
end

wire count_en;

wire mode_default = (~div_en) & timer_en;
wire mode_divided = div_en & timer_en & (div_val != 4'h0) & (int_cnt == limit);
wire mode_div_zero = div_en & timer_en & (div_val == 4'h0);

assign count_en = mode_default | mode_divided | mode_div_zero;

assign halt_ack = dbg_mode & halt_req;
assign cnt_en = count_en & (~halt_ack);

reg timer_en_d;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        timer_en_d <= 1'b0;
    end
    else begin
        timer_en_d <= timer_en;
    end
end

assign timer_en_fall = timer_en_d & (~timer_en);

endmodule