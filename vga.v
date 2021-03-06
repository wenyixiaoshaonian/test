module	vga	(	
					 	r1,r2,r3,r4,
					 	g1,g2,g3,g4,
					  	b1,b2,b3,b4,
						hsync,
						vsync,
						VGA_SYNC,
			         VGA_BLANK,
						CLK,
                  TD_HS,
						TD_VS,
						TD_CLK,
						clk_n,
						reset	);
output   reg   r1,r2,r3,r4;
output   reg   g1,g2,g3,g4;
output   reg   b1,b2,b3,b4;
output	reg			hsync;
output	reg			vsync;
output				VGA_SYNC;
output				VGA_BLANK;
output	reg		CLK;

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
	   r1=0;r2=0;r3=0;r4=0;
      g1=0;g2=0;g3=0;g4=0;
      b1=0;b2=0;b3=0;b4=0;
		end
		else
		begin
	   if(a_dis) r1=1;
		else      r1=0;
		if(b_dis) g1=1;
		else      g1=0;
		if(c_dis) b1=1;
		else      b1=0;
		if(d_dis) r2=1; 
		else      r2=0;
		if(vaild) begin g2 =1; r3=1;end
		else      begin g2 =0; r3=0;end
       if(x_dis) b2=1;
       else      b2=0;
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
     vaild <= (  (x_cnt > 11'd430)&& (x_cnt < 11'd530)&&(y_cnt > 11'd240)&&(y_cnt < 11'd340));
	  a_dis <= (  (x_cnt > 11'd250)&& (x_cnt < 11'd740)&&(y_cnt > 11'd90 )&&(y_cnt < 11'd140));
	  b_dis <= (  (x_cnt > 11'd690)&& (x_cnt < 11'd740)&&(y_cnt > 11'd140)&&(y_cnt < 11'd490));
	  c_dis <= (  (x_cnt > 11'd250)&& (x_cnt < 11'd690)&&(y_cnt > 11'd440)&&(y_cnt < 11'd490));
	  d_dis <= (  (x_cnt > 11'd250)&& (x_cnt < 11'd300)&&(y_cnt > 11'd140)&&(y_cnt < 11'd440));
	 end
   /*  always @(posedge CLK or negedge reset)
     begin
     if(!reset)
	  begin
     i = 0;
	  x_dis = 0;
	  end
     else
	  begin
	   x_dis = ( (x_cnt >300+i)&&(x_cnt <i+301)&&(y_cnt > i+340)&&(y_cnt <y+341));
		i = i+1;
		if(i==440) i = 0;
	  end
     end
     always @(posedge TD_CLK or negedge reset)
     begin
     if(!reset)
     j = 300;
     else
     for(j=340;j<440;j=j+1)
	  y = j;
     end  
     always @(posedge TD_CLK or negedge reset)
     begin
     if(!reset)
     x_dis = 0;
     else
      x_dis = ( (x_cnt >x)&&(x_cnt <x+1)&&(y_cnt >y)&&(y_cnt <y+1));
      end*/
	  endmodule
	  