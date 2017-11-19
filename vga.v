module vga(clk,hsync,vsync,rgb_r,rgb_g,rgb_b,CLK,VGA_SYNC,VGA_BLANK);
     input            clk;
	  output           hsync;
	  output           vsync;
	  output    [7:0]  rgb_r;
	  output    [7:0]  rgb_g;
	  output    [7:0]  rgb_b;
	  output           CLK;
	  output           VGA_SYNC;
	  output           VGA_BLANK;
	  
	  
	  reg       [10:0] x_cnt;
	  reg       [9:0]  y_cnt;
	  