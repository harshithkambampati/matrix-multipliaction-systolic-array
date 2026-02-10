`timescale 1ns / 1ps

module scheduler#(
    parameter DATA_WIDTH = 32,
    parameter SIZE = 6,
    ARRAY_SIZE =SIZE*SIZE
    )
    (
    input clk,
    input rst,
    input START,
    input [3:0] N, //six of square matrix
    input [ARRAY_SIZE*DATA_WIDTH-1:0] A_matrix,
    input [ARRAY_SIZE*DATA_WIDTH-1:0] B_matrix,
    output reg [ARRAY_SIZE*DATA_WIDTH-1:0] C_matrix,
    output reg GLOBAL_DONE
    );


reg [SIZE*DATA_WIDTH-1:0] A_row_line, B_column_line;
reg [SIZE*DATA_WIDTH-1:0] C_mat[SIZE-1:0];//Stores resultant matrix row-wise
wire [DATA_WIDTH-1:0] C_term[SIZE-1:0];//Stores the each element of the row of resultant matrix
reg [SIZE-1:0]START;
wire [SIZE-1:0]DONE;
reg [3:0] i, j;
integer k,l;

    reg [(DATA_WIDTH*SIZE)-1:0]A_mat[SIZE-1:0];
    reg [(DATA_WIDTH*SIZE)-1:0]B_mat[SIZE-1:0];
    
always @ (A_matrix, B_matrix)
begin
    for(k=0; k<=SIZE-1; k=k+1)
    begin
        A_mat[SIZE-1-k] = A_matrix[((k+1)*DATA_WIDTH*SIZE)-1 -: (DATA_WIDTH*SIZE)];
        B_mat[SIZE-1-k] = B_matrix[((k+1)*DATA_WIDTH*SIZE)-1 -: (DATA_WIDTH*SIZE)];
    end
//    for(l=0; l<SIZE; l=l+1)
//        for (m=SIZE; m>0; m=m-1)
//            B_mat[l] = {B_matrix[(((m)*SIZE)-l)*DATA_WIDTH-1 -: (DATA_WIDTH)],
//                        B_matrix[(((5)*SIZE)-l)*DATA_WIDTH-1 -: (DATA_WIDTH)],
//                        B_matrix[(((4)*SIZE)-l)*DATA_WIDTH-1 -: (DATA_WIDTH)],
//                        B_matrix[(((3)*SIZE)-l)*DATA_WIDTH-1 -: (DATA_WIDTH)],
//                        B_matrix[(((2)*SIZE)-l)*DATA_WIDTH-1 -: (DATA_WIDTH)],
//                        B_matrix[(((1)*SIZE)-l)*DATA_WIDTH-1 -: (DATA_WIDTH)]};// B matrix is stored column wise
end
genvar m;
generate
    for(m=0;m<SIZE;m=m+1)begin
      
    systolic_array#(
    .DATA_WIDTH(DATA_WIDTH),
    .SIZE(SIZE),
    .ARRAY_SIZE(ARRAY_SIZE)
)sa_1(
    .clk(clk),
    .rst(rst),
    .A_row_line(A_mat[m]),
    .B_column_line(B_column_line),
    .N(N),
    .START(START),
    .C_term(C_term[m]),
    .DONE(DONE[m])
    );    
    end    
    
endgenerate
always @ (posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        C_matrix <= 0;
        i <= 0;        
        
//        DONE <= 0;
//        A_row_line <= 0;
        B_column_line <= 0;
        
    end
    else 
        if (!GLOBAL_DONE)
        begin
            if(i!=N)
            begin
//                START <= {SIZE{1'b1}};
                B_column_line<=B_mat[i];       
                i <= i+1;
            end
        end
        else 
        begin
            
        end    
end

always @(posedge clk)
begin
    if(!rst)
    begin 
        j <=-1;
        
    end
else 
begin
    if (!GLOBAL_DONE)
    begin
        if(DONE=={SIZE{1'b1}})
        begin
        C_mat[j] <= {C_term[0],C_term[1],C_term[2],C_term[3],C_term[4],C_term[5]};
        j <=j+1;
        end
    end
    if (j==N-1) 
        GLOBAL_DONE = 1;
    if (GLOBAL_DONE)
        C_matrix = {C_mat[0],C_mat[1],C_mat[2],C_mat[3],C_mat[4],C_mat[5]};
end
end
endmodule
