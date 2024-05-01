`timescale 1ns / 1ps


module alu_16bit(A,B,result,opcode,status);

    // Port definitions
    input [15:0] A,B;
    input [1:0] opcode;
    output [15:0] result;
    output [3:0] status; // C, V, Z
    
    parameter add=0, sub=1, mul=2, pow=3;
    
    // Output wires for each operation
    wire C,V,Z,E;
    wire [15:0] add_sub_out;
    wire [15:0] mul_out;
    wire [15:0] pow_out;


    assign Z = (result == 0) ? 1'b1: 1'b0;
    assign status = {C,V,Z,E};
    
    // Addition and subtraction
    add_sub_16bit addsub0(
        .A(A),
        .B(B),
        .S(add_sub_out),
        .M(opcode[0]),
        .C(C),
        .V(V)
    );
    
    // Multiplication
    mul_16bit_lut mul0(
        .A(A[7:0]),
        .B(B[7:0]),
        .P(mul_out)
    );
    
    // Power
    pow_16bit_lut pow0(
        .A(A[7:0]),
        .B(B[7:0]),
        .P(pow_out),
        .E(E)
    );

    // Multiplexer to select operation
    mux_4to1 mux(
        .A(add_sub_out),
        .B(add_sub_out),
        .C(mul_out),
        .D(pow_out),
        .sel(opcode),
        .out(result)
    );
endmodule


module fadder(
    input A,B,Cin,
    output Sum,Cout
    );
    
    wire HA1_sum, HA1_cout, HA2_cout;
    
    and U1(HA1_cout, A, B);  // Cout of first adder
    xor U2(HA1_sum, A,B);    // Sum of first adder
    
    
    and U3(HA2_cout, HA1_sum, Cin); // Cout of second adder
    xor U4(Sum, HA1_sum, Cin);      // Sum of second adder
    
    or  U5(Cout, HA2_cout, HA1_cout);
endmodule

module add_sub_16bit(
    input [15:0] A,
    input [15:0] B,
    input M,
    output [15:0] S,
    output C,V
    );
    
    wire [15:0] BM;     // The B xor M signal
    wire [15:0] Cout;   // Intermediate Cout's for each full-adder result
    
    
    // Implement the 'mode' select M by XORing M with each bit of B
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            xor U0 (BM[i], B[i], M);
        end
    endgenerate


    // Instantiate the first adder
    fadder fa0 (.A(A[0]), .B(BM[0]), .Cin(M), .Sum(S[0]), .Cout(Cout[0]));
    
    // Generate the remaining adders (15 of them)
    genvar j;
    generate
        for (j = 1; j < 16; j = j + 1) begin
            fadder fax (.A(A[j]), .B(BM[j]), .Cin(Cout[j-1]), .Sum(S[j]), .Cout(Cout[j]));
        end
    endgenerate
    
    assign V = Cout[14] ^ Cout[15];
    assign C = Cout[15];
endmodule


// 4x1 MUX with 4-bit inputs
module mux_4to1 (
    input [15:0] A,       // 4-bit input
    input [15:0] B,
    input [15:0] C,
    input [15:0] D,
    input [1:0] sel,     // 2-bit selector
    output reg [15:0] out);

    always @(*) begin
        case (sel)
          2'b00: out <= A;
          2'b01: out <= B;
          2'b10: out <= C;
          2'b11: out <= D;
        endcase
    end
endmodule