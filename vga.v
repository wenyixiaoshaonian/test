module vga(clk,hsync,vsync,rgb_r,rgb_g,rgb_b,CLK,VGA_SYNC,VGA_BLANK,TD_DATA,TD_VS,TD_HS,TD_CLK,TD_RESET_N);
     input               TD_VS;
	  input        [7:0]  TD_DATA;
	  input               TD_HS;
	  input               TD_CLK;
	  input               clk;
	  output              TD_RESET_N;
	  output   reg        hsync;
	  output   reg        vsync;
	  output   reg [7:0]  rgb_r;
	  output   reg [7:0]  rgb_g;
	  output   reg [7:0]  rgb_b;
	  output              CLK;
	  output              VGA_SYNC;
	  output              VGA_BLANK;
	  
	  
	  reg       [10:0]  x_cnt;
	  reg       [10:0]  y_cnt;
	  reg              valid;
	  wire      [9:0]  xpos; 
	  wire      [9:0]  ypos;
     wire             a_dis;
	  wire             b_dis;
	  wire             c_dis;
	  wire             d_dis;
     wire             e_rdy;
	  assign    TD_RESET_N = 1'B1;
	  assign    VGA_SYNC   = 1'b1;
	  assign    vga_BLANK  = 1'B0;
	  assign ypos= y_cnt-11'd35;
	  assign xpos= x_cnt-11'd144;
	  initial
	  begin
	  rgb_r = 0;
	  rgb_g = 0;
	  rgb_b = 0;
	  hsync = 1'b1;
	  vsync = 1'b1;
	  x_cnt = 0;
	  y_cnt = 0;
	  end
	  assign CLK = ~clk ;

     always @(posedge clk)
	  begin
	  if(x_cnt == 11'd1687) x_cnt = 11'd0;
	  else x_cnt = x_cnt + 1'b1;
	  end 
	  always @(posedge clk)
	  begin
	  if(y_cnt == 11'd1065) y_cnt = 11'd0;
	  else if (x_cnt == 11'd1687) y_cnt = y_cnt + 1;
	  end	  
	  always @(posedge clk)
	  begin
	  if(x_cnt==47) hsync <= 1'b0;
	  else if(x_cnt==11'd159) hsync <= 1'b1;
     end
	  always @(posedge clk)
	  begin
	  if(y_cnt==0) vsync <= 1'b0;
	  else if (y_cnt==11'd3) vsync <=1'b1;
	  end
	  always @ ( posedge clk ) 
     begin                     
        valid <=    ( ( x_cnt >= 10'd144 ) && ( x_cnt <= 10'd784) && ( y_cnt >= 10'd35)   && ( y_cnt <= 10'd515) );  
     end
	  assign a_dis=((xpos>=200)&&(xpos<=220))&&((ypos>=140)&&(ypos<=460));
	  assign b_dis=((xpos>=580)&&(xpos<=600))&&((ypos>=140)&&(ypos<=460));
	  assign c_dis=((xpos>=220)&&(xpos<=580))&&((ypos>=140)&&(ypos<=460));
	  assign d_dis=((xpos>=220)&&(xpos<=580))&&((ypos>=440)&&(ypos<=460));
	  assign e_dis=((xpos>=385)&&(xpos<=415))&&((ypos>=285)&&(ypos<=315));
	  always@(posedge clk )
	  begin
	  if (valid & e_rdy) rgb_r <=8'b11110000;
	  else if (valid & (a_dis | b_dis | c_dis | d_dis)) rgb_g <= 8'b11110000;
	  else if (valid & ~(a_dis | b_dis | c_dis | d_dis)) rgb_b <= 8'b11110000;
     end
	  endmodule
	  