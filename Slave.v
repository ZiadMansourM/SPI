module Slave(input reset,
	input [7:0] slaveDataToSend, output reg [7:0] slaveDataReceived,
	input SCLK, input CS, input MOSI, output reg MISO
);

integer counter = 0;

initial begin
	MISO = 1'bz;
end

always @(SCLK or CS or reset)
begin

	if (SCLK == 0) 
	begin
		if (CS == 0 && counter <= 8 && counter > 0)
		begin
			//Receive
			slaveDataReceived = slaveDataReceived << 1;
			slaveDataReceived[0] = MOSI;

			counter = counter + 1;
		end

		else MISO = 1'bz;
	end

	else if (SCLK == 1)
	begin 

		if (CS == 0 && counter <= 8 && counter > 0)
		begin
			//Send
			MISO = slaveDataToSend[8 - counter];
		end

		else if (CS == 0 && counter <= 8) //Start Transmission
		begin
			counter = 1;
			MISO = slaveDataToSend[8 - counter];

		end

		else if (CS == 1 && counter == 9)
		begin
			counter = 0;
		end


	end

	if (reset == 1) begin
		slaveDataReceived = 0;
		counter = 0;
	end
	
end


endmodule