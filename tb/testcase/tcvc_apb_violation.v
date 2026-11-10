$display("=>TESTING APB ILLEGAL STATES FOR EXXPRESSION COVERAGE");
@(posedge sys_clk);
tim_psel=1'b0;
tim_penable=1'b0;
tim_pwrite=1'b0;
tim_paddr=12'h000;

@(posedge sys_clk);
tim_pwrite=1'b0;
tim_penable=1'b1;
tim_psel=1'b0;

@(posedge sys_clk);
tim_paddr=12'hFFF;
tim_pwrite=1'b1;
tim_penable=1'b1;
tim_psel=1'b0;

@(posedge sys_clk);
tim_paddr=12'hFFF;
tim_pwrite=1'b1;
tim_psel=1'b1;
tim_penable=1'b0;

@(posedge sys_clk);
tim_psel=1'b0;
tim_penable=1'b0;