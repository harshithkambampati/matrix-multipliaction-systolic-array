`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.10.2025 20:49:49
// Design Name: 
// Module Name: Top_Module
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


module Top_Module#(
parameter DATA_WIDTH =32,
parameter DEPTH = 128
)(
    input axi_clk,
    input axi_rstn,
    
    output s_axis_ready,
    input s_axis_valid,
    input [DATA_WIDTH-1:0]s_axis_data,
    output reg[DATA_WIDTH-1:0]m_axis_data,
    input m_axis_ready,
    output reg m_axis_valid
        );
        
        localparam SIZE =6,
        ARRAY_SIZE = SIZE*SIZE;
        fifo_buffer #(
        ) input_buff(
        .axi_clk(axi_clk),
    .axi_rstn(axi_rstn),
    
    .s_axis_ready(s_axis_ready),
    .s_axis_valid(s_axis_valid),
    .s_axis_data(s_axis_data),
    .m_axis_data(m_axis_data),
    .m_axis_ready(m_axis_ready),
    .m_axis_valid(m_axis_ready)
        );
        
    scheduler #(
    .DATA_WIDTH(DATA_WIDTH),
    .SIZE(SIZE))
    sch
    (
    .clk(axi_clk),
    .rst(),
    .N(), //size of square matrix
    .A_matrix(),
    .B_matrix(),
    .C_matrix()
    );
        
endmodule
