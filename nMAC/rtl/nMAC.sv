//N Bit Multiply Accumulate (MAC) Unit
//Inputs: A[n-1:0], B[n-1:0], C[m-1:0]
//Outputs: Q[m-1:0]

/*  
new input added: C which allows us to load a value into the accumulate reg when
reset signal is asserted. In a convolution neural network, A could be the input
activation, B could be the weight and C could be the bias. C input only used by 
top row of MACs in a systolic array, the other units can omit this input (C 
would be tied to 0 for them).
*/

module n_MAC #(
    parameter n = 4,
    parameter m = 12
)
(
    input logic [n-1:0] A,
    input logic [n-1:0] B,
    input logic [m-1:0] C,
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
            accum <= C;
        else begin
            accum <= next_accum;
        end
    end

    assign Q = accum;
endmodule