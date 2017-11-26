module ad3 (
    output reg [3:0]  out,
	 input      [3:0]  in1,
	 input      [3:0]  in2,
	 input      [3:0]  in3


	 	 
);
	 reg     a;
	 
	 
	 always@*
	 begin
	 if(in1>in2)
	 a= in1;
	 else if (in1<in2) a=in2;
	 else if ( in1==in2) a=0;
	 if(a>in3)
	 out = a;
	 else if(a<in3) out = in3;
	 else if(a==in3)out = 0;
	 end
	 
	 endmodule
	 