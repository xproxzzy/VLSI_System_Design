`timescale 1ns / 10ps

`include "./Top.v"

`define CYCLE 10
`define MAX_CLOCK_CYCLE 1000000
`define REG_FILE top.regfile.registers
`define PC top.pc
`define IM top.im.mem
`define DM top.dm.mem

`define PROG_PATH "add.hex" // should be replaced with the path to test program when typing xrun command

module testbench;
    reg clock, reset;	
	wire halt;

    /* instantiate top module */
    Top top (
        .clk (clock),
        .rst (reset),
        .halt(halt)
    );

    /* clock generating */ always #(`CYCLE / 2) clock = ~clock;
    initial begin
        // checking the path for test program
        //if (!`PROG_PATH) begin
        //    $error("Please specify the path of your test program!\nAbort!");
        //    $finish;
        //end

        // $display("D R3 : %08x", `REG_FILE[3]);
        // $monitor("M R3 : %08x", `REG_FILE[3]);

        /* initialize variables */
        clock                 = 0;
        reset                 = 0;

        /* initialize memory contect of dut */
        $readmemh(`PROG_PATH, `IM);
        $readmemh(`PROG_PATH, `DM);

        /* start simulaation, pull down reest signal */
        #(6) reset = 1;
        #(`CYCLE - 6) reset = 0;

        clock                 = 1;
        /* difftest main loop */

	    
    end

    /* conditions which will terminate the simulation */
    initial begin
        wait ((halt == 1'b1));
        if (halt == 1'b1) begin
            print_success;
        end else begin
            print_fail;
        end
        $finish;
    end

    /* check maximum clock cycle constraint */
    initial begin
        #(`MAX_CLOCK_CYCLE) print_exceed_sim_time;
        $finish;
    end

    /* generate waveform file */
    initial begin
        $dumpfile("test.fsdb");
        $dumpvars;
    end

    // initial begin
    //     $dumpfile("testbench.fsdb");
    //     $dumpvars;
    // end

    /* utils */
    task print_success;
	begin
        $display(
            "                                        ⠰⣣⣿⣣⢟⡴⣿⢏⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡜⣿⣿⣿⣿⣿⣧       ");
        $display(
            "                                       ⣴⣿⣿⠃⠞⣼⣿⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢹⣿⣿⣿⣿⠋⠠       ");
        $display(
            "                                     ⢀⡜⣯⣶⢇⣘⢰⣿⡏⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⡇⣿⡟⡟⡇⢀⡆⠀⠀⠀⠀⠀⠀ ");
        $display(
            "                                     ⣼⢧⣿⡿⣼⡟⢸⣿⢡⠁⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⢿⣿⢝⠟⣿⠀⠈⡅       ");
        $display(
            "                                    ⣦⣿⢸⣿⢧⡟⡠⠗⠋⠟⠞⢻⣿⣿⠙⣿⡇⢹⣿⡇⡎⣋⣿⢀⣠⢻⢾⠀⠣       ");
        $display(
            "                                   ⣼⢽⣿⢸⣿⢈⡞⢠⢾⠍⠑⡐⣌⢿⣿⡷⡽⣇⡷⠻⣆⡡⢿⣿⢸⣿⣿⣿⡆⠀⠀⢀     ");
        $display(
            "                                  ⣰⣿⡾⣿⢸⡿⣟⢠⡏⠨⡄⠀⣇⣿⣮⡻⢇⢿⢖⣴⡒⠢⡀⠘⣿⢸⣿⣿⡿⣼⡷⡄⣼⡄    ");
        $display(
            "                                 ⢰⣿⣿⡇⣿⡸⡇⣗⢸⣇⠔⢀⣸⣿⣿⣿⣿⣿⣿⡎⢛⡅⠀⣷⡀⡹⣼⣿⣟⣼⡿⣱⡇⣿⡇    ");
        $display(
            "    **************************** ⣼⣿⣿⣿⡼⣇⠇⣟⠳⠟⠿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠉⣉⢠⣿⡇⣃⡿⢫⣾⢟⣵⣿⡇⣿⡇    ");
        $display(
            "    **                        ** ⢿⣿⣿⣿⣷⡹⡜⢿⣳⢰⣜⣽⣿⡿⠷⢿⣿⣿⣟⢿⣶⣶⣿⡟⡐⢜⣵⡿⣫⣾⣿⣿⣧⣿⢧⢰⡀  ");
        $display(
            "    **  Waku Waku !!          **⠆⢸⣿⣿⣿⣿⣷⡱⡘⢿⣿⣿⣿⡿⣼⣿⣿⢸⣿⡿⣦⡌⠛⣳⡞⣠⡾⣫⣾⣿⣿⣿⣿⢸⡿⡐⣾⣇  ");
        $display(
            "    **                        ** ⠘⣿⣿⣿⣿⣿⣿⡄⠀⠙⠿⣿⡇⣿⣿⣿⢸⣿⣿⣾⣽⣷⢟⢜⣫⣾⣿⣿⣿⣿⣿⡟⢼⢣⢳⣸⣿  ");
        $display(
            "    **  Simulation PASS !!    **   ⠹⣿⣿⣿⣿⣿⣿⠀⠀⡿⢺⣽⠒⠾⢭⣼⣿⣿⣿⠿⠫⣱⣿⣿⣿⣿⣿⣿⣿⣿⢇⢏⠏⠈⢹⡿ ");
        $display(
            "    **                        **     ⠹⣿⣿⣿⣿⡿⣠⠶⣿⣷⡜⡏⣿⣶⠶⣶⢾⢿⢇⣼⣿⣿⣿⣿⣿⣿⣿⣿⠏⠊⠀⠀⠀⣾⠇");
        $display(
            "    ****************************      ⠈⠻⣿⡿⣼⡿⣿⣶⣯⠃⡎⠩⠰⣛⠿⣷⡍⣼⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⢀⠋ ");
        $display(
            "                                         ⠈⠃⠿⠿⠾⠝⠿⠰⠑⠀⠿⠿⠿⠶⠿⠼⠿⠿⠿⠿⠿⠟⠉⠀⠀⠀        ");
	end
    endtask

    task print_fail;
	begin
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⠶⠟⠛⠉⠁⠉⠛⠃⠀⠈⣿⠻⠷⠶⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡄⠀⠀⠀⠀⠀⠈⠙⢿⣦⣄⣀⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠾⠋⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⡉⢹⣿⣿⣿⣷⣶⣶⣤⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠋⠀⣼⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⠀⠀⠀⠀⠀⠀⠀⠘⣿⣧⠀⢩⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⣴⠏⠀⠀⢸⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣧⠀⠀⠀⠀⠀⠀⢀⠀⠘⣿⣷⡀⢉⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⣠⣾⠃⠀⠀⠀⣿⠃⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⣿⠀⠀⠀⢹⣇⠀⠀⠀⠀⠀⠘⣇⠀⠘⢿⣷⡉⠉⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⣀⣠⣴⣾⡿⠁⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⢰⡇⠀⠀⠸⣇⠀⠀⠀⢻⡄⠀⠀⠀⠀⠀⢻⡀⠀⠈⠻⣿⣮⡉⢹⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⢰⣿⣿⣿⣿⣿⠁⠀⢀⠀⠁⠀⢻⡆⠀⠀⠀⠀⠀⠀⢸⣧⠀⠀⠀⢻⡄⠀⠀⠀⢿⡀⠀⠀⠀⠀⠸⡇⠀⠀⠀⠘⡿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠘⣿⣿⣿⣿⠇⠀⠀⣾⠀⠀⠀⢸⣧⠀⠀⠀⠀⠀⠀⠈⣿⣦⠀⠀⠈⢿⣄⠀⠀⠈⢷⡀⠀⠀⠀⠀⣷⠀⠀⠀⠀⢷⡀⠙⢿⣷⡀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⢻⣿⣿⡏⠀⢠⡀⢻⠀⠀⠀⢸⣿⣦⡀⠀⠀⠀⠀⠀⢿⡉⢷⡄⠀⠘⢿⣦⡀⠀⠈⢷⡀⠀⠀⠀⢻⠀⠀⠀⠀⠈⣧⠀⠈⢻⣷⡀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠘⣿⡿⠀⠀⣸⠀⣸⡇⠀⠀⢸⡇⠈⢷⣄⡀⠀⠀⠀⢺⣇⠀⠙⢦⣄⠈⢷⡹⢦⡀⠈⣷⠀⠀⠀⢸⡇⠀⠀⠀⠀⠸⣇⠀⠀⠹⣷⡀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⣸⡇⠀⠀⡯⢠⣿⢿⡄⠀⢸⡇⠀⠀⠈⠛⠶⣦⣄⣀⣹⣿⡓⠳⠎⠛⠲⠿⢦⣽⣶⣼⣇⠀⠀⢸⡇⠀⠀⠀⠀⠀⢻⡄⠀⠀⢻⣧⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⢠⣿⠀⠀⠀⡇⣼⠏⠀⠻⣆⢘⣧⣴⠖⠋⠀⠀⠀⠀⠉⠁⠉⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡁⠀⢸⡇⠀⠀⠀⠀⠀⠘⣷⠀⠀⠈⣿⣇⠀⠀⠀⠀");
        $display(
            "                                     ⠀⣼⡟⠀⠀⠀⣿⡟⠀⠀⠀⠙⠳⠥⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣼⡇⠀⢸⡇⠀⠀⠀⠀⠀⠀⢹⡇⠀⠀⡟⢿⣆⠀⠀⠀");
        $display(
            "                                     ⢀⣿⡇⠀⠀⠀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡤⢶⣾⣿⣿⣏⡹⠿⣇⠀⢸⡇⠀⠀⠀⠀⠀⠀⠘⣧⠀⠀⣧⠸⣿⡀⠀⠀");
        $display(
            "                                     ⢸⣿⢣⠀⠀⠀⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣯⠵⠶⠛⠉⠁⠀⠀⠀⠀⢿⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⢻⠀⠀⣿⠀⣿⣧⠀⠀");
        $display(
            "                                     ⣸⡏⢹⠀⠀⠀⢿⡇⠀⠀⠀⣠⣤⣶⣾⣿⣻⣿⡿⠖⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⢀⠀⣀⠀⢸⡀⢸⠀⠀⠀⠀⠀⠀⠀⠀⢸⡆⠀⡿⢰⡏⣿⡀⠀");
        $display(
            "                                     ⣿⡇⢸⡄⠀⠀⢸⣿⢀⣴⣟⣡⡽⠟⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡆⠸⣗⠻⠗⠻⠇⢸⡇⣸⠁⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⡇⢸⠇⢸⣧⠀");
        $display(
            "                                     ⣿⡅⠘⣇⠀⠀⠀⣿⡘⠛⠉⠁⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⢈⡇⣿⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⢠⣃⡿⠀⠀⣿⠀");
        $display(
            "    ****************************     ⣿⢷⡀⢹⡄⠀⠀⢹⡇⠀⠀⣸⡆⠶⠄⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⡶⠃⠀⠀⠀⠀⠀⢸⣧⡇⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠘⣼⠃⠀⠀⢻⡄");
        $display(
            "    **                        **     ⣿⠈⣧⠈⢷⠀⠀⠈⣿⠀⠀⠈⠀⠀⠀⠀⢀⠀⠀⢀⣀⣤⠴⠖⢚⣩⠽⠋⠀⠀⠀⠀⠀⠀⠀⠀⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⣸⠀⣰⠏⠀⠀⠀⢼⡇");
        $display(
            "    **  OOPS !!               **     ⣿⠀⠘⣇⠘⣧⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠉⠛⠛⠷⠖⠒⠒⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⢁⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⢰⠟⠀⠀⠀⠀⣿⡄");
        $display(
            "    **                        **     ⣿⡄⠀⠘⣦⠘⣇⠀⠈⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⠾⠋⢀⣽⡇⠀⠀⠀⠀⠀⠀⠀⠀⢨⡷⠋⠀⠀⠀⠀⠀⣿⠀");
        $display(
            "    **  Simulation Failed !!  **     ⢸⣧⠀⠀⠘⢧⡘⢧⡀⠘⠻⠶⢤⣤⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⣀⣀⣠⣴⣾⠟⠋⢀⣠⠶⢻⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠃⠀⠀⠀⠀⠀⣰⡏⠀");
        $display(
            "    **                        **      ⢿⡆⠀⠀⡈⢳⣄⠱⣄⠀⠀⠀⠀⠀⣽⠉⠉⢉⣉⠙⢿⣉⠉⠻⣿⡿⠋⢀⣠⠖⠋⠁⠀⣾⠁⠀⠀⠀⠀⠀⠀⠀⠀⢰⡟⠀⠀⠀⠀⠀⣠⡟⠀⠀");
        $display(
            "    ****************************      ⠈⢿⡄⠐⣧⠀⠙⢦⡈⠀⠀⠀⠀⠀⢻⣆⠀⠀⠙⢦⣀⠉⠳⢤⣘⣧⠶⠋⠁⠀⠀⠀⣰⡿⠀⠀⠀⠀⠀⠀⠀⢀⣠⠿⠃⠀⠀⠀⢀⣴⠟⠁⠀⠀");
        $display(
            "                                       ⠈⢿⣄⢿⣧⡀⠀⠛⢦⣄⠀⠀⠀⢸⣿⣷⣄⡀⠀⠉⠳⠶⣶⠞⠁⠀⠀⠀⢀⣠⣾⣿⠀⠀⠀⠀⠀⠀⣠⣴⡏⠁⠀⠀⢀⣠⡴⠟⠁⠀⠀⠀⠀");
        $display(
            "                                         ⠻⣾⣿⣛⣦⣄⠀⠈⠛⠲⠦⣄⣿⡇⠈⠙⠛⠶⠶⢶⣿⠀⠀⠀⢀⣴⣿⣿⣿⣯⣀⣀⣤⣤⣶⣿⣿⣿⣿⡛⠛⠋⠉⠉⠀⠀⠀⠀⠀  ");
        $display(
            "                                      ⠀⠀⠀⠀⠀⠘⣻⣷⣄⣙⡛⠶⠦⣤⣤⣄⣸⣷⡄⠀⠀⠀⢠⠏⣻⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display("\n");
	end
    endtask

    task print_exceed_sim_time;
	begin
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⠶⠟⠛⠉⠁⠉⠛⠃⠀⠈⣿⠻⠷⠶⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡄⠀⠀⠀⠀⠀⠈⠙⢿⣦⣄⣀⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠾⠋⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⡉⢹⣿⣿⣿⣷⣶⣶⣤⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠋⠀⣼⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⠀⠀⠀⠀⠀⠀⠀⠘⣿⣧⠀⢩⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⣴⠏⠀⠀⢸⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣧⠀⠀⠀⠀⠀⠀⢀⠀⠘⣿⣷⡀⢉⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⣠⣾⠃⠀⠀⠀⣿⠃⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⣿⠀⠀⠀⢹⣇⠀⠀⠀⠀⠀⠘⣇⠀⠘⢿⣷⡉⠉⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⣀⣠⣴⣾⡿⠁⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⢰⡇⠀⠀⠸⣇⠀⠀⠀⢻⡄⠀⠀⠀⠀⠀⢻⡀⠀⠈⠻⣿⣮⡉⢹⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⢰⣿⣿⣿⣿⣿⠁⠀⢀⠀⠁⠀⢻⡆⠀⠀⠀⠀⠀⠀⢸⣧⠀⠀⠀⢻⡄⠀⠀⠀⢿⡀⠀⠀⠀⠀⠸⡇⠀⠀⠀⠘⡿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠘⣿⣿⣿⣿⠇⠀⠀⣾⠀⠀⠀⢸⣧⠀⠀⠀⠀⠀⠀⠈⣿⣦⠀⠀⠈⢿⣄⠀⠀⠈⢷⡀⠀⠀⠀⠀⣷⠀⠀⠀⠀⢷⡀⠙⢿⣷⡀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⢻⣿⣿⡏⠀⢠⡀⢻⠀⠀⠀⢸⣿⣦⡀⠀⠀⠀⠀⠀⢿⡉⢷⡄⠀⠘⢿⣦⡀⠀⠈⢷⡀⠀⠀⠀⢻⠀⠀⠀⠀⠈⣧⠀⠈⢻⣷⡀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠘⣿⡿⠀⠀⣸⠀⣸⡇⠀⠀⢸⡇⠈⢷⣄⡀⠀⠀⠀⢺⣇⠀⠙⢦⣄⠈⢷⡹⢦⡀⠈⣷⠀⠀⠀⢸⡇⠀⠀⠀⠀⠸⣇⠀⠀⠹⣷⡀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⣸⡇⠀⠀⡯⢠⣿⢿⡄⠀⢸⡇⠀⠀⠈⠛⠶⣦⣄⣀⣹⣿⡓⠳⠎⠛⠲⠿⢦⣽⣶⣼⣇⠀⠀⢸⡇⠀⠀⠀⠀⠀⢻⡄⠀⠀⢻⣧⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⢠⣿⠀⠀⠀⡇⣼⠏⠀⠻⣆⢘⣧⣴⠖⠋⠀⠀⠀⠀⠉⠁⠉⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡁⠀⢸⡇⠀⠀⠀⠀⠀⠘⣷⠀⠀⠈⣿⣇⠀⠀⠀⠀");
        $display(
            "                                     ⠀⣼⡟⠀⠀⠀⣿⡟⠀⠀⠀⠙⠳⠥⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣼⡇⠀⢸⡇⠀⠀⠀⠀⠀⠀⢹⡇⠀⠀⡟⢿⣆⠀⠀⠀");
        $display(
            "                                     ⢀⣿⡇⠀⠀⠀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡤⢶⣾⣿⣿⣏⡹⠿⣇⠀⢸⡇⠀⠀⠀⠀⠀⠀⠘⣧⠀⠀⣧⠸⣿⡀⠀⠀");
        $display(
            "                                     ⢸⣿⢣⠀⠀⠀⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣯⠵⠶⠛⠉⠁⠀⠀⠀⠀⢿⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⢻⠀⠀⣿⠀⣿⣧⠀⠀");
        $display(
            "                                     ⣸⡏⢹⠀⠀⠀⢿⡇⠀⠀⠀⣠⣤⣶⣾⣿⣻⣿⡿⠖⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⢀⠀⣀⠀⢸⡀⢸⠀⠀⠀⠀⠀⠀⠀⠀⢸⡆⠀⡿⢰⡏⣿⡀⠀");
        $display(
            "                                     ⣿⡇⢸⡄⠀⠀⢸⣿⢀⣴⣟⣡⡽⠟⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡆⠸⣗⠻⠗⠻⠇⢸⡇⣸⠁⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⡇⢸⠇⢸⣧⠀");
        $display(
            "                                     ⣿⡅⠘⣇⠀⠀⠀⣿⡘⠛⠉⠁⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⢈⡇⣿⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⢠⣃⡿⠀⠀⣿⠀");
        $display(
            "    ****************************     ⣿⢷⡀⢹⡄⠀⠀⢹⡇⠀⠀⣸⡆⠶⠄⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⡶⠃⠀⠀⠀⠀⠀⢸⣧⡇⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠘⣼⠃⠀⠀⢻⡄");
        $display(
            "    **                        **     ⣿⠈⣧⠈⢷⠀⠀⠈⣿⠀⠀⠈⠀⠀⠀⠀⢀⠀⠀⢀⣀⣤⠴⠖⢚⣩⠽⠋⠀⠀⠀⠀⠀⠀⠀⠀⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⣸⠀⣰⠏⠀⠀⠀⢼⡇");
        $display(
            "    **  Time Out !!           **     ⣿⠀⠘⣇⠘⣧⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠉⠛⠛⠷⠖⠒⠒⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⢁⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⢰⠟⠀⠀⠀⠀⣿⡄");
        $display(
            "    **                        **     ⣿⡄⠀⠘⣦⠘⣇⠀⠈⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⠾⠋⢀⣽⡇⠀⠀⠀⠀⠀⠀⠀⠀⢨⡷⠋⠀⠀⠀⠀⠀⣿⠀");
        $display(
            "    **  Simulation Failed !!  **     ⢸⣧⠀⠀⠘⢧⡘⢧⡀⠘⠻⠶⢤⣤⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⣀⣀⣠⣴⣾⠟⠋⢀⣠⠶⢻⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠃⠀⠀⠀⠀⠀⣰⡏⠀");
        $display(
            "    **                        **      ⢿⡆⠀⠀⡈⢳⣄⠱⣄⠀⠀⠀⠀⠀⣽⠉⠉⢉⣉⠙⢿⣉⠉⠻⣿⡿⠋⢀⣠⠖⠋⠁⠀⣾⠁⠀⠀⠀⠀⠀⠀⠀⠀⢰⡟⠀⠀⠀⠀⠀⣠⡟⠀⠀");
        $display(
            "    ****************************      ⠈⢿⡄⠐⣧⠀⠙⢦⡈⠀⠀⠀⠀⠀⢻⣆⠀⠀⠙⢦⣀⠉⠳⢤⣘⣧⠶⠋⠁⠀⠀⠀⣰⡿⠀⠀⠀⠀⠀⠀⠀⢀⣠⠿⠃⠀⠀⠀⢀⣴⠟⠁⠀⠀");
        $display(
            "                                       ⠈⢿⣄⢿⣧⡀⠀⠛⢦⣄⠀⠀⠀⢸⣿⣷⣄⡀⠀⠉⠳⠶⣶⠞⠁⠀⠀⠀⢀⣠⣾⣿⠀⠀⠀⠀⠀⠀⣠⣴⡏⠁⠀⠀⢀⣠⡴⠟⠁⠀⠀⠀⠀");
        $display(
            "                                         ⠻⣾⣿⣛⣦⣄⠀⠈⠛⠲⠦⣄⣿⡇⠈⠙⠛⠶⠶⢶⣿⠀⠀⠀⢀⣴⣿⣿⣿⣯⣀⣀⣤⣤⣶⣿⣿⣿⣿⡛⠛⠋⠉⠉⠀⠀⠀⠀⠀  ");
        $display(
            "                                      ⠀⠀⠀⠀⠀⠘⣻⣷⣄⣙⡛⠶⠦⣤⣤⣄⣸⣷⡄⠀⠀⠀⢠⠏⣻⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display("\n");
	end
    endtask
endmodule

