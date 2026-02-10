`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2025 05:51:31
// Design Name: 
// Module Name: pe
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pe#(
    parameter DATA_WIDTH =32
    
)
(
    input clk,
    input rst, // active low reset
    input START, 
    input [DATA_WIDTH-1:0] A,
    input [DATA_WIDTH-1:0] B,
//    input [2:0] N,
    input [DATA_WIDTH-1:0] C,
    
    output reg[DATA_WIDTH-1:0]data_right,
    output reg[DATA_WIDTH-1:0]data_down,    
    output reg[DATA_WIDTH-1:0]data_out

    );
    
//    reg [2:0]size;
//    localparam PROCESSING = 'd0;
//    localparam DONE = 'd1;
//    reg state;
    always @(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            data_right <= 0;
            data_down  <= 0;
            data_out   <= 0;
//            size <=N-1;
        end
        else
            begin
            if(START) 
                begin
                data_right <= B;
                data_down  <= A;
                data_out <= A*B+C;
                end
//                size <= size-1;
            end
    end
    
//    assign done = size == 0;
    
    
endmodule
