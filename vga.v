module vga(clk,hsync,vsync,rgb_r,rgb_g,rgb_b,CLK,VGA_SYNC,VGA_BLANK);
     input               clk;
	  output   reg        hsync;
	  output   reg        vsync;
	  output   reg [7:0]  rgb_r;
	  output   reg [7:0]  rgb_g;
	  output   reg [7:0]  rgb_b;
	  output              CLK;
	  output              VGA_SYNC;
	  output              VGA_BLANK;
	  
	  
	  reg       [9:0]  x_cnt;
	  reg       [9:0]  y_cnt;
	  reg              valid;
	  wire      [9:0]  xpos; 
	  wire      [9:0]  ypos;
     wire             a_dis;
	  wire             b_dis;
	  wire             c_dis;
	  wire             d_dis;
     wire             e_rdy;
	  parameter	H_FRONT	=	16;
     parameter	H_SYNC	=	96;
     parameter	H_BACK	=	48;
     parameter	H_ACT	=	640;
     parameter	H_BLANK	=	H_FRONT+H_SYNC+H_BACK;
     parameter	H_TOTAL	=	H_FRONT+H_SYNC+H_BACK+H_ACT;
     
     parameter	V_FRONT	=	11;
     parameter	V_SYNC	=	2;
     parameter	V_BACK	=	31;
     parameter	V_ACT	=	480;
     parameter	V_BLANK	=	V_FRONT+V_SYNC+V_BACK;
     parameter	V_TOTAL	=	V_FRONT+V_SYNC+V_BACK+V_ACT;
	  assign           VGA_SYNC   = 1'b1;
	  assign           oVGA_BLANK = ~((x_cnt<H_BLANK)||(y_cnt<V_BLANK));
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
     assign CLK = ~clk;
     always @(posedge clk)
	  begin
	  if(x_cnt<10'd800-1) x_cnt <= x_cnt + 1'b1;
	  else x_cnt <= 0 ;
	  end
	  
	  always @(posedge clk)
	  begin
	  if(y_cnt<10'd525-1) y_cnt <= 1'b1;
	  else y_cnt <= 0;
	  end
	  assign ypos= y_cnt-10'd35;
	  assign xpos= x_cnt-10'd144;
	  always @(posedge clk)
	  begin
	  if(x_cnt==0) hsync=1'b0;
	  else if(x_cnt==10'd95) hsync=1'b1;
     end
	  always @(posedge clk)
	  begin
	  if(y_cnt==0) vsync <= 1'b0;
	  else if (y_cnt==10'd2) vsync =1'b1;
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
	  