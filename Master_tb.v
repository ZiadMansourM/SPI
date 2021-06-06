module Master_tb();

reg clk;
reg reset;
reg start;
reg [1:0] slaveSelect;
reg [7:0] masterDataToSend;
reg MISO;
//  REVIEWME: 
reg  [7:0] slaveDataToSend [0:2];
reg  [7:0] slaveDataReceived [0:2];

wire SCLK;
wire [7:0] masterDataReceived;
wire [0:2] CS;
wire MOSI;


// Here we create an instance of the master
Master maestro(
	clk, reset,
	start, slaveSelect, masterDataToSend, masterDataReceived,
	SCLK, CS, MOSI, MISO
);


// Period of one clock cycle of the clk
localparam PERIOD = 20;

// How many test cases we have
localparam TESTCASECOUNT = 6;
// These wires will hold the test case data that will be transmitted by the master and slaves
wire [7:0] testcase_masterData [1:TESTCASECOUNT];
wire [7:0] testcase_slaveData  [1:TESTCASECOUNT][0:2];


// populating master && Slave >> TestCaseCount = 1
assign testcase_masterData[1]   = 8'b01010011;
assign testcase_slaveData[1][0] = 8'b00001001;
assign testcase_slaveData[1][1] = 8'b00100010;
assign testcase_slaveData[1][2] = 8'b10000011;
// populating master && Slave >> TestCaseCount = 2
assign testcase_masterData[2]   = 8'b00111100;
assign testcase_slaveData[2][0] = 8'b10011000;
assign testcase_slaveData[2][1] = 8'b00100101;
assign testcase_slaveData[2][2] = 8'b11000010;
// populating master && Slave >> TestCaseCount = 3
assign testcase_masterData[3]   = 8'b00010100;
assign testcase_slaveData[3][0] = 8'b10011100;
assign testcase_slaveData[3][1] = 8'b10110101;
assign testcase_slaveData[3][2] = 8'b10011111;
// populating master && Slave >> TestCaseCount = 4
assign testcase_masterData[4]   = 8'b01100100;
assign testcase_slaveData[4][0] = 8'b11100000;
assign testcase_slaveData[4][1] = 8'b11001010;
assign testcase_slaveData[4][2] = 8'b00101011;
// populating master && Slave >> TestCaseCount = 5
assign testcase_masterData[5]   = 8'b00010100;
assign testcase_slaveData[5][0] = 8'b01100111;
assign testcase_slaveData[5][1] = 8'b11101111;
assign testcase_slaveData[5][2] = 8'b11110111;
// populating master && Slave >> TestCaseCount = 6
assign testcase_masterData[6]   = 8'b10101100;
assign testcase_slaveData[6][0] = 8'b11001001;
assign testcase_slaveData[6][1] = 8'b11000001;
assign testcase_slaveData[6][2] = 8'b01100001;


// Control Flow
integer index;    // index will be used for looping over test cases
integer failures; // failures will store the number of failed test cases
integer counter;

initial begin
    // [1]: Initialinzing FlowControl variables
	index    = 0;
	failures = 0;
    // [2]: Intialize Inputs
    clk = 0; // Initialize the clock signal
    reset = 1; // Set reset to 1 in order to reset all the modules
    #PERIOD reset = 0;
    masterDataToSend = 0;
    for(slaveSelect = 0; slaveSelect < 3; slaveSelect = slaveSelect+1) begin
        slaveDataToSend[slaveSelect]   = 0;
        slaveDataReceived[slaveSelect] = 0;
    end

    // [ ___________ *** Testing *** ___________ ] 
    for(index=1; index <= TESTCASECOUNT; index=index+1) begin
        // -------------> TEST CASE
        $display("Running TestCase: %d", index);
        // [1]: Populate masterDataToSend && slaveDataToSend
        masterDataToSend = testcase_masterData[index];
        for(slaveSelect = 0; slaveSelect < 3; slaveSelect=slaveSelect+1)
			slaveDataToSend[slaveSelect] = testcase_slaveData[index][slaveSelect];
        
        // -------------> Transmission
        for(slaveSelect = 0; slaveSelect < 3; slaveSelect=slaveSelect+1) begin
            start = 1;
            #PERIOD start = 0;
            for (counter = 0; counter<=7; counter=counter+1)
            begin
                slaveDataReceived[slaveSelect][7-counter] = MOSI;
                MISO = slaveDataToSend[slaveSelect][7-counter];
                #PERIOD;
            end
            // #(PERIOD*20);

            // -------------> Validation
            if(masterDataReceived == slaveDataToSend[slaveSelect]) $display("From Slave %d to Master: Success", slaveSelect);
            else begin
                $display("From Slave %d to Master: Failure (Expected: %b, Received: %b)", slaveSelect, slaveDataToSend[slaveSelect], masterDataReceived);
                failures = failures + 1;
            end
            // Check that the slave correctly received the data that should have been sent by the master
            if(slaveDataReceived[slaveSelect] == masterDataToSend) $display("From Master to Slave %d: Success", slaveSelect);
            else begin
                $display("From Master to Slave %d: Failure (Expected: %b, Received: %b)", slaveSelect, masterDataToSend, slaveDataReceived[slaveSelect]);
                failures = failures + 1;
            end
        end
    end

    // -------------> Report
    // Display a SUCCESS or a FAILURE message based on the test outcome
	if(failures) $display("FAILURE: %d out of %d testcases have failed", failures, 3*2*TESTCASECOUNT);
	else $display("SUCCESS: All %d testcases have been successful", 3*2*TESTCASECOUNT);
    #200 $finish;
end

// Toggle the clock every half period
always #(PERIOD/2) clk = ~clk;

endmodule
