//N Bit Multiply Accumulate (MAC) Unit
//Inputs: A[n-1:0], B[n-1:0]
//Outputs: Q[m-1:0]

module n_MAC #(
    parameter n = 4,
    parameter m = 12
)
(
    input logic [n-1:0] A,
    input logic [n-1:0] B,
    input logic clk,
    input logic n_rst,
    output logic [m-1:0] Q
);
    localparam int pad_size = m-n;

    logic [(n*2)-1:0] mult_output;
    logic [m-1:0] pad_mult_output;
    logic [m-1:0] accum;
    logic [m-1:0] next_accum;

    assign pad_mult_output = {{pad_size{1'b0}}, mult_output};

    //instantiate multiplier
    n_multiplier #(
        .n(n)
    ) m0 (
        .A(A),
        .B(B),
        .Q(mult_output)
    );

    //instantiate adder
    n_adder #(
        .n(m)
    ) a0 (
        .A(accum),
        .B(pad_mult_output),
        .Q(next_accum),
        .CIN(1'b0),
        .COUT()
    );

    //register to store accumulated value
    always_ff @(posedge clk) begin
        if(!n_rst)
            accum <= '0;
        else begin
            accum <= next_accum;
        end
    end

    assign Q = accum;
endmodule