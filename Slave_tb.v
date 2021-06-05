module Slave_tb();

reg SCLK; // TODO: make sure && clk
reg reset;
reg  [7:0] slaveDataToSend;
wire [7:0] slaveDataReceived;
reg CS;
reg MOSI;
wire MISO;

//  REVIEWME: 
reg  [7:0] masterDataToSend;
reg  [7:0] masterDataReceived;

// Create a Slave Instance
Slave mySlave(
    reset,
	slaveDataToSend, slaveDataReceived,
	SCLK, CS, MOSI, MISO
);

// Period of one clock cycle of the clk
localparam PERIOD = 20;
// How many test cases we have
localparam TESTCASECOUNT = 2;

// These wires will hold the test case data that will be transmitted by 
// the master and slaves
wire [7:0] testcase_masterData [1:TESTCASECOUNT]; // Master [1, 2]
wire [7:0] testcase_slaveData  [1:TESTCASECOUNT]; // Slave  [1, 2]

// populating master && Slave >> TestCaseCount = 1
assign testcase_masterData[1] = 8'b01010011;
assign testcase_slaveData[1]  = 8'b00001001;
// populating master && Slave >> TestCaseCount = 2
assign testcase_masterData[2] = 8'b00111100;
assign testcase_slaveData[2]  = 8'b10011000;

// Control Flow
integer index;    // index will be used for looping over test cases
integer failures; // failures will store the number of failed test cases
// []:
initial begin
    // [1]: Initialinzing FlowControl variables
	index    = 0;
	failures = 0;
    // [2]: Intialize Inputs
    SCLK  = 0;
    reset = 1;
    masterDataToSend = 0; // TODO: WHY
    slaveDataToSend  = 0; // TODO: WHY
    // [3]: Reset Now is done so set reset back to 0 after 1 clock cycle
	#PERIOD reset = 0;
    // [4]: Loop over all test cases
    for(index=1; index <= TESTCASECOUNT; index=index+1)
    begin
        $display("Running TestCase [%d]", index);
        // [a]: Give mySlave DataToSend
        slaveDataToSend = testcase_slaveData[index];
        // [b]: Set Master DataToSend
        masterDataToSend = testcase_masterData[index];
        
        CS = 1'b1;
        #PERIOD CS = 1'b0;
        /* [*** Intiate Transmission ***] */

        // slaveDataToSend  >>> MISO >>> masterDataReceived
		$monitor("MISO: %b, MOSI: %b", MISO, MOSI);
        // masterDataToSend >>> MOSI >>> slaveDataReceived
        
        // [slaveDataToSend::00-001-001]  >>> [masterDataReceived]
        // [masterDataToSend::01-010-011] >>> [slaveDataReceived]
        
        /* [*** END Transmission ***] */
        #(PERIOD*20);
        CS = 1'b1;
        // [f]: Check that the master correctly received the data that should have been sent by the slave
        if(masterDataReceived == slaveDataToSend) $display("From Slave to Master: Success");
        else begin
            $display("From Slave to Master: Failure (Expected: %b, Received: %b)", slaveDataToSend, masterDataReceived);
            failures = failures + 1;
        end
        // [g]: Check that the slave correctly received the data that should have been sent by the master 
        if(slaveDataReceived == masterDataToSend) $display("From Master to Slave: Success");
        else begin
            $display("From Master to Slave: Failure (Expected: %b, Received: %b)", masterDataToSend, slaveDataReceived);
            failures = failures + 1;
        end
    end
    // [5]: Display a SUCCESS or a FAILURE message based on the test OutCome
	if(failures) $display("FAILURE: %d out of %d testcases have failed", failures, 2*TESTCASECOUNT);
	else $display("SUCCESS: All %d testcases have been successful", 2*TESTCASECOUNT);
end

// Toggle the clock every half period
always #(PERIOD/2) SCLK = ~SCLK;

endmodule
