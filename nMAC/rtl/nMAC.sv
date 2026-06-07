//N Bit Multiply Accumulate (MAC) Unit
//Inputs: A[n-1:0], B[n-1:0]
//Outputs: Q[m-1:0]

module n_MAC #(
    parameter n = 4;
    parameter m = 12;
)
(
    input logic [n-1:0] A,
    input logic [n-1:0] B,
    output logic [m-1:0] Q
);