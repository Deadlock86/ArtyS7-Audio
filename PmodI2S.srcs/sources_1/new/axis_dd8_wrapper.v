`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.10.2026 17:10:33
// Design Name: 
// Module Name: axis_dd8_wrapper
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


module axis_dd8_wrapper #(
    parameter DATA_WIDTH = 24)
    (
        input wire          clk,
        input wire          resetn,
        
        //DD8 ctrl signals
        input wire [2:0]    mode_sel,
        input wire [2:0]    dtime,
        input wire [2:0]    feedback,
        input wire [2:0]    elevel,
        input wire          enable,
        
        //AXI-stream Slave (from I2S RX)
        input wire [DATA_WIDTH-1:0] s_axis_data,
        input wire                  s_axis_valid,
        output wire                 s_axis_ready,
        input wire                  s_axis_last,
        
        //AXI-Stream Master (to I2S)
        output wire [DATA_WIDTH-1:0] m_axis_data,
        output wire                  m_axis_valid,
        input wire                   m_axis_ready,
        output wire                  m_axis_last 
       );
       
       // Handshake if the source can send and sink can receive
       wire axis_handshake = s_axis_valid && m_axis_ready;
       
       //AXI-Stream signals assign
       assign s_axis_ready = m_axis_ready;
       assign m_axis_valid = s_axis_valid;
       assign m_axis_last = s_axis_last;
       
       //DD-8 Delay Core instantiation
       dd8_core u_dd8_core (
            .clk        (clk),
            .new_sample (axis_handshake),
            .sample_in  ($signed(s_axis_data)),
            .mode_sel   (mode_sel),
            .feedback   (feedback),
            .elevel     (elevel),
            .enable     (enable),
            .sample_out (m_axis_data)
         );
       
endmodule

