module	wr(
		input	wire		           sclk,
		input	wire		           s_rst_n,
		input	wire		           key_wr,
		input	wire		           wr_en,		//来自仲裁模块的写使能
		input	wire		           ref_req,	//来自刷新模块的刷新请求
		input wire     [4:0]      state1,
		output   reg   [15:0]     sdram_dq,
		//output	reg	[3:0]	     sdram_dqm,	//输入/输出掩码
		output	reg	[11:0]	  sdram_addr,	//sdram地址线
		output	reg	[1:0]	     sdram_bank,	//sdram的bank地址线
		output	reg	[3:0]	     sdram_cmd,	//sdram的命令寄存器
		output	reg		        wr_req,		//写请求（不在写状态时向仲裁进行写请求）
		output	reg		        flag_wr_end	//写结束标志（有刷新请求来时，向仲裁输出写结束）
		);
		
	parameter	NOP	   =	4'b0111,	//NOP命令
			      ACT	   =	4'b0011,	//ACT命令
			      WR       =	4'b0100,	//写命令（需要将A10拉高）
			      PRE	   =	4'b0010,	//precharge命令
			      CMD_END	=	4'd8,
			      COL_END	=	9'd508,		//最后四个列地址的第一个地址
			      ROW_END	=	12'd4095,	//行地址结束
			      AREF	   =	5'b00100,	//自动刷新状态
			      WRITE   	=	5'b10000;	//状态机的写状态
			 
	reg		       flag_act;			//需要发送ACT的标志			
	reg	[3:0]	    cmd_cnt;			//命令计数器
	reg	[11:0]    row_addr;			//行地址
	reg	[11:0]	 row_addr_reg;			//行地址寄存器
	reg	[8:0]	    col_addr;			//列地址
	reg		       flag_pre;			//在sdram内部为写状态时需要给precharge命令的标志
//flag_pre
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			flag_pre	<=	1'b0;
		else if(col_addr == 9'd0 && flag_wr_end == 1'b1)
			flag_pre	<=	1'b1;
		else if(flag_wr_end == 1'b1)
			flag_pre	<=	1'b0;
	
//flag_act
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			flag_act	<=	1'b0;
		else if(flag_wr_end)
			flag_act	<=	1'b0;
		else if(ref_req == 1'b1 && state1 == AREF)
			flag_act	<=	1'b1;
//wr_req
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			wr_req	<=	1'b0;
		else if(wr_en == 1'b1)
			wr_req	<=	1'b0;
		else if(state1 != WRITE && key_wr == 1'b1)
			wr_req	<=	1'b1;
//flag_wr_end
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			flag_wr_end	<=	1'b0;
		else if(cmd_cnt == CMD_END)
			flag_wr_end	<=	1'b1;
		else
			flag_wr_end	<=	1'b0;
//cmd_cnt
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			cmd_cnt	<=	4'd0;
		else if(state1 == WRITE)
			cmd_cnt	<=	cmd_cnt + 1'b1;
		else 
			cmd_cnt	<=	4'd0;
		
//sdram_cmd
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			sdram_cmd	<=	4'd0;
		else case(cmd_cnt)
			3'd1:
				if(flag_pre == 1'b1)
					sdram_cmd	<=	PRE;
				else
					sdram_cmd	<=	NOP;
			3'd2:
				if(flag_act == 1'b1 || col_addr == 9'd0)
					sdram_cmd	<=	ACT;
				else
					sdram_cmd	<=	NOP;
			3'd3: 		
				sdram_cmd	<=	WR;

			default
				sdram_cmd	<=	NOP;		
		endcase
//sdram_dq
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			sdram_dq	<=	16'd0;
		else case(cmd_cnt)
			3'd3:
				sdram_dq	<=	16'h0002;
			3'd4:
				sdram_dq	<=	16'h0003;
			3'd5:
				sdram_dq	<=	16'h0005;
			3'd6:
				sdram_dq	<=	16'h0006;
			default:
				sdram_dq	<=	16'd0;
		endcase
/* //sdram_dq_m
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			sdram_dqm	<=	4'd0; */
//row_addr_reg
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			row_addr_reg	<=	12'd0;
		else if(row_addr_reg == ROW_END && col_addr == COL_END && cmd_cnt == CMD_END)
			row_addr_reg	<=	12'd0;
		else if(col_addr == COL_END && flag_wr_end == 1'b1)
			row_addr_reg	<=	row_addr_reg + 1'b1;
		
//row_addr
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			row_addr	<=	12'd0;
		else case(cmd_cnt)
		//因为下边的命令是通过行、列地址分开再给addr赋值，所以需要提前一个周期赋值，以保证在命令到来时能读到正确的地址
			3'd2:
				row_addr	<=	12'b0000_0000_0000;	//在写命令时，不允许auto-precharge	
			default:
				row_addr	<=	row_addr_reg;
		endcase
//col_addr
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			col_addr	<=	9'd0;
		else if(col_addr == COL_END && cmd_cnt == CMD_END)
			col_addr	<=	9'd0;
		else if(cmd_cnt == CMD_END)
			col_addr	<=	col_addr + 3'd4;
//sdram_addr
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			sdram_addr	<=	12'd0;
		else case(cmd_cnt)
			3'd2:
				sdram_addr	<=	row_addr;
			3'd3:
				sdram_addr	<=	col_addr;
			
			default:
				sdram_addr	<=	row_addr;
		endcase
//sdram_bank
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			sdram_bank	<=	2'b00;
endmodule
