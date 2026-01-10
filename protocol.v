module custom_protocol(
  input clk,
  input rst,
  input direction_pin,  //1 means master to slave communication
  input strobe_pin,		//1 for valid

  input [3:0]master_data_in,
  input [3:0]slave_data_in

  output reg valid = 0;
  );

  reg [3:0]master_data_buffer_out[3:0];
  reg [3:0]slave_data_buffer_out[3:0];
  
  reg [3:0]master_data_in_checksum;
  reg [3:0]slave_data_in_checksum;
  
  reg [3:0]master_data_out_checksum;
  reg [3:0]slave_data_out_checksum;
  
  reg [2:0]data_counter = 0;
  
  localparam [1:0]
  idle = 2'b00,
  data = 2'b01,
  checksum = 2'b10;
  
  reg[1:0] ps,ns;
  reg start_detection_slave_t_master;
  reg start_detection_master_t_slave;
  
  wire start_condition_master_t_slave;
  wire start_condition_slave_t_master;
  
  
  //for detection of starting condition logic checking with previous valuees 
  assign start_condition_master_t_slave = master_data_in[0] ^ start_detection_master_t_slave;
  assign start_condition_slave_t_master = slave_data_in[0] ^ start_detection_slave_t_master;
  
  always@(posedge clk)
	begin
		start_detection_master_t_slave = master_data_in[0];
		start_detection_slave_t_master = slave_data_in[0];
	end
	
	
  always@(posedge clk)
    begin
      ps = ns;
    end

  always@(posedge clk or posedge rst)
    begin
      if(rst)
        begin
          ns = idle;
		  valid = 0;
        end
      
      else
        begin
          case(ps)
			 
			 idle:
				begin
					valid = 0;
					
					if(start_condition_master_t_slave || start_condition_slave_t_master)
						begin
							ns = data;
						end
						
					else
						begin
							ns = idle;
						end
				end
					
				data:
					begin
						if(data_counter != 4)
							begin
								if(direction_pin)
									begin
										if(strobe_pin)
											begin
												master_data_buffer_out[0][data_counter] = master_data_in[0];
												master_data_buffer_out[1][data_counter] = master_data_in[1];
												master_data_buffer_out[2][data_counter] = master_data_in[2];
												master_data_buffer_out[3][data_counter] = master_data_in[3];
												master_data_in_checksum[data_counter] = master_data_in[0] ^ master_data_in[1] ^ master_data_in[2] ^ master_data_in[3];
												data_counter = data_counter + 1;
												ns = data;
											end
										
										else
											begin
												ns = data;
											end
									end
								
								else
									begin
										if(strobe_pin)
											begin
												slave_data_buffer_out[0][data_counter] = slave_data_in[0];
												slave_data_buffer_out[1][data_counter] = slave_data_in[1];
												slave_data_buffer_out[2][data_counter] = slave_data_in[2];
												slave_data_buffer_out[3][data_counter] = slave_data_in[3];
												slave_data_in_checksum[data_counter] = slave_data_in[0] ^ slave_data_in[1] ^ slave_data_in[2] ^ slave_data_in[3];
												data_counter = data_counter + 1;
												ns = data;
											end
										
										else
											begin
												ns = data;
											end
									end
							end
							
						else
							begin
								if(direction_pin)
									begin
										master_data_out_checksum = master_data_in_checksum;
										data_counter = 0;
										ns = checksum;
									end
										
								else
									begin
										slave_data_out_checksum = slave_data_in_checksum;
										data_counter = 0;
										ns = checksum;
									end
							end
					end
						
					
					checksum:
						begin
							if(direction_pin)
								begin
									if(master_data_out_checksum == {(master_data_buffer_out[0][3] ^ master_data_buffer_out[1][3] ^ master_data_buffer_out[2][3] ^ master_data_buffer_out[3][3]),
																			  (master_data_buffer_out[0][2] ^ master_data_buffer_out[1][2] ^ master_data_buffer_out[2][2] ^ master_data_buffer_out[3][2]),
																			  (master_data_buffer_out[0][1] ^ master_data_buffer_out[1][1] ^ master_data_buffer_out[2][1] ^ master_data_buffer_out[3][1]),
																			  (master_data_buffer_out[0][0] ^ master_data_buffer_out[1][0] ^ master_data_buffer_out[2][0] ^ master_data_buffer_out[3][0])}
																			  )
																			  
										begin
											valid = 1;
											ns = idle;
										end
										
									else
										begin
											valid = 0;
											ns = idle;
										end										
								end
							
							else
								begin
									if(slave_data_out_checksum == { (slave_data_buffer_out[0][3] ^ slave_data_buffer_out[1][3] ^ slave_data_buffer_out[2][3] ^ slave_data_buffer_out[3][3]),
																			  (slave_data_buffer_out[0][2] ^ slave_data_buffer_out[1][2] ^ slave_data_buffer_out[2][2] ^ slave_data_buffer_out[3][2]),
																			  (slave_data_buffer_out[0][1] ^ slave_data_buffer_out[1][1] ^ slave_data_buffer_out[2][1] ^ slave_data_buffer_out[3][1]),
																			  (slave_data_buffer_out[0][0] ^ slave_data_buffer_out[1][0] ^ slave_data_buffer_out[2][0] ^ slave_data_buffer_out[3][0])}
																			  )
																			  
										begin
											valid = 1;
											ns = idle;
										end
										
									else
										begin
											valid = 0;
											ns = idle;
										end
								end
						end
				
							
		endcase
		end
		end
		
endmodule


