
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2024 10:22:43 AM
// Design Name: 
// Module Name: tb_alu_16bit
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


module tb_alu_16bit();
    reg [3:0] opcode;
    wire C,V,Z,E;
    reg [15:0] A,B;        // reg for the inputs
    wire [15:0] result;    // wire for the outputs
    
    alu_16bit U1(
        .A(A),
        .B(B),
        .result(result),
        .status({C,V,Z,E}),
        .opcode(opcode)
    );
    
    initial begin
        A <= 5;
        B <= 3;
        #10;
        #10 opcode <= 0; // Try all the opcodes and hope it works
        #10 opcode <= 1;
        #10 opcode <= 2;
        #10 opcode <= 3;
        
        #10;
        A <= 16'h0003;
        B <= 16'h0007;
        #10 opcode <= 0;
        #10 opcode <= 1;
        #10 opcode <= 2;
        #10 opcode <= 3;
        
        #10;
        A <= 16'h0003;
        B <= 16'h000B;
        #10 opcode <= 0;
        #10 opcode <= 1;
        #10 opcode <= 2;
        #10 opcode <= 3; // raises the 'E' flag
        
        #10;
        A <= 16'h8001;
        B <= 16'h8001;
        #10 opcode <= 0;
        #10 opcode <= 1; // raises the 'Z' flag
        #10 opcode <= 2;
        #10 opcode <= 3;
        
        #10;
        A <= 16'hAA00;
        B <= 16'hAA00;
        #10 opcode <= 0; // raises the 'C' flag
        #10 opcode <= 1;
        #10 opcode <= 2;
        #10 opcode <= 3;
        
        #10;
        A <= 16'h00FF;
        B <= 16'h00FF;
        #10 opcode <= 0;
        #10 opcode <= 1;
        #10 opcode <= 2;
        #10 opcode <= 3;
    end
endmodule

