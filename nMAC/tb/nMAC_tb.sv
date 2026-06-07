//N bit MAC Unit Test Bench
//Inputs: A[n-1:0], B[n-1:0], n_rst, clk
//Outputs: Q[m-1:0]

module nMAC_tb();
    //size parameters
    parameter n = 4;
    parameter m = 12;

    //other parameters
    parameter tests = 100;
    parameter reset_freq = 4; //resets after set number of consecutive operations

    //Inputs
    logic [n-1:0] A;
    logic [n-1:0] B;
    logic clk;
    logic n_rst;

    //Outputs
    logic [m-1:0] Q;

    //instantiate MAC
    n_MAC #(
        .n(n),
        .m(m)
    ) acc0 (.*);


    //-------------------------------------------------------------------------------
    int prevQ = 0;
    int incorrect = 0;
    int fails = 0;
    int correct = 0;
    logic [m-1:0] expected_ans = 0;

    initial begin
        clk = 0;
        forever begin
            #5ns clk = ~clk;
        end
    end

    initial begin
        n_rst = 0; A = 0; B = 0;

        $display("%0d BIT MAC UNIT TEST", n);
        $display("----------------------------------------------------------------");


        //-------------------------------------------------------------------------------
        //test reset functionality first    
        $display("TEST 1: RESET TEST");
        A = $urandom; B = $urandom;
        @(posedge clk);
        #1ps
        if(Q == 0)
            $display("[PASS] RESET FUNCTIONAL");
        else begin
            incorrect++;
            $display("[FAIL] RESET FAIL | EXPECTED: 0 | GOT: %0d", Q);
        end
        #1ns n_rst = 1;
        $display("----------------------------------------------------------------");

    
        //-------------------------------------------------------------------------------
        //main test with random variables

        for(int i = 0; i < tests; i++) begin
            fails = incorrect;
            for(int j = 0; j < reset_freq; j++) begin
                @(negedge clk);
                A = $urandom; B = $urandom;
                expected_ans = expected_ans + (A*B);

                @(posedge clk);
                #1ps
                if(Q == expected_ans)
                    correct++;
                else begin
                    incorrect++;
                    $display("[FAIL] TEST: %4d, ITERATION: %3d | A: %5d, B: %5d | EXPECTED: %5d | GOT: %5d", i, j, A, B, expected_ans, Q);
                    $display("----------------------------------------------------------------");
                end
            end

            if(fails == incorrect) begin
                $display("[PASS] TEST: %4d", i);
            end

            else begin
                $display("[FAIL] TEST: %4d", i);
                $display("----------------------------------------------------------------");
            end

            @(negedge clk);
            n_rst = 0;
            expected_ans = 0;

            @(posedge clk);
            n_rst = 1;
        end

        $display("----------------------------------------------------------------");
        $display("ALL TESTS FINISHED:");
        $display("PASSED: %5d | FAILED: %5d", correct, incorrect);
        $finish;
    end    

endmodule