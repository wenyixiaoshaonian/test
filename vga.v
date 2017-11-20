module vga(reset,clk,hsync,vsync,rgb_r,rgb_g,rgb_b,CLK,VGA_SYNC,VGA_BLANK,TD_DATA,TD_VS,TD_HS,TD_CLK,TD_RESET_N);
     input               TD_VS;
	  input        [7:0]  TD_DATA;
	  input               TD_HS;
	  input               TD_CLK;
	  input               clk;
	  input               reset;
	  output              TD_RESET_N;
	  output   reg        hsync;
	  output   reg        vsync;
	  output   wire  [7:0] rgb_r ;
	  output   wire  [7:0] rgb_g ;
	  output   wire  [7:0] rgb_b ;
	  output   reg        CLK;
	  output              VGA_SYNC;
	  output              VGA_BLANK;
	  
	  
	  
	  reg       [10:0]  x_cnt;
	  reg       [10:0]  y_cnt;
	  reg               valid;
	  wire      [9:0]   xpos; 
	  wire      [9:0]   ypos;
     wire              a_dis;
	  wire              b_dis;
	  wire              c_dis;
	  wire              d_dis;
     wire              e_rdy;
	  assign    TD_RESET_N = 1'B1;
	  assign    VGA_SYNC   = 1'b1;
	  assign    vga_BLANK  = ~((x_cnt<H_BLANK)||(y_cnt<V_BLANK));
	  assign    ypos= y_cnt-11'd35;
	  assign    xpos= x_cnt-11'd144;
	  parameter	H_FRONT	=	16;
     parameter	H_SYNC	=	96;
     parameter	H_BACK	=	48;
     parameter	H_ACT	=	640;
     parameter	H_BLANK	=	H_FRONT+H_SYNC+H_BACK;
     parameter	H_TOTAL	=	H_FRONT+H_SYNC+H_BACK+H_ACT;
	  
     parameter	V_FRONT	=	10;
     parameter	V_SYNC	=	2;
     parameter	V_BACK	=	33;
     parameter	V_ACT	=	480;
     parameter	V_BLANK	=	V_FRONT+V_SYNC+V_BACK;
     parameter	V_TOTAL	=	V_FRONT+V_SYNC+V_BACK+V_ACT; 
	 /* initial
	  begin
	  hsync = 1;
	  vsync = 1;
	  x_cnt = 0;
	  y_cnt = 0;
	  rgb_r = 8'd0;
	  rgb_g = 8'd0;
	  rgb_b = 8'd0;
	  end */
	  always @(posedge clk )
	  begin
	  CLK = ~CLK ;
	  end

     always @(posedge CLK)
	  begin
	  if(!reset)
	  begin
	  x_cnt <= 0;
	  hsync <= 1'b1;
	  end
	  else
	  begin 
	  if(x_cnt < H_TOTAL) x_cnt <= x_cnt + 1'b1;
	  else x_cnt <= 11'd0;	  
	  if(x_cnt == H_FRONT-1) hsync <= 1'b0;
	  if (x_cnt == H_FRONT+H_SYNC-1)hsync <= 1'b1;
	  end
	  end
	  always @(posedge hsync )
	  begin
	  if(!reset)
	  begin
	  y_cnt <= 0;
	  vsync <= 1'b1;
	  end
	  else
	  begin 
	  if(y_cnt < V_TOTAL) y_cnt <= y_cnt + 1'd1;
	  else    y_cnt <= 11'd0;   
	  if(y_cnt == V_FRONT-1) vsync <= 1'b0;
	  if(y_cnt == V_FRONT+V_SYNC-1) vsync <=1'b1;
	  end
	  end
	  always @ ( posedge CLK ) 
     begin                     
        valid <=    ( ( x_cnt >= 11'd50 ) && ( x_cnt <= 11'd640) && ( y_cnt >= 11'd35)   && ( y_cnt <= 11'd480) );  
     end

	 assign rgb_r=8'd1;
    assign rgb_g=valid?0:0;
    assign rgb_b=valid?0:0;

	  endmodule
	  