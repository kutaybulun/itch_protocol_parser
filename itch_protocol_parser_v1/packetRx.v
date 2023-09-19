`timescale 1ns / 1ps
`define INITIAL_STATE 0
`define STEADY_STATE 1

module packetRx(
	input clk,
	input rst,
	input [63:0] rx_data_net,
	input rx_sof_net,
	input rx_eof_net,
	input [2:0] rx_len_net,
	input rx_vld_net,
	output reg [63:0] dataOut,
	output [6:0] counterOut
);

reg state, stateNext;
reg [6:0] counter, counterNext;

always @(posedge clk) begin
	state <=  stateNext;
	counter <= counterNext;
end

assign counterOut = counter;

always @* begin
	stateNext = state;
	counterNext = counter;
	if (rst) begin
		stateNext = 0;
		counterNext = 0;
	end
	else begin
		case (state)
			`INITIAL_STATE: begin
				if (rx_vld_net && rx_sof_net) begin
					dataOut = rx_data_net;
					stateNext = `STEADY_STATE;
					counterNext = counter + 1;
				end
			end
			`STEADY_STATE: begin
				if (rx_vld_net) begin
					if (rx_eof_net) begin
						case (rx_len_net)
							0: dataOut = rx_data_net[7:0];
							1:	dataOut = rx_data_net[15:0];
							2: dataOut = rx_data_net[23:0];
							3: dataOut = rx_data_net[31:0];
							4: dataOut = rx_data_net[39:0];
							5: dataOut = rx_data_net[47:0];
							6: dataOut = rx_data_net[55:0];
							7: dataOut = rx_data_net;
						endcase
						stateNext = `INITIAL_STATE;
						counterNext = 0;
					end
					else begin
						dataOut = rx_data_net;
						counterNext = counter + 1;
					end
				end
			end
		endcase
	end
end
endmodule