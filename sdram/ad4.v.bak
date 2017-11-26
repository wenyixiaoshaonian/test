module ad4 (
    output reg [3:0]  out,
	 input      [3:0]  in1,
	 input      [3:0]  in2,
	 input      [3:0]  in3,
	 input      [3:0]  in4


	 	 
);
	 reg     a;
	 reg     b;
	 
	 always@*
	 begin
	 if(in1>in2)
	 a= in1;
	 else if (in1<in2) a=in2;
	 else if ( in1==in2) a=0;
	 if(a>in3)
	 b=in3;
	 else  b=a;
	 if(b<in4)
	 out = in4;
	 else out =b;
	 end
	 
	 endmodule
	 