module Slave(input reset,
	input [7:0] slaveDataToSend, output reg [7:0] slaveDataReceived,
	input SCLK, input CS, input MOSI, output reg MISO
);

integer counter = 0;

initial begin
	MISO = 1'bz;
end

always @(negedge SCLK or negedge CS or posedge reset)
begin
	
	if (reset == 1) begin
		slaveDataReceived = 0;
		counter = 0;
		//started = 0;
	end
	
	else if (SCLK == 0) //Negative Clock Edge && CS is Enabled
	begin
		if (CS == 0)
		begin
			if (counter <= 7)
			begin
			slaveDataReceived = slaveDataReceived << 1;
			slaveDataReceived[0] = MOSI;

			MISO = slaveDataToSend[7 - counter];
			counter = counter + 1;
			end
			/*else begin
			started = 0;
			end*/
		end
		else MISO = 1'bz;
	end

	//else if (CS == 0 && started == 0) //Start Transmission
	else if (CS == 0) //Start Transmission
	begin
	
		counter = 0;
		//MISO = slaveDataToSend[7 - counter];
		//counter = counter + 1;
		//started = 1;
	
	end
	
end

endmodule