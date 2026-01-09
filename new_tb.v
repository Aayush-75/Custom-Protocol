`timescale 1ns / 1ns

module new_tb;
    reg clk;
    reg rst;
    reg direction_pin;
    reg strobe_pin;
    reg [3:0] master_data_in;  
    reg [3:0] slave_data_in; 
    reg [3:0]test_data;  
    
    integer i,j;
    integer valid_count = 0;
    integer invalid_count = 0;
    
 
    custom_protocol DUT(
        .clk(clk),
        .rst(rst),
        .direction_pin(direction_pin),
        .strobe_pin(strobe_pin),
        .master_data_in(master_data_in),
        .slave_data_in(slave_data_in)
    );
    
 
    initial clk = 0;
    always #1 clk = ~clk;  
    
    always@(posedge clk)
    begin
    $display("[%0t] test_data=%4b",$time,test_data);
    $display("[%0t] master_data_in=%4b",$time,master_data_in);
    $display("[%0t] 1output data = %b %b %b %b",$time,DUT.master_data_buffer_out[0][0],DUT.master_data_buffer_out[1][0],DUT.master_data_buffer_out[2][0],DUT.master_data_buffer_out[3][0]);
    $display("[%0t] 2output data = %b %b %b %b",$time,DUT.master_data_buffer_out[0][1],DUT.master_data_buffer_out[1][1],DUT.master_data_buffer_out[2][1],DUT.master_data_buffer_out[3][1]);
    $display("[%0t] 3output data = %b %b %b %b",$time,DUT.master_data_buffer_out[0][2],DUT.master_data_buffer_out[1][2],DUT.master_data_buffer_out[2][2],DUT.master_data_buffer_out[3][2]);
    $display("[%0t] 4output data = %b %b %b %b",$time,DUT.master_data_buffer_out[0][3],DUT.master_data_buffer_out[1][3],DUT.master_data_buffer_out[2][3],DUT.master_data_buffer_out[3][3]);
    if(DUT.valid)
            begin
            $display("HASHHHHHHHHHHHHHHHH LEEEEEEEEe [%0t] detect ho gaya 3", $time);
            valid_count = valid_count + 1;
            end
    end
  
   
    initial begin
        
          direction_pin = 1;  
          rst = 1;
          strobe_pin = 1;  
          @(posedge clk);
          rst = 0;
        
        for(j = 0; j < 2500 ; j = j+1)
        begin
          
          
          @(posedge clk);
          @(posedge clk);
          @(posedge clk);
          /*
          if(DUT.valid)
            begin
            $display("HASHHHHHHHHHHHHHHHH [%0t] detect ho gaya 3", $time);
            valid_count = valid_count + 1;
            end
            */
          @(posedge clk);
          /*
          if(DUT.valid)
            begin
            $display("HASHHHHHHHHHHHHHHHH detect ho gaya 2[%0t] ", $time);
            valid_count = valid_count + 1;
            end
            */
          @(posedge clk);
          /*
          if(DUT.valid)
            begin
            $display("HASHHHHHHHHHHHHHHHH detect ho gaya 1[%0t] ", $time);
            valid_count = valid_count + 1;
            end
          
          else if(!DUT.valid)
            begin
              //$display("loooooooooooollllllllll");
              //$display("[%0t] test_data=%d  and master_data_in=%d and output data=%p", $time,test_data,master_data_in,DUT.master_data_buffer_out);
              invalid_count = invalid_count + 1;
            end
          */
          master_data_in = 4'b1111;
          
          @(posedge clk);
        
          //$display("[%0t] Reset released", $time);
          master_data_in = 0000;
          @(posedge clk);
          if(DUT.start_condition_master_t_slave)
            $display("[%d] YAYYYYYYYYYYYY start mil gaya",$time);
        for(i = 0; i < 4; i = i+1)
        begin
            test_data = $urandom%16;
            //$display("[%0t] test_data=%4b",$time,test_data);
            master_data_in = test_data;
            @(posedge clk);
        end
        //$display("[%0t]",$time);
        
        end
        
        @(posedge clk);
        
        direction_pin = 0;    
        @(posedge clk);
        
        
        
        
        
        for(j = 0; j < 2500 ; j = j+1)
        begin
          
          
          @(posedge clk);
          @(posedge clk);
          @(posedge clk);
          @(posedge clk);
          @(posedge clk);
          slave_data_in = 4'b1111;
          
          @(posedge clk);
        
        
          slave_data_in = 0000;
          @(posedge clk);
          if(DUT.start_condition_slave_t_master)
            $display("[%d] SLAVE WALE MAI HU YAYYYYYYYYYYYY start mil gaya",$time);
        for(i = 0; i < 4; i = i+1)
        begin
            test_data = $urandom%16;
            //$display("[%0t] test_data=%4b",$time,test_data);
            slave_data_in = test_data;
            @(posedge clk);
        end
        //$display("[%0t]",$time);
        
        end
          
        /*
        for(j = 0; j < 3 ; j = j+1)
        begin
          
          @(posedge clk);
          @(posedge clk);
          @(posedge clk);
          @(posedge clk);
          @(posedge clk);
          
          if(DUT.valid)
            begin
            valid_count = valid_count + 1;
            end
          else
            begin
              invalid_count = invalid_count + 1;
            end
          slave_data_in = 4'b1111;
          
          @(posedge clk);
        
          // $display("[%0t] Reset released", $time);
          slave_data_in = 0000;
        for(i = 0; i < 4; i = i+1)
        begin
            @(posedge clk);
            test_data = $urandom%16; 
            slave_data_in = test_data;
        end
        end        
        */
          
      $display("Valid count = %d and Invalid count = %d",valid_count,invalid_count); 
      $finish ;  
      end
  endmodule 
        

