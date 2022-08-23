`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:        Tzu-Han Hsu
// Create Date:     2021/11/15 22:49:35
// Module Name:     RoundRobin
// Project Name:    TaskScheduler
// Description:     This module implements the Round Robin Task 
//                  Scheduling(RR) Algorithm. It's a combinational logic, which
//                  determines the execution of tasks under schdule under each clock cycle.
// 
// Dependencies:    None
//
//////////////////////////////////////////////////////////////////////////////////

`define rm0 store[0][19:16]
`define rm1 store[1][19:16]
`define rm2 store[2][19:16]
`define rm3 store[3][19:16]
`define rm4 store[4][19:16]

`define ti0 store[0][25:20]
`define ti1 store[1][25:20]
`define ti2 store[2][25:20]
`define ti3 store[3][25:20]
`define ti4 store[4][25:20]

module RoundRobin( input clk,
                   input rst,
                   input st,
                   input inputtask,
                   input [20-1:0] task_in,
                   output empty,
                   output reg [16-1:0] task_out
                  );
    
    integer i;
    reg [1:0] current_state,next_state;
    localparam [1:0] S_INIT = 0;
    localparam [1:0] S_PICK = 1;
    localparam [1:0] S_EXEC = 2;


    reg [6-1:0] timer;
    
    reg [26-1:0] store [5-1:0];

    //reg [2:0] lock_exec;
    reg [2:0] jei;//just executed task timer

    wire [6-1:0]jei_time;
    assign jei_time = store[jei][25:20];
    wire jei_is_latest;
    assign jei_is_latest =  (store[jei][25:20] >=`ti0 || `rm0 == 0)&&
                            (store[jei][25:20] >=`ti1 || `rm1 == 0)&&
                            (store[jei][25:20] >=`ti2 || `rm2 == 0)&&
                            (store[jei][25:20] >=`ti3 || `rm3 == 0)&&
                            (store[jei][25:20] >=`ti4 || `rm4 == 0);
    
    assign empty = (`rm0 == 0)&&(`rm1 == 0)&&(`rm2 == 0)&&(`rm3 == 0)&&(`rm4 == 0);

    wire db00,db01,db02,db03,db04;
    wire db10,db11,db12,db13,db14;
    wire db20,db21,db22,db23,db24;

    assign db00=(`rm0!=0 && `rm0!=1);
    assign db01=(`rm1!=0 && `rm1!=1);
    assign db02=(`rm2!=0 && `rm2!=1);
    assign db03=(`rm3!=0 && `rm3!=1);
    assign db04=(`rm4!=0 && `rm4!=1);
    // is the oldest
    assign il0 =  (jei_is_latest && ((`ti0 <`ti1||`ti1==0)&&(`ti0<`ti2||`ti2==0)&&(`ti0<`ti3||`ti3==0)&&(`ti0<`ti4||`ti4==0)));
    assign il1 =  (jei_is_latest && ((`ti1 <`ti0||`ti0==0)&&(`ti1<`ti2||`ti2==0)&&(`ti1<`ti3||`ti3==0)&&(`ti1<`ti4||`ti4==0)));
    assign il2 =  (jei_is_latest && ((`ti2 <`ti0||`ti0==0)&&(`ti2<`ti1||`ti1==0)&&(`ti2<`ti3||`ti3==0)&&(`ti2<`ti4||`ti4==0)));
    assign il3 =  (jei_is_latest && ((`ti3 <`ti0||`ti0==0)&&(`ti3<`ti1||`ti1==0)&&(`ti3<`ti2||`ti2==0)&&(`ti3<`ti4||`ti4==0)));
    assign il4 =  (jei_is_latest && ((`ti4 <`ti0||`ti0==0)&&(`ti4<`ti1||`ti1==0)&&(`ti4<`ti2||`ti2==0)&&(`ti4<`ti3||`ti3==0)));
    //larger than jei_is_latest and is the smallest among
    assign nl0 = (!jei_is_latest && (`ti0>jei_time) &&(`rm1 == 0||`ti1<=jei_time||`ti0 <`ti1)&&(`rm2 == 0||`ti2<=jei_time||`ti0 <`ti2)&&(`rm3 == 0||`ti3<=jei_time||`ti0 <`ti3)&&(`rm4 == 0||`ti4<=jei_time||`ti0 <`ti4) );
    assign nl1 = (!jei_is_latest && (`ti1>jei_time) &&(`rm0 == 0||`ti0<=jei_time||`ti1 <`ti0)&&(`rm2 == 0||`ti2<=jei_time||`ti1 <`ti2)&&(`rm3 == 0||`ti3<=jei_time||`ti1 <`ti3)&&(`rm4 == 0||`ti4<=jei_time||`ti1 <`ti4) );
    assign nl2 = (!jei_is_latest && (`ti2>jei_time) &&(`rm0 == 0||`ti0<=jei_time||`ti2 <`ti0)&&(`rm1 == 0||`ti1<=jei_time||`ti2 <`ti1)&&(`rm3 == 0||`ti3<=jei_time||`ti2 <`ti3)&&(`rm4 == 0||`ti4<=jei_time||`ti2 <`ti4) );
    assign nl3 = (!jei_is_latest && (`ti3>jei_time) &&(`rm0 == 0||`ti0<=jei_time||`ti3 <`ti0)&&(`rm1 == 0||`ti1<=jei_time||`ti3 <`ti1)&&(`rm2 == 0||`ti2<=jei_time||`ti3 <`ti2)&&(`rm4 == 0||`ti4<=jei_time||`ti3 <`ti4) );
    assign nl4 = (!jei_is_latest && (`ti4>jei_time) &&(`rm0 == 0||`ti0<=jei_time||`ti4 <`ti0)&&(`rm1 == 0||`ti1<=jei_time||`ti4 <`ti1)&&(`rm2 == 0||`ti2<=jei_time||`ti4 <`ti2)&&(`rm3 == 0||`ti3<=jei_time||`ti4 <`ti3) );


    always @(posedge clk ) begin
        if(rst)current_state <= S_INIT;
        else current_state <= next_state;
        
        case(current_state)
            S_INIT:begin
                timer<=0;
                //lock_exec <= 3'b111;
                jei <=0;
                for (i = 0; i<5; i=i+1) begin
                    store[i] <= 0;
                end
            end
                
            S_PICK:begin
                timer <= timer+1;
                //pull in new tasks
               if (inputtask) begin
                   if(`rm0 == 0) store[0] <= {timer,task_in};
                   else if(`rm1 == 0) store[1] <= {timer,task_in};
                   else if(`rm2 == 0) store[2] <= {timer,task_in};
                   else if(`rm3 == 0) store[3] <= {timer,task_in};
                   else if(`rm4 == 0) store[4] <= {timer,task_in};
               end
               else if(empty)begin
                    jei <=0;
                    for (i = 0; i<5; i=i+1) begin
                    store[i] <= 0;
                end
               end
                
                if((`rm0!=0 )&& (il0 || nl0))begin
                    `rm0 <= `rm0 - 1;
                    jei <= 0;   

                end
                else if((`rm1!=0)&& (il1 || nl1))begin//shall addd as above //todo

                    `rm1 <= `rm1 - 1;
                    jei <= 1;  

                end
                else if((`rm2!=0)&& (il2 ||nl2))begin
                    `rm2 <= `rm2 - 1;
                    jei <= 2;  

                end
                else if((`rm3!=0)&&(il3||nl3))begin

                    `rm3 <= `rm3 - 1;
                    jei <= 3;  
                end  
                else if((`rm4!=0)&&(il4||nl4))begin
                    `rm4 <= `rm4 - 1;
                    jei <= 4;  
                end 


            end

            S_EXEC:begin
                timer <= timer+1;
                //pull in new tasks
               if (inputtask) begin
                   if(`rm0 == 0) store[0] <= {timer,task_in};
                   else if(`rm1 == 0) store[1] <= {timer,task_in};
                   else if(`rm2 == 0) store[2] <= {timer,task_in};
                   else if(`rm3 == 0) store[3] <= {timer,task_in};
                   else if(`rm4 == 0) store[4] <= {timer,task_in};
               end

               store[jei][19:16] <= store[jei][19:16] - 1;

            end
        endcase
        
    end



    always @(*) begin
        case(current_state)
            S_INIT:next_state=(st)?S_PICK:S_INIT;

            S_PICK:begin
                if((`rm0!=0 && `rm0!=1)&&(il0||nl0))begin
                    next_state = S_EXEC; 

                end
                else if((`rm1!=0 && `rm1!=1)&&(il1||nl1))begin//shall addd as above //todo

                    next_state = S_EXEC; 

                end
                else if((`rm2!=0&&`rm2!=1)&&(il2||nl2))begin
                    next_state = S_EXEC; 

                end
                else if((`rm3!=0 && `rm3!=1)&&(il3||nl3))begin

                    next_state = S_EXEC; 
                end  
                else if((`rm4!=0&&`rm4!=1)&&(il4||nl4))begin
                    next_state = S_EXEC; 
                end 
                else next_state = S_PICK;

            end

            S_EXEC:next_state = S_PICK;

            default: next_state  = S_INIT;

        endcase
    end

    always @(*) begin
        task_out = 16'd65535;
        if(current_state == S_PICK)begin

            if((`rm0!=0 )&& (il0 || nl0))begin
                task_out = store[0][15:0];   
            end
            else if((`rm1!=0)&& (il1 || nl1))begin//shall addd as above //todo
                task_out = store[1][15:0];  
            end
            else if((`rm2!=0)&& (il2 ||nl2))begin
                task_out = store[2][15:0];  
            end
            else if((`rm3!=0)&&(il3||nl3))begin
                task_out = store[3][15:0];   
            end  
            else if((`rm4!=0)&&(il4||nl4))begin
                task_out = store[4][15:0];    
            end 
        end
        else if(current_state == S_EXEC)begin
            task_out = store[jei][15:0];
        end
        
    end

endmodule

