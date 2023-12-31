
module tb_4
#(
  parameter MEM_DEPTH = 8,
  parameter MEM_WIDTH = 32
);

  reg [MEM_WIDTH-1:0] operand1_mem [0:MEM_DEPTH-1];
  reg [MEM_WIDTH-1:0] operand2_mem [0:MEM_DEPTH-1];

  reg                          clk_i;
  reg                          rst_ni;
  wire [$clog2(MEM_DEPTH)-1:0] operand1_addr_o;
  wire [$clog2(MEM_DEPTH)-1:0] operand2_addr_o;
  wire [$clog2(MEM_DEPTH)-1:0] result_addr_o;
  wire [MEM_WIDTH-1:0]         result_o;

  operation #(
    .MEM_WIDTH(MEM_WIDTH),
    .MEM_DEPTH(MEM_DEPTH)
  ) op_inst (
    .clk_i          (clk_i),
    .rst_ni         (rst_ni),
    .operand1_i     (operand1_mem[operand1_addr_o]),
    .operand2_i     (operand2_mem[operand2_addr_o]),
    .operand1_addr_o(operand1_addr_o),
    .operand2_addr_o(operand2_addr_o),
    .result_addr_o  (result_addr_o),
    .result_o       (result_o)
  );

  result_mem #(
    .MEM_WIDTH(MEM_WIDTH),
    .MEM_DEPTH(MEM_DEPTH)
  ) mem_inst (
    .clk_i (clk_i),
    .rst_ni(rst_ni),
    .data_i(result_o),
    .addr_i(result_addr_o)
  );

  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD/2) clk_i=~clk_i;


  import "DPI-C" function int get_last_commit();
  import "DPI-C" function void step_glob();
  import "DPI-C" function void init(
    inout logic [MEM_WIDTH-1:0] target1[],
    inout logic [MEM_WIDTH-1:0] target2[]
  );

  initial begin:initialization
    init(operand1_mem, operand2_mem);
  end

  initial begin: iteration

    clk_i = 0;
    rst_ni = 0;
    #20 rst_ni = 1;


    for (int ii= 0;ii<MEM_DEPTH;ii = ii + 1) begin
      #40 wait(clk_i);
      step_glob();
      if (mem_inst.mem[ii] != get_last_commit())begin
        $display("mismatch detected %d: mem: %d;", ii,mem_inst.mem[ii]);
      end else begin
        $display("success on elemen %d: mem: %d;", ii,mem_inst.mem[ii]);
      end
    end

  end

endmodule
