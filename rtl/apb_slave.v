`timescale 1ns/1ps

module apb_slave(
    input wire sys_clk,
    input wire sys_rst_n,
    input wire tim_psel,
    input wire tim_penable,
    input wire tim_pwrite,
    input wire reg_err,

    output wire wr_en,
    output wire rd_en,
    output wire tim_pready,
    output wire tim_pslverr
);

assign wr_en = tim_psel & tim_penable & tim_pwrite;
assign rd_en = tim_psel & tim_penable & !tim_pwrite;

reg pready_delay;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        pready_delay = 1'b0;
    end
    else begin
        if (tim_psel & tim_penable & !pready_delay) begin
            pready_delay <= 1'b1;
        end
        else begin
            pready_delay <= 1'b0;
        end
    end
end

assign tim_pready = pready_delay;
assign tim_pslverr = reg_err & tim_psel & tim_penable;

endmodule