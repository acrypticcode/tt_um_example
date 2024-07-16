/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    mainsylv sylvmod (
    .clk(clk),
      .reset(rst_n),
    .sylvout(sylv_output)
  );
  

  mainsqrs sqrsmod (
    .clk(clk),
    .reset(rst_n),
    .counter(counter_value),
    .perfout(sqrs_output)
  );

  mainexp3 exp3mod (
    .clk(clk),
    .reset(rst_n),
    .counter(counter_value),
    .expout(exp3_output)
  );

  mainpad padmod (
    .clk(clk),
    .reset(rst_n),
    .padout(pad_output)
  );

  mainluc lucmod (
    .clk(clk),
    .reset(rst_n),
    .lucout(luc_output)
  );

  maintri trimod (
    .clk(clk),
    .reset(rst_n),
    .counter(counter_value),
    .triout(tri_output)
  );

  mainpell pellmod (
    .clk(clk),
    .reset(rst_n),
    .pellout(pell_output)
  );

  mainfib fibmod (
    .clk(clk),
    .reset(rst_n),
    .fibout(fib_output)
  );

  maincounter counter_inst (
    .clk(clk),
    .reset(rst_n),
    .countout(counter_value)
  );
  
  logic [7:0] counter_value;

  logic [7:0] sylv_output, sqrs_output, exp3_output, pad_output,
              luc_output, tri_output, pell_output, fib_output;

  logic [7:0] active_sequence;
  
   always@(posedge clk) begin
     if (rst_n) begin
       case (ui_in[2:0])
        3'b000: uo_out <= sylv_output;
        3'b001: uo_out <= sqrs_output;
        3'b010: uo_out <= exp3_output;
        3'b011: uo_out <= pad_output;
        3'b100: uo_out <= luc_output;
        3'b101: uo_out <= tri_output;
        3'b110: uo_out <= pell_output;
        3'b111: uo_out <= fib_output;
    endcase
    end
  end
  
  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule

module maincounter(
  input logic clk,
  input logic reset,
  output logic [7:0] countout
);
  
  always@(posedge clk) begin
    countout <= countout+0'b00000001;
    if (!reset) begin
      countout <= 0'b00000001;
    end
  end
  
endmodule

module mainsqrs(
  input logic clk,
  input logic reset,
  input logic [7:0] counter,
  output logic [7:0] perfout
);

  always@(posedge clk) begin
    perfout <= counter*counter;
    if (!reset) begin
      perfout <= 8'b00000000;
    end
  end
endmodule

module mainexp3(
  input logic clk,
  input logic reset,
  input logic [7:0] counter,
  output logic [7:0] expout
);

  always@(posedge clk) begin
    expout <= expout*3;
    if (!reset) begin
      expout <= 8'b00000001;
    end
  end
endmodule

module mainpad(
  input logic clk,
  input logic reset,
  output logic [7:0] padout
);
  logic [7:0] next2;
  logic [7:0] next1;

  always@(posedge clk) begin
    next2 <= next1 + padout;
    next1 <= next2;
    padout <= next1;
    if (!reset) begin
      next2 <= 0'b00000001;
      next1 <= 0'b00000001;
      padout <= 0'b00000001;
    end
  end
endmodule

module mainluc(
  input logic clk,
  input logic reset,
  output logic [7:0] lucout
);
  logic [7:0] nextout;
  
    
  always@(posedge clk) begin
    nextout <= nextout+lucout;
    lucout <= nextout;
    if (!reset) begin
      nextout <= 8'b00000001;
      lucout <= 8'b00000010;
    end
      
  end
  
endmodule

module maintri(
  input logic clk,
  input logic reset,

  input logic [7:0] counter,
  output logic [7:0] triout
);
  
  always@(posedge clk) begin
    triout <= triout+counter;
    if (!reset) begin
      triout <= 8'b00000000;
    end
  end
endmodule

module mainpell(
  input logic clk,
  input logic reset,
  output logic [7:0] pellout
);  
  logic [7:0] nextout;

  always@(posedge clk) begin
    nextout <= 2*nextout+pellout;
    pellout <= nextout;
    if (!reset) begin
      nextout <= 8'b00000001;
      pellout <= 8'b00000000;
    end
  end
  
endmodule

module mainfib(
  input logic clk,
  input logic reset,
  output logic [7:0] fibout
);
  logic [7:0] nextout;
    
  always@(posedge clk) begin  
    nextout <= nextout+fibout;
    fibout <= nextout;
    if (!reset) begin
      nextout <= 8'b00000001;
      fibout <= 8'b00000001;
    end
  end
  
endmodule

module mainsylv( 
  input logic clk,
  input logic reset,
  output logic [7:0] sylvout
);
  logic [7:0] nextout;

  
  always@(posedge clk) begin
    nextout <= nextout*(nextout-1)+1;
    sylvout <= nextout;
    if (!reset) begin
      sylvout <= 8'b00000010;
      nextout <= 8'b00000011;
    end
    
  end
endmodule