module dispaly(
           input                key,
			  input                clk,
			  input                s_rst_n,
			  input  wire  [2:0]   rd,
			  output reg   [6:0]   h1,
			  output reg   [6:0]   h2,
			  output reg   [6:0]   h3,
			  output reg   [6:0]   h4
			  );
			  
	 reg  [2:0]   n;
	 reg  [3:0]   cnt;
	 always @(posedge clk or negedge s_rst_n)
	 begin
	  if(s_rst_n == 1'b0)
	  cnt <=0;
	  else if(cnt<8 && key == 1)
	  cnt = cnt+ 1'd1;
	  else 
	  cnt =0;
	  end
	 always @(posedge clk or negedge s_rst_n)
	  if(s_rst_n == 1'b0)
	  begin
	  h1 = 6'd0;
	  h2 = 6'd0;
	  h3 = 6'd0;
	  h4 = 6'd0;
	  end
	  else  case(cnt)
	    3'd4:
	    case (n)
		     3'd0:
		     h1 <= 7'b0111_111;
		     3'd1:
		     h1 <= 7'b0000_110;
	   	  3'd2:
		     h1 <= 7'b1011_011;
			  3'd3:
		     h1 <= 7'b1001_111;
			  2'd4:
		     h1 <= 7'b1100_110;
			  2'd5:
		     h1 <= 7'b1101_101;
			  2'd6:
		     h1 <= 7'b1111_101;
		endcase
		3'd5:
	    case (n)
		     3'd0:
		     h2 <= 7'b0111_111;
		     3'd1:
		     h2 <= 7'b0000_110;
	   	  3'd2:
		     h2 <= 7'b1011_011;
			  3'd3:
		     h2 <= 7'b1001_111;
			  2'd4:
		     h2 <= 7'b1100_110;
			  2'd5:
		     h2 <= 7'b1101_101;
			  2'd6:
		     h2 <= 7'b1111_101;
		endcase
		3'd6:
	    case (n)
		     3'd0:
		     h3 <= 7'b0111_111;
		     3'd1:
		     h3 <= 7'b0000_110;
	   	  3'd2:
		     h3 <= 7'b1011_011;
			  3'd3:
		     h3 <= 7'b1001_111;
			  2'd4:
		     h3 <= 7'b1100_110;
			  2'd5:
		     h3 <= 7'b1101_101;
			  2'd6:
		     h3 <= 7'b1111_101;
		endcase
		3'd7:
	    case (n)
		     3'd0:
		     h4 <= 7'b0111_111;
		     3'd1:
		     h4 <= 7'b0000_110;
	   	  3'd2:
		     h4 <= 7'b1011_011;
			  3'd3:
		     h4 <= 7'b1001_111;
			  2'd4:
		     h4 <= 7'b1100_110;
			  2'd5:
		     h4 <= 7'b1101_101;
			  2'd6:
		     h4 <= 7'b1111_101;
		endcase
		endcase
    always @(posedge clk or negedge s_rst_n)
	  if(s_rst_n == 1'b0)
	   begin
	 	 n <= 0;
		end
		else case (cnt)
          3'd4:
			  n  <=  rd;
			 default
			  n  <=  rd;
			  endcase
			  
	endmodule
	

	   