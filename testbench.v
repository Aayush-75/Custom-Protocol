`timescale 1ns / 1ns

module tb_custom_protocol;
    // Declare all signals with correct widths
    reg clk;
    reg rst;
    reg direction_pin;
    reg strobe_pin;
    reg [3:0] master_data_in;  // Fixed: 4-bit width
    reg [3:0] slave_data_in;   // Fixed: 4-bit width
    
    // Instantiate DUT
    custom_protocol DUT(
        .clk(clk),
        .rst(rst),
        .direction_pin(direction_pin),
        .strobe_pin(strobe_pin),
        .master_data_in(master_data_in),
        .slave_data_in(slave_data_in)
    );
    
    // Clock generation - FIXED
    initial clk = 0;
    always #1 clk = ~clk;  // 10ns period = 100MHz clock
    
    // Main test stimulus - ALL IN ONE initial BLOCK
    initial begin
        // Initialize all signals
        master_data_in = 4'b1111;
        slave_data_in = 4'b1111;
        direction_pin = 1;  // Master to slave
        rst = 1;
        strobe_pin = 1;  // Start with strobe low
        
        $display("=== Starting Test ===");
        
        // Hold reset for a few clocks
        @(posedge clk);
        
        // Release reset
        rst = 0;
        @(posedge clk);
        
        $display("[%0t] Reset released", $time);
        master_data_in = 0000;
        // Test 1: Send 0001 (checksum = 1)
        @(posedge clk);
        master_data_in = 4'b0001;
        //strobe_pin = 1;
        $display("[%0t] Sending: 0001, checksum should be 1", $time);
        //@(posedge clk);
        //strobe_pin = 0;
        
        // Test 2: Send 1000 (checksum = 1)
        @(posedge clk);
        //@(posedge clk);
        master_data_in = 4'b1000;
        //strobe_pin = 1;
        $display("[%0t] Sending: 1000, checksum should be 1", $time);
        //@(posedge clk);
        //strobe_pin = 0;
        
        // Test 3: Send 1100 (checksum = 0)
        //@(posedge clk);
        @(posedge clk);
        master_data_in = 4'b1100;
        //strobe_pin = 1;
        $display("[%0t] Sending: 1100, checksum should be 0", $time);
        //@(posedge clk);
        //strobe_pin = 0;
        
        // Test 4: Send 1110 (checksum = 1)
        //@(posedge clk);
        @(posedge clk);
        master_data_in = 4'b1110;
        //strobe_pin = 1;
        $display("[%0t] Sending: 1110, checksum should be 1", $time);
        //@(posedge clk);
        //strobe_pin = 0;
        
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        
        $display("[%0t] master_data_out_checksum = [%b]",$time ,DUT.master_data_out_checksum);
        $display("[%0t] values of hand calculation = [%b][%b][%b][%b]",$time,(DUT.master_data_buffer_out[0][3] ^ DUT.master_data_buffer_out[1][3] ^ DUT.master_data_buffer_out[2][3] ^ DUT.master_data_buffer_out[3][3])
                	                                         	                 ,(DUT.master_data_buffer_out[0][2] ^ DUT.master_data_buffer_out[1][2] ^ DUT.master_data_buffer_out[2][2] ^ DUT.master_data_buffer_out[3][2])
                      	             	                       	               ,(DUT.master_data_buffer_out[0][1] ^ DUT.master_data_buffer_out[1][1] ^ DUT.master_data_buffer_out[2][1] ^ DUT.master_data_buffer_out[3][1])
                    	                                               	       ,(DUT.master_data_buffer_out[0][0] ^ DUT.master_data_buffer_out[1][0] ^ DUT.master_data_buffer_out[2][0] ^ DUT.master_data_buffer_out[3][0])
        
        
);
        
        $display("=== Test Completed ===");
        $display(" ");
        
        slave_data_in = 0000;
        direction_pin = 0;
        
        
        @(posedge clk);
        slave_data_in = 4'b1010;
        $display("[%0t] Sending: 1010, checksum should be 0", $time); 
        
        @(posedge clk);
        slave_data_in = 4'b0000;
        $display("[%0t] Sending: 0000, checksum should be 0", $time);
        
        @(posedge clk);
        slave_data_in = 4'b1111;
        $display("[%0t] Sending: 1111, checksum should be 0", $time);
        
        @(posedge clk);
        slave_data_in = 4'b0101;
        $display("[%0t] Sending: 0101, checksum should be 0", $time);
        

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);        
        
        
        $display("=== Test Completed ===");
        $display(" ");
        
        $display("[%b][%b][%b][%b]",DUT.master_data_buffer_out[0][0],DUT.master_data_buffer_out[0][1],DUT.master_data_buffer_out[0][2],DUT.master_data_buffer_out[0][3]);
        $display("[%b][%b][%b][%b]",DUT.master_data_buffer_out[1][0],DUT.master_data_buffer_out[1][1],DUT.master_data_buffer_out[1][2],DUT.master_data_buffer_out[1][3]);
        $display("[%b][%b][%b][%b]",DUT.master_data_buffer_out[2][0],DUT.master_data_buffer_out[2][1],DUT.master_data_buffer_out[2][2],DUT.master_data_buffer_out[2][3]);
        $display("[%b][%b][%b][%b]",DUT.master_data_buffer_out[3][0],DUT.master_data_buffer_out[3][1],DUT.master_data_buffer_out[3][2],DUT.master_data_buffer_out[3][3]);
        $display(" ");
        $display("[%b][%b][%b][%b]",DUT.slave_data_buffer_out[0][0],DUT.slave_data_buffer_out[0][1],DUT.slave_data_buffer_out[0][2],DUT.slave_data_buffer_out[0][3]);
        $display("[%b][%b][%b][%b]",DUT.slave_data_buffer_out[1][0],DUT.slave_data_buffer_out[1][1],DUT.slave_data_buffer_out[1][2],DUT.slave_data_buffer_out[1][3]);
        $display("[%b][%b][%b][%b]",DUT.slave_data_buffer_out[2][0],DUT.slave_data_buffer_out[2][1],DUT.slave_data_buffer_out[2][2],DUT.slave_data_buffer_out[2][3]);
        $display("[%b][%b][%b][%b]",DUT.slave_data_buffer_out[3][0],DUT.slave_data_buffer_out[3][1],DUT.slave_data_buffer_out[3][2],DUT.slave_data_buffer_out[3][3]);
        $display(" ");
        
        
        $finish;
    end
    
    // Monitor block - SEPARATE from initial
    always @(posedge clk) begin
        if (!rst) begin  // Only display after reset is released
            $display("[%0t] dir=%b strobe=%b master_in=%b data_cnt=%0d ps=%b valid=%b", 
                     $time, direction_pin, strobe_pin, master_data_in, 
                     DUT.data_counter, DUT.ps, DUT.valid);
            $display("[%0t] dir=%b strobe=%b slave_in=%b data_cnt=%0d ps=%b valid=%b", 
                     $time, direction_pin, strobe_pin, slave_data_in, 
                     DUT.data_counter, DUT.ps, DUT.valid);
        end
    end
    
    // Dump waveforms for viewing
    initial begin
        $dumpfile("tb_custom_protocol.vcd");
        $dumpvars(0, tb_custom_protocol);
    end

endmodule
