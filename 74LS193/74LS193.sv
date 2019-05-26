module Counter_74193(
	input[3:0] data_in, 	//Parallel Data Inputs - Pn
  	input clr,		  		//Asynchronous Master Reset (Clear) Input - MR
  	input load, 	  		//Asynchronous Parallel Load (Active LOW) Input - PL
	input down,		  		//Count Down Clock Pulse Input - CPd
	input up,		  		//Count Up Clock Pulse Input - CPu
  	output [3:0] data_out,	//Flip-Flop Outputs - Qn
  	output bo, 				//Terminal Count Down (Borrow) Output - TCd
  	output co				//Terminal Count Up (Carry) Output - TCu
);
	
	reg bo_r = 1'b1;
	reg co_r = 1'b1;
	reg [3:0] cont = 0;
	
  	always @(posedge up)
    	begin
            if(~clr && load)
                begin
                    if(up && down)
                        cont <= cont + 1;
                    else if(up && ~down && cont[0])
                        cont <= cont + 2;
                end
        end

  	always @(posedge down)
    	begin
          	if(~clr && load)
            	begin
              		if(down && up)
              			cont <= cont - 1;
              		else if (down && ~up && ~cont[0])
                		cont <= cont - 2;
            	end
        end
  
  	always @(posedge clr or negedge load or data_in)
    	begin
      		if (clr) 
       			cont = 0;
      		else if(~load)
        		cont = data_in;
    	end

  	assign data_out = cont;
  	assign bo = ~(~down & ~cont[0] & ~cont[1] & ~cont[2] & ~cont[3]);
  	assign co = ~(~up & cont[0] & cont[1] & cont[2] & cont[3]);

endmodule