module Master(
	input clk, input reset,
	input start, input [1:0] slaveSelect, input [7:0] masterDataToSend, output reg [7:0] masterDataReceived,
	output SCLK, output reg [0:2] CS, output reg MOSI,input MISO 
);


integer counter = 0;

assign SCLK = clk;

always @ (posedge clk or posedge reset) //Assumption: Everytime start is HIGH we initiate transimission
										//i.e.: For succesful transmission we must have start = 1; #PERIOD start = 0;
begin

		if (reset == 1) 
		begin
			masterDataReceived = 0;
			counter = 0;
			CS[0] = 1'b1;
			CS[1] = 1'b1;
			CS[2] = 1'b1;

		end

		else if (clk == 1)	//Positive Clock Edge
		begin
			
			if (start == 1) //Start Transmission
			begin
			
				counter = 0;
				MOSI = masterDataToSend[7 - counter];
				counter = counter + 1;
				
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
			
			end

			else if (counter <= 7)
			begin

				masterDataReceived = masterDataReceived << 1;
				masterDataReceived[0] = MISO;
				MOSI = masterDataToSend[7 - counter];

				counter = counter + 1;
										
			end
			else if (counter == 8)
			begin
				masterDataReceived = masterDataReceived << 1;
				masterDataReceived[0] = MISO;
				counter = counter + 1;
			end
		end
	
end
	
endmodule