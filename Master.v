module Master(
	input clk, input reset,
	input start, input [1:0] slaveSelect, input [7:0] masterDataToSend, output reg [7:0] masterDataReceived,
	output SCLK, output reg [0:2] CS, output reg MOSI,input MISO
);


integer counter = 0;

assign SCLK = clk;

always @ (clk or reset) 		//Assumption: Everytime start is HIGH we initiate transimission
										//i.e.: For succesful transmission we must have start = 1; #PERIOD start = 0;
begin

		if (clk == 0 && counter <= 8 && counter > 0) //Negative Clock Edge
		begin
			//Receive
			masterDataReceived = masterDataReceived << 1;
			masterDataReceived[0] = MISO;
			counter = counter + 1;
		end

		if (clk == 1)	//Positive Clock Edge
		begin
			
			if (start == 1) //Start Transmission
			begin			
				counter = 1;
				
				if (slaveSelect == 2'b00)
				begin
					CS = 3'b011;
				end
				else if (slaveSelect == 2'b01)
				begin
					CS = 3'b101;
				end
				else if (slaveSelect == 2'b10)
				begin
					CS = 3'b110;
				end

				//Send
				MOSI = masterDataToSend[8 - counter];
			
			end

			else if (counter <= 8 && counter > 0) //Send
			begin
				//Send
				MOSI = masterDataToSend[8 - counter];
				//$display("Counter = %d\n",counter);								
			end
		end

	if (reset == 1) 
	begin
		masterDataReceived = 0;
		counter = 0;
		CS[0] = 1'b1;
		CS[1] = 1'b1;
		CS[2] = 1'b1;

	end

	
end
	
endmodule