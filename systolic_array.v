`timescale 1ns / 1ps


module systolic_array#(
    parameter DATA_WIDTH = 32,
    parameter SIZE = 6,
    parameter ARRAY_SIZE =SIZE*SIZE
)(
    input clk,
    input rst,
    input [SIZE*DATA_WIDTH-1:0]A_row_line,
    input [DATA_WIDTH*SIZE-1:0]B_column_line,
    input [3:0]N,
    input START,
    output [DATA_WIDTH-1:0] C_term,
    output reg DONE
    );
   
    reg [DATA_WIDTH-1:0]A_row[SIZE-1:0];
    reg [DATA_WIDTH-1:0]B_column[SIZE-1:0];
    integer i;
    
    reg [3:0]count;
    always @ (A_row_line, B_column_line)
    begin
        for(i=0; i<=SIZE-1; i=i+1)
        begin
            A_row[SIZE-1-i] = A_row_line[((i+1)*DATA_WIDTH)-1 -: DATA_WIDTH];
            B_column[SIZE-1-i] = B_column_line[((i+1)*DATA_WIDTH)-1 -: DATA_WIDTH];
        end
   end
   
    wire [DATA_WIDTH-1:0] data_out[ARRAY_SIZE-1:0];
    wire [DATA_WIDTH-1:0] data_right[ARRAY_SIZE-1:0];
    wire [DATA_WIDTH-1:0] data_down[ARRAY_SIZE-1:0];
    genvar x,y;// x- vertical, y- horizontal
    generate
    for(x =0; x<=SIZE-1; x= x+1)
    begin
        for(y =0; y<=SIZE-1; y= y+1)
        begin
            if(x ==0 && y== 0)
                begin
                pe #(.DATA_WIDTH(DATA_WIDTH)) pe_sa
                (.clk(clk),
                .rst(rst),
                .START(START),
                .A(A_row[x]),
                .B(B_column[x]),
                .C(32'b0),
                .data_down(data_down[SIZE*x +y]),
                .data_out(data_out[SIZE*x +y]),
                .data_right(data_right[SIZE*x +y])
               
               
                );
                end
                else if(x==0 && y!=0)
                begin
                pe #(.DATA_WIDTH(DATA_WIDTH)) pe_sa
                (.clk(clk),
                .rst(rst),
                .START(START),
                .C(32'b0),
                .A(A_row[y]),
                .B(data_right[y-1]),
                .data_down(data_down[SIZE*x +y]),
                .data_out(data_out[SIZE*x +y]),
                .data_right(data_right[SIZE*x +y])
               
                );
                   
                end
                else if(y==0 && x!=0)
                begin
                pe #(.DATA_WIDTH(DATA_WIDTH)) pe_sa
                (.clk(clk),
                .rst(rst),
                .START(START),
                .C(32'b0),
                .A(data_down[x-1]),
                .B(B_column[x]),
                .data_down(data_down[SIZE*x +y]),
                .data_out(data_out[SIZE*x +y]),
                .data_right(data_right[SIZE*x +y])
                );
                   
                end
               
                else if(x!=0 && y!=0)
                begin
                pe #(.DATA_WIDTH(DATA_WIDTH)) pe_sa
                (.clk(clk),
                .rst(rst),
                .START(START),
                .A(data_down[SIZE*(x-1)+y]),
                .B(data_right[y-1 + SIZE*(x)]),
                .C(data_out[SIZE*(x-1)+(y-1)]),
                .data_down(data_down[SIZE*x + y]),
                .data_out(data_out[SIZE*x + y]),
                .data_right(data_right[SIZE*x + y])              
                );
               
                end
        end
     end
   
    endgenerate
    
    always @(posedge clk or negedge rst)
    begin
        if(!rst)begin count =0; DONE = 0; end
        
        else
        begin
            if(count == N-1)begin
                count <= 0;
                DONE= 1'b1;
            end
            else 
            begin
                count = count+1;
            
            end
        end
    end
 
 assign C_term = (data_out[((SIZE+1)*(N-1))]);
   
endmodule
