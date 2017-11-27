module dispaly(
           input                key,
			  input                clk,
			  input                s_rst_n,
			  input        [5:0]   rd,
			  output reg   [6:0]   h1,
			  output reg   [6:0]   h2,
			  output reg   [6:0]   h3,
			  output reg   [6:0]   h4
			  );
			  
	 reg  [5:0]   n;
	 reg  [3:0]   cnt;
	 always @(posedge clk or negedge s_rst_n)
	 begin
	  if(s_rst_n == 1'b0)
	  cnt =0;
	  else if(cnt<8 && key == 1)
	  cnt = cnt+ 1'd1;
	  else 
	  cnt =0;
	  end
	 always @(posedge clk or negedge s_rst_n or negedge key)
	 
	  if(s_rst_n == 1'b0)
	  begin
	  h1 = 7'd0;
	  h2 = 7'd0;
	  h3 = 7'd0;
	  h4 = 7'd0;
	  end
	  else if(key == 0)
	  begin
	  h1 = 7'd0;
	  h2 = 7'd0;
	  h3 = 7'd0;
	  h4 = 7'd0;
	  end
	  else  case(cnt)
	    4'd2:
	    case (n)
		     6'd0:
		     h1 = 7'b1000_000;
		     6'd1:
		     h1 = 7'b1111_001;
	   	  6'd2:
		     h1 = 7'b0100_100;
			  6'd3:
		     h1 = 7'b0110_000;
			  6'd4:
		     h1 = 7'b0011_001;
			  6'd5:
		     h1 = 7'b0010_010;
			  6'd6:
		     h1 = 7'b0000_010;
		endcase
		3'd3:
	    case (n)
		     6'd0:
		     h2 = 7'b1000_000;
		     6'd1:
		     h2 = 7'b1111_001;
	   	  6'd2:
		     h2 = 7'b0100_100;
			  6'd3:
		     h2 = 7'b0110_000;
			  6'd4:
		     h2 = 7'b0011_001;
			  6'd5:
		     h2 = 7'b0010_010;
			  6'd6:
		     h1 = 7'b0000_010;
		endcase
		3'd4:
	    case (n)
		     6'd0:
		     h3 = 7'b1000_000;
		     6'd1:
		     h3 = 7'b1111_001;
	   	  6'd2:
		     h3 = 7'b0100_100;
			  6'd3:
		     h3 = 7'b0110_000;
			  6'd4:
		     h3 = 7'b0011_001;
			  6'd5:
		     h3 = 7'b0010_010;
			  6'd6:
		     h3 = 7'b0000_010;
		endcase
		3'd5:
	    case (n)
		     6'd0:
		     h4 = 7'b1000_000;
		     6'd1:
		     h4 = 7'b1111_001;
	   	  6'd2:
		     h4 = 7'b0100_100;
			  6'd3:
		     h4 = 7'b0110_000;
			  6'd4:
		     h4 = 7'b0011_001;
			  6'd5:
		     h4 = 7'b0010_010;
			  6'd6:
		     h4 = 7'b0000_010;
		endcase
		endcase
    always @(posedge clk or negedge s_rst_n)
	  if(s_rst_n == 1'b0)
	   begin
	 	 n = 0;
		end
		else case (cnt)
			  4'd2:
			  n  =  rd;
			  4'd3:
			  n  =  rd;
			  4'd4:
			  n  =  rd;
			 default
			  n  =  0;
			  endcase
			  
	endmodule
	

	   