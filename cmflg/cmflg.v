// cmflg.v
//
// Description:
// A configurable multifunction logic gate (cmflg) whose digital output is
// determined by a selectable logic function that is applied to the two digital
// inputs.
//
// Notes:
// - Provides all the basic digital logic gates: AND, NAND, OR, NOR, XOR, XNOR,
//   buffer, and inverter.
// - The design is very similar to an arithmetic logic unit (ALU) design, but
//   works on single ended digital inputs instead of on multibit registers.
//
// TODO:
// - None.
//
// Author(s)
// - Created by John Woolsey on 06/02/2022.
// - Modified by John Woolsey on 08/09/2022.
//
// Copyright (c) 2022 Woolsey Workshop.  All rights reserved.


`define DEBUG  // comment out for normal operation
`timescale 1ns/10ps


// Logic gate selection codes
`define BUF  3'b000  // buffer gate
`define INV  3'b001  // inverter gate
`define AND  3'b010  // AND gate
`define NAND 3'b011  // NAND gate
`define OR   3'b100  // OR gate
`define NOR  3'b101  // NOR gate
`define XOR  3'b110  // XOR gate
`define XNOR 3'b111  // XNOR gate


module cmflg (
   input a, b,     // logic inputs
   input [2:0] s,  // logic gate select inputs
   output reg y    // logic output
   );

   // Multifunction gate implementation
   always @(*) begin
      case (s)
            `BUF: y = a;       // buffer
            `INV: y = ~a;      // inverter
            `AND: y = a & b;   // AND
           `NAND: y = a ~& b;  // NAND
             `OR: y = a | b;   // OR
            `NOR: y = a ~| b;  // NOR
            `XOR: y = a ^ b;   // XOR
           `XNOR: y = a ~^ b;  // XNOR
         default: y = 1'bx;    // undefined
      endcase
   end

   // Debug status
   `ifdef DEBUG
   always @(*) begin  // logic input values changed
      $display("%d %m: DEBUG - Input values changed to a = %b and b = %b.", $stime, a, b);
   end
   always @(*) begin  // gate select values changed
      $display("%d %m: DEBUG - Select changed to s = %b.", $stime, s);
   end
   always @(*) begin  // logic output value changed
      $display("%d %m: DEBUG - Output value changed to y = %b.", $stime, y);
   end
   `endif

endmodule  // cmflg
