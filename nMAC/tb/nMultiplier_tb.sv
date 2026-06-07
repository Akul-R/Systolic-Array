//N bit Array Multipler Test Bench
//Inputs: A[N-1:0], B[N-1:0]
//Outputs: Q[(N*2)-1:0]

module nmultiplier_tb();
    localparam n = 4;
    localparam tests = 200;

    //Inputs
    logic [n-1:0] A;
    logic [n-1:0] B;
    
    //Outputs
    logic [(n*2)-1:0] Q;

    //-----------------------------------------------
    //Check Answer task
    int correct = 0;
    int incorrect = 0;

    logic [(n*2)-1:0] expected_ans;

    task check();
        #5ns
        expected_ans = A*B;

        if(Q == expected_ans) begin
            correct++;
        end
        else begin
            incorrect++;
            $display("FAIL: A = %5d | B = %5d | EXPECTED = %5d | GOT = %5d", A, B, expected_ans, Q);
        end
    endtask

    n_multiplier #(
        .n(n)
    ) m0 (.*);
    

    //---------------------------------------------------
    //Begin testing

    initial begin
        $display("%0d BIT MULTIPLIER TEST", n);
        $display("---------------------------------");

        //------------------------------------------------
        //Test Corner Cases
        //0 x 0
        A = 0; B = 0;
        check();

        //MAX x MAX
        A = '1; B = '1;
        check();

        //------------------------------------------------
        //random testing
        for(int i = 0; i < tests; i++) begin
            A = $urandom; B = $urandom;
            check();
        end

        //------------------------------------------------
        $display("---------------------------------");
        $display("FINISHED ALL TESTS:");
        $display("CORRECT: %0d | INCORRECT: %0d", correct, incorrect);
        $display("---------------------------------");
        $finish;
    end
endmodule