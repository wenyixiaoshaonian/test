module	rd(
		input	wire		            sclk,
		input	wire		            s_rst_n,
		input	wire		            rd_en,
		input	wire	   [4:0]	      state,
		input	wire		            ref_req,		//自动刷新请求
		input	wire		            key_rd,			//来自外部的读请求信号
		input	wire	   [15:0]	   rd_dq,		//sdram的数据端口
		
		output	reg	[3:0]       sdram_cmd,
		output	reg	[11:0]      sdram_addr,
		output	reg	[1:0]	      sdram_bank,
		output	reg		         rd_req,			//读请求
		output	reg		         flag_rd_end	,	//突发读结束标志
		output   reg    [5:0]      out
		);

		parameter	     NOP    	=	4'b0111,
			           PRE	      =	4'b0010,
			           ACT     	=	4'b0011,
			           RD	      =	4'b0101,		//SDRAM的读命令（给读命令时需要给A10拉低）
			           CMD_END	=	4'd12,			//
			           COL_END	=	9'd508,			//最后四个列地址的第一个地址
			           ROW_END	=	12'd4095,		//行地址结束
			           AREF	   =	5'b00000,		//自动刷新状态
			           READ	   =	5'b01000;		//状态机的读状态
		
	reg	[11:0]	  row_addr;
	reg	[8:0]	     col_addr;
	reg	[3:0]	     cmd_cnt;
	reg		        flag_act;				//发送ACT命令标志（单独设立标志，便于跑高速）

	//assign     out =5;
//flag_act
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			flag_act	<=	1'b0;
		else if(flag_rd_end == 1'b1 && ref_req == 1'b1)
			flag_act	<=	1'b1;
		else if(flag_rd_end == 1'b1)
			flag_act	<=	1'b0;
//rd_req
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			rd_req	<=	1'b0;
		else if(rd_en == 1'b1)
			rd_req	<=	1'b0;
		else if(key_rd == 1'b1 && state != READ)
			rd_req	<=	1'b1;
//cmd_cnt
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			cmd_cnt	<=	4'd0;
		else if(state == READ)
			cmd_cnt	<=	cmd_cnt + 1'b1;
		else
			cmd_cnt	<=	4'd0;
//flag_rd_end
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			flag_rd_end	<=	1'b0;
		else if(cmd_cnt == CMD_END)
			flag_rd_end	<=	1'b1;
		else
			flag_rd_end	<=	1'b0;
//row_addr
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			row_addr	<=	12'd0;
		else if(row_addr == ROW_END && col_addr == COL_END && flag_rd_end == 1'b1)
			row_addr	<=	12'd0;
		else if(col_addr == COL_END && flag_rd_end == 1'b1)
			row_addr	<=	row_addr + 1'b1;
//col_addr
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			col_addr	<=	9'd0;
		else if(col_addr == COL_END && flag_rd_end == 1'b1)
			col_addr	<=	9'd0;
		else if(flag_rd_end == 1'b1)
			col_addr	<=	col_addr + 3'd4;
//sdram_cmd
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			sdram_cmd	<=	NOP;
		else case(cmd_cnt)
			4'd2:
				if(col_addr == 9'd0)
					sdram_cmd	<=	PRE;
				else
					sdram_cmd	<=	NOP;
			4'd3:	
				if(flag_act == 1'b1 || col_addr == 9'd0)
					sdram_cmd	<=	ACT;
				else
					sdram_cmd	<=	NOP;
			4'd4:
				sdram_cmd	<=	RD;
			default:
				sdram_cmd	<=	NOP;
		endcase
//sdram_addr
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			sdram_addr	<=	12'd0;
		else case(cmd_cnt)
			4'd4:
				sdram_addr	<=	{3'd0, col_addr};
			default:
				sdram_addr	<=	row_addr;
		endcase
//sdram_bank
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			sdram_bank	<=	2'd0;
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
	    out <= 0;
		else  case(cmd_cnt)
	       4'd0:
			 out  <=  5;
		    4'd1:
			 out  <=  1;
			 4'd2:
			 out  <=  2;
			 4'd3:
			 out  <=  3;
			 
			 
			default:
				out	<=	0;
		endcase	
endmodule
