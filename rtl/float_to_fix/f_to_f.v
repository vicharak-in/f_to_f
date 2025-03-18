module f_to_f (
    input             clk,
    input             rstn,
    input  [47:0]     datain,
    input             empty,
    output     [47:0] dataout,
    output reg        rden,
    output            wren
);
  wire [39:0] int_in;
  wire [39:0] frec_in;
  wire [79:0] float_in;

  wire [15:0] int_out_1;
  wire [15:0] frec_out_1;
  wire [31:0] float_out_1;

  wire [31:0] int_out_2;
  wire [31:0] frec_out_2;
  wire [63:0] float_out_2;

  wire [39:0] int_out_3;
  wire [39:0] frec_out_3;
  wire [79:0] float_out_3;

  wire [ 1:0] app;
  wire [ 2:0] size;
  wire        clk_en_1;
  wire        clk_en_2;
  wire        clk_en_3;
  wire        clk_en_4;
  wire        clk_en_5;
  wire        clk_en_6;
  wire        done_1;
  wire        done_2;
  wire        done_3;
  wire        done_4;
  wire        done_5;
  wire        done_6;

  always @(posedge clk) begin
    if (empty == 0) rden = 1;
    else if (empty == 1) rden = 0;
  end
  collector uc (
      .clk       (clk),
      .rstn      (rstn),
      .datain    (datain),
      .int       (int_in),
      .frec      (frec_in),
      .float     (float_in),
      .app       (app),
      .size      (size),
      .clk_en_1  (clk_en_1),
      .clk_en_2  (clk_en_2),
      .clk_en_3  (clk_en_3),
      .clk_en_4  (clk_en_4),
      .clk_en_5  (clk_en_5),
      .clk_en_6  (clk_en_6)
  );

  float_to_fixed_1 ufl1  //32
  (
      .clk             (clk),
      .rstn            (rstn),
      .clk_en_1        (clk_en_1),
      .float_val       (float_in),
      .fixed_fraction  (frec_out_1),
      .fixed_integer   (int_out_1),
      .done_1          (done_1)
  );

  float_to_fixed_2 ufl2  //64
  (
      .clk             (clk),
      .rstn            (rstn),
      .clk_en_2        (clk_en_2),
      .float_val       (float_in[79:16]),
      .fixed_fraction  (frec_out_2),
      .fixed_integer   (int_out_2),
      .done_2          (done_2)
  );

  float_to_fixed_3 ufl3  //80
  (
      .clk             (clk),
      .rstn            (rstn),
      .clk_en_6        (clk_en_6),
      .float_val       (float_in),
      .fixed_fraction  (frec_out_3),
      .fixed_integer   (int_out_3),
      .done_6          (done_6)
  );

  fixed_to_float_1 ufi1  //16
  (
      .clk             (clk),
      .rstn            (rstn),
      .clk_en_3        (clk_en_3),
      .float_val       (float_out_1),
      .fixed_fraction  (frec_in),
      .fixed_integer   (int_in),
      .done_3          (done_3)
  );

  fixed_to_float_2 ufi2  //32
  (
      .clk             (clk),
      .rstn            (rstn),
      .clk_en_4        (clk_en_4),
      .float_val       (float_out_2),
      .fixed_fraction  (frec_in),
      .fixed_integer   (int_in),
      .done_4          (done_4)
  );

  fixed_to_float_3 ufi3  //40
  (
      .clk             (clk),
      .rstn            (rstn),
      .clk_en_5        (clk_en_5),
      .float_val       (float_out_3),
      .fixed_fraction  (frec_in),
      .fixed_integer   (int_in),
      .done_5          (done_5)
  );

  dout ud (
      .clk      (clk),
      .int_1    (int_out_1),
      .frec_1   (frec_out_1),
      .float_1  (float_out_1),
      .int_2    (int_out_2),
      .frec_2   (frec_out_2),
      .float_2  (float_out_2),
      .int_3    (int_out_3),
      .frec_3   (frec_out_3),
      .float_3  (float_out_3),
      .size     (size),
      .app      (app),
      .done_1   (done_1),
      .done_2   (done_2),
      .done_3   (done_3),
      .done_4   (done_4),
      .done_5   (done_5),
      .done_6   (done_6),
      .dataout  (dataout),
      .wren     (wren)
  );
endmodule
