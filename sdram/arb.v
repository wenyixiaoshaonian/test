module arb (
             input               sclk,
				 input               s_rst_n,
				 input               key,
				 input               flag_init_end,
				 input               ref_req,
				 input               wr_req,
				 input               rd_req,
				 input               flag_ref_end,
				 input               flag_rd_end,
				 input               flag_wr_end,
				 output  reg         rd_en,
				 output  reg         wr_en,
				 output  reg         ref_en,
				 output  reg   [4:0] state
				 );
     parameter     INIT  =  5'b00001,
	                IDLE  =  5'b00010,
                   ARBIT =  5'b00100,
                   READ  =  5'b01000,
                   WRITE =  5'b10000,
 						 AREF  =  5'b00000;
	//  reg   [4:0]  state;
	  always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
		  begin
		  rd_en  = 1'd0;
		  wr_en  = 1'd0;
		  ref_en = 1'd0;
		  end
		else if (wr_req == 1'd1)
		       wr_en = 1'd1;
		else if (rd_req == 1'd1)
		       rd_en = 1'd1;
		else if (ref_req == 1'd1)
		       ref_en = 1'd1;
     always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			state	<=	IDLE;
		else case(state)
			IDLE:
				if(key == 1'b1)
					state	<=	INIT;
				else
					state	<=	IDLE;
			INIT:
				if(flag_init_end == 1'b1)	//初始化结束标志
					state	<=	ARBIT;
				else
					state	<=	INIT;
			ARBIT:
				if(ref_req == 1'b1 && ref_en == 1'b0)	//刷新请求到来且已经写完
					state	<=	AREF;
				else if(ref_req == 1'b0 && rd_en == 1'b1)	//默认读操作优先于写操作
					state	<=	READ;			
				else if(ref_req == 1'b0 && wr_en == 1'b1)	//无刷新请求且写请求到来
					state	<=	WRITE;
				else
					state	<=	ARBIT;
			AREF:
				if(flag_ref_end == 1'b1)
					state	<=	ARBIT;
				else
					state	<=	AREF;
			WRITE:
				if(flag_wr_end == 1'b1)
					state	<=	ARBIT;
				else
					state	<=	WRITE;
			READ:
				if(flag_rd_end == 1'b1)
					state	<=	ARBIT;
				else
					state	<=	READ;
			default:
				state	<=	IDLE;			
		endcase	
  endmodule
  