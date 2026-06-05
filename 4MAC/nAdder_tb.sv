//n bit adder test bench
//Inputs: A[0:n-1], B[0:n-1], CIN
//Outputs: Q[0:n-1], COUT

module nAdder_tb();
    localparam n = 4; //size of n-bit adder
    localparam tests = 100; //number of random tests to do
    
    //inputs
    logic [n-1:0] A;
    logic [n-1:0] B;
    logic CIN;

    //outputs
    logic [n-1:0] Q;
    logic COUT;

    int correct = 0;
    int incorrect = 0;

    //-----------------------------------------------------------
    //Check Answer Function
    logic [n:0] correct_answer;

    task check();
        #5ns
        correct_answer = A + B + CIN;

        if((Q == correct_answer[n-1:0]) && (COUT == correct_answer[n])) begin
            correct++;
        end
        else begin
            incorrect++;
            $display("FAIL: A = %5d | B = %5d | CIN = %5d | EXPECTED = %5d | GOT = %5d", A, B, CIN, correct_answer[n-1:0], Q);
        end
    endtask

    n_adder #(
        .n(n)
    ) a0 (.*);

    initial begin

    $display("%0d BIT ADDER TEST", n);
    $display("---------------------------------");

    //----------------------------------------------------------------
    //test corner cases first
    A = 0;
    B = 0; 
    CIN = 0;
    check();

    //15+15+0
    A = (1 << n) - 1;
    B = (1 << n) - 1;
    CIN = 0;
    check();

    //15+15+1
    A = (1 << n) - 1;
    B = (1 << n) - 1;
    CIN = 1;
    check();

    //8+8+0
    A = (1 << n-1);
    B = (1 << n-1);
    CIN = 0;
    check();

    //---------------------------------------------------------------
    //Randomised checking. Try random numbers and see if result is correct
    for(int i = 0; i < tests; i++) begin 
        A = $urandom();
        B = $urandom();
        CIN = $urandom() % 2;
        check();
    end
    $display("---------------------------------");
    $display("FINISHED ALL TESTS:");
    $display("CORRECT: %0d | INCORRECT: %0d", correct, incorrect);
    $display("---------------------------------");
    $finish;
    end
endmodule



