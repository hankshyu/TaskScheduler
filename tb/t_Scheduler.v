`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:        Tzu-Han Hsu
// Create Date:     2021/11/16 21:06:06
// Module Name:     t_Scheduler
// Project Name:    TaskScheduler
// Description:     This is the testbench program of the TaskScheduler Program.
//                  It instatniates 4 scheduling algorithm modules and test them with
//                  4 distinct tests simultaneously
// 
// Dependencies:    FCFS.v
//                  RoundRobin.v
//                  SJF.v
//                  SRJF.v
//
//////////////////////////////////////////////////////////////////////////////////


module t_Scheduler;

    reg clk,rst,st,inputtask;
    reg [20-1:0] task_in;

    //signals for FCFS
    wire FCFS_empty;
    wire [16-1:0] FCFS_task_out;
    //signals for SRJF
    wire SRJF_empty;
    wire[16-1:0] SRJF_task_out;

    //signals for SJF
    wire SJF_empty;
    wire[16-1:0] SJF_task_out;

    //signals for RR
    wire RR_emtpy;
    wire [16-1:0]RR_task_out;


    
    FCFS fcfs_uut(
        .clk(clk),
        .rst(rst),
        .st(st),
        .inputtask(inputtask),
        .task_in(task_in),
        .empty(FCFS_empty),
        .task_out(FCFS_task_out)
    );

    SRJF srjf_uut(
        .clk(clk),
        .rst(rst),
        .st(st),
        .inputtask(inputtask),
        .task_in(task_in),
        .empty(SRJF_empty),
        .task_out(SRJF_task_out)
    );

    SJF sjf_uut(
        .clk(clk),
        .rst(rst),
        .st(st),
        .inputtask(inputtask),
        .task_in(task_in),
        .empty(SJF_empty),
        .task_out(SJF_task_out)
    );

    RoundRobin rr_uut(
        .clk(clk),
        .rst(rst),
        .st(st),
        .inputtask(inputtask),
        .task_in(task_in),
        .empty(RR_emtpy),
        .task_out(RR_task_out)
    );
    
    integer i;
    reg [5:0] out_timer;
    
    initial begin
        clk  =0;
        forever #5 clk = ~clk;
    end
    initial begin
        
        @(posedge st)
        out_timer = 0;
        forever begin
            @(posedge clk)
            out_timer = out_timer +1;
        end
    end

    initial begin
        
        rst =1;
        st =0;
        inputtask =0;
        #20
        rst =0;
        #5 st = 1;
        @(posedge clk)
        @(negedge clk)
        st = 0;

        // testing data 1:
        // task1: {time_in:0, length:7}
        @(posedge clk) 
        inputtask = 1;
        task_in = {4'd7,16'd1};
        @(negedge clk)
        inputtask = 0;

        // task2: {time_in:2, length:4}
        for (i = 0; i<2; i=i+1) @(posedge clk);
        inputtask = 1;
        task_in = {4'd4,16'd2};
        @(negedge clk)
        inputtask = 0;
        
        // task3: {time_in:4, length:1}
        for (i = 0; i<2; i=i+1) @(posedge clk);
        inputtask = 1;
        task_in = {4'd1,16'd3};
        @(negedge clk)
        inputtask = 0;
        
        // task3: {time_in:5, length:4}
        for (i = 0; i<1; i=i+1) @(posedge clk);
        inputtask = 1;
        task_in = {4'd4,16'd4};
        @(negedge clk)
        inputtask = 0;

        
        for (i = 0; i<15; i=i+1) @(posedge clk);
        // testing data 2

        // task1: {time_in:0, length:3}        
        inputtask = 1;
        task_in = {4'd3,16'd5};
        @(negedge clk)
        inputtask = 0;

        // task2: {time_in:1, length:2} 
        for (i = 0; i<1; i=i+1) @(posedge clk);
        inputtask = 1;
        task_in = {4'd2,16'd6};
        @(negedge clk)
        inputtask = 0;

        // task3: {time_in:2, length:3} 
        for (i = 0; i<1; i=i+1) @(posedge clk);
        inputtask = 1;
        task_in = {4'd3,16'd7};
        @(negedge clk)
        inputtask = 0;

        // task4: {time_in:6, length:2}
        for (i = 0; i<4; i=i+1) @(posedge clk);
        inputtask = 1;
        task_in = {4'd2,16'd8};
        @(negedge clk)
        inputtask = 0;

        // task5: {time_in:8, length:3}
        for (i = 0; i<1; i=i+1) @(posedge clk);
        inputtask = 1;
        task_in = {4'd3,16'd9};
        @(negedge clk)
        inputtask = 0;

        // task5: {time_in:10, length:2}
        for (i = 0; i<2; i=i+1) @(posedge clk);
        inputtask = 1;
        task_in = {4'd2,16'd10};
        @(negedge clk)
        inputtask = 0;


        for (i = 0; i<15; i=i+1) @(posedge clk);
        // testing data 3

        // task1: {time_in:0, length:4}        
        inputtask = 1;
        task_in = {4'd4,16'd11};
        @(negedge clk)
        inputtask = 0;

        // task2: {time_in:1, length:2} 
        for (i = 0; i<1; i=i+1) @(posedge clk);
        inputtask = 1;
        task_in = {4'd2,16'd12};
        @(negedge clk)
        inputtask = 0;

        // task2: {time_in:2, length:1} 
        for (i = 0; i<1; i=i+1) @(posedge clk);
        inputtask = 1;
        task_in = {4'd1,16'd13};
        @(negedge clk)
        inputtask = 0;
        
        // task2: {time_in:3, length:1} 
        for (i = 0; i<1; i=i+1) @(posedge clk);
        inputtask = 1;
        task_in = {4'd1,16'd14};
        @(negedge clk)
        inputtask = 0;

        // task2: {time_in:4, length:2} 
        for (i = 0; i<1; i=i+1) @(posedge clk);
        inputtask = 1;
        task_in = {4'd2,16'd15};
        @(negedge clk)
        inputtask = 0;

    end

endmodule
