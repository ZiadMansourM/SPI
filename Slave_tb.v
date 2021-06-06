module Slave_tb();

reg SCLK; // TODO: make sure && clk
reg reset;
reg  [7:0] slaveDataToSend;
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
localparam TESTCASECOUNT = 4;

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
// // populating master && Slave >> TestCaseCount = 3
assign testcase_masterData[3] = 8'b11010111;
assign testcase_slaveData[3]  = 8'b01101010;
// // populating master && Slave >> TestCaseCount = 4
assign testcase_masterData[4] = 8'b10111010;
assign testcase_slaveData[4]  = 8'b11010111;

// Control Flow
integer index;    // index will be used for looping over test cases
integer failures; // failures will store the number of failed test cases
integer counter;
// []:
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

    // [*** Testing ***] 
    // ------------> FIRST TEST CASE
    $display("Running TestCase 1");
    slaveDataToSend  = testcase_slaveData[1];
    masterDataToSend = testcase_masterData[1];
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

    // -------------> Validation 1 Testcase
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

    
    // [*** Testing ***] 
    // ------------> SECOND TEST CASE
    $display("Running TestCase 2");
    slaveDataToSend  = testcase_slaveData[2];
    masterDataToSend = testcase_masterData[2];
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

    // -------------> Validation 1 Testcase
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

    // [*** Testing ***] 
    // ------------> Third TEST CASE
    $display("Running TestCase 3");
    slaveDataToSend  = testcase_slaveData[3];
    masterDataToSend = testcase_masterData[3];
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

    // -------------> Validation 1 Testcase
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

    // [*** Testing ***] 
    // ------------> Fourth TEST CASE
    $display("Running TestCase 4");
    slaveDataToSend  = testcase_slaveData[4];
    masterDataToSend = testcase_masterData[4];
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

    // -------------> Validation 1 Testcase
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

    // [5]: Display a SUCCESS or a FAILURE message based on the test OutCome
	if(failures) $display("FAILURE: %d out of %d testcases have failed", failures, 2*TESTCASECOUNT);
	else $display("SUCCESS: All %d testcases have been successful", 2*TESTCASECOUNT);
    #200 $finish;
end

// Toggle the clock every half period
always #(PERIOD/2) SCLK = ~SCLK;

endmodule
