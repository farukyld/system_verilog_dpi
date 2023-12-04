

module tb_;

  reg clk;
  reg rst_n;

  import "DPI-C" function void update_state();
  import "DPI-C" function int get_state();

  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD/2) clk=~clk;

  initial begin
       
  end

endmodule