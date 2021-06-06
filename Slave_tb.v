module Slave_tb();

reg SCLK;
reg reset;
reg [7:0] slaveDataToSend;
reg CS;
reg MOSI;
wire [7:0] slaveDataReceived;
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
localparam TESTCASECOUNT = 6;

// These wires will hold the test case data that will be transmitted by 
// the master and slaves
wire [7:0] testcase_masterData [1:TESTCASECOUNT];
wire [7:0] testcase_slaveData  [1:TESTCASECOUNT];

// populating master && Slave >> TestCaseCount = 1
assign testcase_masterData[1] = 8'b01010011;
assign testcase_slaveData[1]  = 8'b00001001;
// populating master && Slave >> TestCaseCount = 2
assign testcase_masterData[2] = 8'b00111100;
assign testcase_slaveData[2]  = 8'b10011000;
// populating master && Slave >> TestCaseCount = 3
assign testcase_masterData[3] = 8'b11010111;
assign testcase_slaveData[3]  = 8'b01101010;
// populating master && Slave >> TestCaseCount = 4
assign testcase_masterData[4] = 8'b10111010;
assign testcase_slaveData[4]  = 8'b11010111;
// populating master && Slave >> TestCaseCount = 5
assign testcase_masterData[5] = 8'b00011010;
assign testcase_slaveData[5]  = 8'b00000000;
// populating master && Slave >> TestCaseCount = 6
assign testcase_masterData[6] = 8'b11111111;
assign testcase_slaveData[6]  = 8'b11101110;

// Control Flow
integer index;    // index will be used for looping over test cases
integer failures; // failures will store the number of failed test cases
integer counter;

initial begin
    // [1]: Initialinzing FlowControl variables
	index    = 0;
	failures = 0;
    // [2]: Intialize Inputs
    SCLK  = 0;
    reset = 1;
	#PERIOD reset = 0;
    masterDataToSend = 0;
    masterDataReceived = 0;
    slaveDataToSend  = 0;

    // [ ___________ *** Testing *** ___________ ] 
    for(index=1; index <= TESTCASECOUNT; index=index+1) begin
        // ------------> TEST CASE
        $display("Running TestCase: %d", index);
        slaveDataToSend  = testcase_slaveData[index];
        masterDataToSend = testcase_masterData[index];
        CS = 1'b1;
        #PERIOD CS = 1'b0;
        for (counter = 0; counter<=7; counter=counter+1)
        begin
            #PERIOD;
            MOSI = masterDataToSend[7-counter];
            masterDataReceived[7-counter] = MISO;
        end
        #(PERIOD*20);
        CS = 1'b1;

        // -------------> Validation
        if(masterDataReceived == slaveDataToSend) $display("From Slave to Master: Success");
        else begin
            $display("From Slave to Master: Failure (Expected: %b, Received: %b)", slaveDataToSend, masterDataReceived);
            failures = failures + 1;
        end
        if(slaveDataReceived == masterDataToSend) $display("From Master to Slave: Success");
        else begin
            $display("From Master to Slave: Failure (Expected: %b, Received: %b)", masterDataToSend, slaveDataReceived);
            failures = failures + 1;
        end
    end

    // Display a SUCCESS or a FAILURE Report based on the test OutCome
	if(failures) $display("FAILURE: %d out of %d testcases have failed", failures, 2*TESTCASECOUNT);
	else $display("SUCCESS: All %d testcases have been successful", 2*TESTCASECOUNT);
    #200 $finish;
end

// Toggle the clock every half period
always #(PERIOD/2) SCLK = ~SCLK;

endmodule
