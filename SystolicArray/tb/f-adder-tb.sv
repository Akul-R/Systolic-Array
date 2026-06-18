//Test Bench for full adder
//Inputs: A, B, CIN
//Outputs: Q, COUT

module f_addertb();
    //Inputs
    logic A;
    logic B;
    logic CIN;

    //Outputs
    logic Q;
    logic COUT;

    int Qerrors = 0;
    int Cerrors = 0;

    f_adder f0(.*);

    task check();
        #5ns $display("A: %b | B: %b | CIN: %b", A, B, CIN);
        $display("Q: %b | COUT: %b", Q, COUT);

        if(Q == (A^B)^CIN)
            $display("Q-PASS");
        else begin
            $display("Q-FAIL");
            Qerrors++;
        end

        if(COUT == (A&B) | ((A^B)&CIN))
            $display("COUT-PASS");
        else begin
            $display("COUT-FAIL");
            Cerrors++;
        end

        $display("---------------------------------");
    endtask

    initial begin
        A = 0;
        B = 0;
        CIN = 0;
        
        $display("FULL ADDER TEST");
        $display("---------------------------------");
        for (int i = 0; i < 8; i++) begin
            {A, B, CIN} = i;
            check();
        end
        $display("---------------------------------");
        $display("FINISHED WITH %0d ERRORS IN Q AND %0d ERRORS IN COUT", Qerrors, Cerrors);
    end

endmodule