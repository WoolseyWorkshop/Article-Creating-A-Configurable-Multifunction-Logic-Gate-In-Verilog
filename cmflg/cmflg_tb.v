// cmflg_tb.v
//
// Description:
// The configurable multifunction logic gate (cmflg) testbench.
//
// Notes:
// - Logical functions are used in the testbench to test the bitwise functions
//   used in the cmflg device.
//
// TODO:
// - None.
//
// Author(s)
// - Created by John Woolsey on 06/03/2022.
// - Modified by John Woolsey on 08/09/2022.
//
// Copyright (c) 2022 Woolsey Workshop.  All rights reserved.


`timescale 1ns/10ps
// `include "cmflg.v"


module cmflg_tb;
   reg a, b;     // logic input values for cmflg module
   reg [2:0] s;  // logic gate select input values for cmflg module
   wire y;       // logic output value for cmflg module

   integer i, j;  // for loop variables
   reg [3:0] states = {1'b1, 1'b0, 1'bz, 1'bx};  // all possible logic states

   initial begin
      $dumpfile("cmflg_tb.vcd");  // waveforms file
      $dumpvars;  // save waveforms
      $display("%d %m: Starting testbench simulation...", $stime);
      $monitor("%d %m: MONITOR - a = %b, b = %b, s = %b, y = %b.", $stime, a, b, s, y);

      // Tests all gate implementations with all possible input logic states
      for (i = 0; i < $bits(states); i = i + 1) begin
         for (j = 0; j < $bits(states); j = j + 1) begin
            #1; a = states[i]; b = states[j]; s = 'bx;
            #1; test_logic("UNDEF", 'bx);  // test undefined selector inputs
            #1; s = 'bz;
            #1; test_logic("Hi-Z", 'bx);  // test high-Z selector inputs
            #1; s = `BUF;
            #1; test_logic("BUF", a);  // test buffer gate logic
            #1; s = `INV;
            #1; test_logic("INV", !a);  // test inverter gate logic
            #1; s = `AND;
            #1; test_logic("AND", a && b);  // test AND gate logic
            #1; s = `NAND;
            #1; test_logic("NAND", !(a && b));  // test NAND gate logic
            #1; s = `OR;
            #1; test_logic("OR", a || b);  // test OR gate logic
            #1; s = `NOR;
            #1; test_logic("NOR", !(a || b));  // test NOR gate logic
            #1; s = `XOR;
            #1; test_logic("XOR", a != b);  // test XOR gate logic
            #1; s = `XNOR;
            #1; test_logic("XNOR", !(a != b));  // test XNOR gate logic
         end
      end

      // All tests passed
      #1 $display("\n%d %m: Testbench simulation PASSED.", $stime);
      $finish;  // end simulation
   end

   // Test the result of the logic gate
   task test_logic (
      input [5*8:1] logic_description,  // logic description string
      input logic_function              // expected logic function result
      );

      if (y !== logic_function) begin
         $display("%d %m: ERROR - %s - Expected a result of '%b', but received '%b' instead.", $stime, logic_description, logic_function, y);
         $finish;  // end simulation
      end
   endtask

   // Instances
   cmflg cmflg_1(.a(a), .b(b), .s(s), .y(y));

endmodule  // cmflg_tb
