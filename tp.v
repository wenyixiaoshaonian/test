module	tp	(	
					 	rgb_r,
					 	rgb_g,
					  	rgb_b,
						hsync,
						vsync,
						VGA_SYNC,
			         VGA_BLANK,
						CLK,
                  TD_HS,
						TD_VS,
						TD_CLK,
						clk_n,
						addr,
						reset	);
output   reg[7:0]   rgb_r;
output   reg[7:0]   rgb_g;
output   reg[7:0]   rgb_b;
output	reg			hsync;
output	reg			vsync;
output				VGA_SYNC;
output				VGA_BLANK;
output	reg		   CLK;
output   reg [14:0]  addr;
input				TD_CLK;
input				reset;	
input           TD_HS;
input           TD_VS;
input           clk_n;
reg			[10:0]	x_cnt;
reg			[10:0]	y_cnt;
reg                  vaild;
reg                  a_dis;
reg                  b_dis;
reg                  c_dis;
reg                  d_dis;
reg                  x_dis;
reg                      x;
reg                      y;
reg                      i;
integer                  j;
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
assign	VGA_SYNC	=	1'b1;			
assign	VGA_BLANK	=	~((x_cnt<H_BLANK)||(y_cnt<V_BLANK));
     always @(posedge clk_n)
	  begin
      	CLK	=	~CLK;
	  end
	  always @(posedge CLK or negedge reset)
	  begin
	  if(!reset)
	  begin
	   rgb_r=0;
		rgb_g=0;
		rgb_b=0;
		end
		else
		begin
	  /* if(a_dis) r1=1;
		else      r1=0;
		if(b_dis) g1=1;
		else      g1=0;
		if(c_dis) b1=1;
		else      b1=0;
		if(d_dis) r2=1; 
		else      r2=0;*/
		if(vaild) addr <= (y_cnt-90)*128+(x_cnt-240);
		else      addr = 0;
	   end
		end

     always @(posedge CLK or negedge reset)
	  begin
	  if(!reset)
	   begin
	   x_cnt <= 0;
	   hsync <= 1;
	   end
	   else
	    begin 
	     if(x_cnt < H_TOTAL) 
		   x_cnt <= x_cnt + 1'b1;
	      else //if(x_cnt == H_TOTAL) 
			x_cnt <= 0;	  
	     if(x_cnt == H_FRONT-1)
		  hsync <= 1'b0;
	     if (x_cnt == H_FRONT+H_SYNC-1)
		  hsync <= 1'b1;
	    end
	  end
	  always @(posedge hsync or negedge reset)
	  begin
	  if(!reset)
	   begin
	   y_cnt <= 0;
	   vsync <= 1;
	   end
	  else
	    begin 
	     if(y_cnt < V_TOTAL) 
		  y_cnt <= y_cnt + 1'b1;
	      else  //if(y_cnt == V_TOTAL)  
			y_cnt <= 0;   
	     if(y_cnt == V_FRONT-1) 
		  vsync <= 1'b0;
	     if(y_cnt == V_FRONT+V_SYNC-1) 
		  vsync <=1'b1;
	    end
	  end
	   always @(posedge CLK or negedge reset)
     if(!reset)
     vaild <= 0;
    else
	 begin
     vaild <= (  (x_cnt > 11'd250)&& (x_cnt < 11'd740)&&(y_cnt > 11'd90)&&(y_cnt < 11'd490));
	  a_dis <= (  (x_cnt > 11'd250)&& (x_cnt < 11'd740)&&(y_cnt > 11'd90 )&&(y_cnt < 11'd140));
	  b_dis <= (  (x_cnt > 11'd690)&& (x_cnt < 11'd740)&&(y_cnt > 11'd140)&&(y_cnt < 11'd490));
	  c_dis <= (  (x_cnt > 11'd250)&& (x_cnt < 11'd690)&&(y_cnt > 11'd440)&&(y_cnt < 11'd490));
	  d_dis <= (  (x_cnt > 11'd250)&& (x_cnt < 11'd300)&&(y_cnt > 11'd140)&&(y_cnt < 11'd440));
	 end
	 endmodule
	 