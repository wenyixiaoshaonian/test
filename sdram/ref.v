module	ref(
		input	wire		           sclk,
		input	wire		           s_rst_n,
		input	wire		           ref_en,
		input	wire		           flag_init_end,	//初始化结束标志（初始化结束后，启动自刷新标志）
		
		output	reg	[11:0]	  sdram_addr,
		output	reg	[1:0]	     sdram_bank,
		output	reg		        ref_req,
		output	reg	[3:0]	     cmd_reg,
		output	reg		        flag_ref_end
		);

		parameter	                 BANK	   =	12'd0100_0000_0000,	//自动刷新是对所有bank刷新
			                       CMD_END	=	4'd10,
			                       CNT_END	=	10'd749,	//15us计时结束
			                       NOP	      =	4'b0111,	//
			                       PRE	      =	4'b0010,	//precharge命令
			                       AREF	   =	4'b0001;	//auto-refresh命令
			
			
	reg	[9:0]	     cnt_15ms;	//15ms计数器
	reg		        flag_ref;	//处于自刷新阶段标志
	reg		        flag_start;	//自动刷新启动标志
	reg	[3:0]	     cnt_cmd;	//指令计数器
//flag_start
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			flag_start	<=	1'b0;
		else if(flag_init_end == 1'b1)
			flag_start	<=	1'b1;
//cnt_15ms
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			cnt_15ms	<=	10'd0;
		else if(cnt_15ms == CNT_END)
			cnt_15ms	<=	10'd0;
		else if(flag_start == 1'b1)
			cnt_15ms	<=	cnt_15ms + 1'b1;
//flag_ref
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			flag_ref	<=	1'b0;
		else if(cnt_cmd == CMD_END)
			flag_ref	<=	1'b0;
		else if(ref_en == 1'b1)
			flag_ref	<=	1'b1;
//cnt_cmd
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			cnt_cmd	<=	4'd0;
		else if(flag_ref == 1'b1)
			cnt_cmd	<=	cnt_cmd + 1'b1;
		else
			cnt_cmd	<=	4'd0;
//flag_ref_end
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			flag_ref_end	<=	1'b0;
		else if(cnt_cmd == CMD_END)
			flag_ref_end	<=	1'b1;
		else
			flag_ref_end	<=	1'b0;
//cmd_reg
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			cmd_reg	<=	NOP;
		else case(cnt_cmd)
			3'd0:
				if(flag_ref == 1'b1)
					cmd_reg	<=	PRE;
				else
					cmd_reg	<=	NOP;
			3'd1:
				cmd_reg	<=	AREF;
			3'd5:
				cmd_reg	<=	AREF;
			default:
				cmd_reg	<=	NOP;
		endcase
//sdram_addr
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			sdram_addr	<=	12'd0;
		else case(cnt_cmd)
			4'd0:
				sdram_addr	<=	BANK;	//bank进行刷新时指定allbank or signle bank
			default:
				sdram_addr	<=	12'd0;
		endcase
//sdram_bank
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			sdram_bank	<=	2'd0;		//刷新指定的bank
//ref_req
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			ref_req	<=	1'b0;
		else if(ref_en == 1'b1)
			ref_req	<=	1'b0;
		else if(cnt_15ms == CNT_END)
			ref_req	<=	1'b1;
endmodule
