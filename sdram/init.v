module	init(
		    input	 wire	         sclk,		
		    input	 wire		      s_rst_n,
			 
			 output   wire           sdram_clk,
		    output   reg	[3:0]    cmd_reg,	
		    output	 reg	[11:0]	sdram_addr,	
		    output	 reg	[1:0]  	sdram_bank,	
			 output   reg           CS,
		    output	 reg		      flag_init_end,
			 output   reg           CKE
		);
		
	parameter    	CMD_END		=	4'd11,		
			         CNT_200US	=	14'd1_0000,	
			         NOP		   =	4'b0111,	
			         PRECHARGE	=	4'b0010,	
			         AUTO_REF  	=	4'b0001,	
			         MRSET		   =	4'b0000;
						
	reg	[13:0]	     cnt_200us;		
	reg		           flag_200us;		//200us结束后，一直拉高
	reg	[3:0]	        cnt_cmd;		
	reg		           flag_init;		//初始化结束后，该标志拉低
	
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
		CS <= 1'b1;
		else 
		CS <= 1'd0;
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
		CKE <= 1'b0;
		else 
		CKE <= 1'd1;
//flag_init 
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			flag_init	<=	1'b1;
		else if(cnt_cmd == CMD_END)
			flag_init	<=	1'b0;	
//cnt_200us	
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			cnt_200us	<=	14'd0;
		else if(cnt_200us == CNT_200US)
			cnt_200us	<=	14'd0;
		else if(flag_200us == 1'b0)
			cnt_200us	<=	cnt_200us + 1'b1;
//flag_200us
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			flag_200us	<=	1'b0;
		else if(cnt_200us == CNT_200US)
			flag_200us	<=	1'b1;
//cnt_cmd
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			cnt_cmd	<=	4'd0;
		else if(flag_200us == 1'b1 && flag_init == 1'b1)
			cnt_cmd	<=	cnt_cmd + 1'b1;
//flag_init_end
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			flag_init_end	<=	1'b0;
		else if(cnt_cmd == CMD_END)
			flag_init_end	<=	1'b1;
		else
			flag_init_end	<=	1'b0;
//cmd_reg
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			cmd_reg	<=	NOP;
		else if(cnt_200us == CNT_200US)
			cmd_reg	<=	PRECHARGE;
		else if(flag_200us)
			case(cnt_cmd)
				4'd0:
					cmd_reg	<=	AUTO_REF;	
				4'd6:
					cmd_reg	<=	AUTO_REF;
				4'd10:
					cmd_reg	<=	MRSET;		
				default:
					cmd_reg	<=	NOP;
			endcase
//sdram_addr
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			sdram_addr	<=	12'd0;
		else case(cnt_cmd)
			4'd0:
				sdram_addr	<=	12'b0100_0000_0000;	//预充电时，A10拉高，对所有Bank操作
			4'd10:
				sdram_addr	<=	12'b0000_0011_0010;	//模式寄存器设置时的指令:CAS=2,Burst Length=4;
			default:
				sdram_addr	<=	12'd0;
		endcase
//sdram_bank
	always	@(posedge sclk or negedge s_rst_n)
		if(s_rst_n == 1'b0)
			sdram_bank	<=	2'd0;	
	//sdram_clk
	assign	sdram_clk	=	~sclk;
			
endmodule
