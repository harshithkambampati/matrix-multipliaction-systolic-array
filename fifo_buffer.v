`timescale 1ns / 1ps


module fifo_buffer#(
parameter DATA_WIDTH =32,
parameter DEPTH = 128,
    parameter SIZE = 6,
    parameter ARRAY_SIZE = SIZE*SIZE
)
(
input axi_clk,
input axi_rstn,
input [3:0]N,
output s_axis_ready,
input s_axis_valid,
input [DATA_WIDTH-1:0]s_axis_data,
//output [ARRAY_SIZE*DATA_WIDTH-1:0] to_ip_A,
//output [ARRAY_SIZE*DATA_WIDTH-1:0] to_ip_B,
//input [ARRAY_SIZE*DATA_WIDTH-1:0] from_ip_C,
output reg[DATA_WIDTH-1:0]m_axis_data,
input m_axis_ready,
output reg m_axis_valid


    );
      
    reg [ARRAY_SIZE*DATA_WIDTH-1:0] to_ip_A, to_ip_B;
    wire [ARRAY_SIZE*DATA_WIDTH-1:0] from_ip_C;
      
      
    reg [DATA_WIDTH -1:0]buffer[DEPTH-1:0];// First A Matrix then B matrix  i.e index = 0-35 A matrix and 36-71 B matrix in transposed in buffer
    wire [2*DATA_WIDTH*ARRAY_SIZE -1:0]A_B;
    wire [DATA_WIDTH*ARRAY_SIZE -1:0] C_matrix;
    integer j;
    for(j = 0; j<=71; j=j+1)
    begin
        assign A_B[(71-j)*DATA_WIDTH*ARRAY_SIZE+:DATA_WIDTH] =  buffer[j];
    end
    reg START;
    wire GLOBAL_DONE;
    reg [6:0]i,j;
    
    always @(posedge axi_clk, negedge axis_rstn)
    begin
        if(!axi_rstn)
        begin
            i<=0;
            START<= 1'b0;
        end
        else
            begin
                if(s_axis_valid && s_axis_ready)
                begin
                    buffer[i] <= s_axis_data;
                    i <= i+1;
                    if(i==72) START<= 1'b1;
                end
            end
    end
    
    always @(posedge axi_clk, posedge GLOBAL_DONE)
    begin
    if(!GLOBAL_DONE) j <= 0;
    
    else 
        m_axis_data =C_matrix[(71-j)*ARRAY_SIZE*DATA_WIDTH +:DATA_WIDTH];
    end
    
    assign to_ip_A = A_B[2*DATA_WIDTH*ARRAY_SIZE -1:DATA_WIDTH*ARRAY_SIZE];
    assign to_ip_B = A_B[ARRA_SIZE*DATA_WIDTH-1:0];
    
    
    scheduler #(
    .DATA_WIDTH(DATA_WIDTH),
    .SIZE(SIZE))
    sch
    (
    .clk(axi_clk),
    .rst(axi_rstn),
    .N(N), //size of square matrix
    .START(START),
    .GLOBAL_DONE(GLOBAL_DONE),
    .A_matrix(to_ip_A ),
    .B_matrix(to_ip_B),
    .C_matrix(C_matrix)
    );
endmodule
