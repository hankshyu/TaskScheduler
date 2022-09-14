`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:        Tzu-Han Hsu, Eric Chun-Yu
// Create Date:     2021/11/15 22:49:35
// Module Name:     SJF
// Project Name:    TaskScheduler
// Description:     This module implements the Shortest Job First Task 
//                  Scheduling(SJF) Algorithm. It's a combinational logic, which
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

module SJF( input clk,
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
    reg [2:0] lock_exec;

    assign empty = (`rm0 == 0)&&(`rm1 == 0)&&(`rm2 == 0)&&(`rm3 == 0)&&(`rm4 == 0);

    always @(posedge clk ) begin
        if(rst)current_state <= S_INIT;
        else current_state <= next_state;
        
        case(current_state)
            S_INIT:begin
                timer<=0;
                lock_exec <= 0;
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
                
                if((`rm0!=0) &&((`rm0<=`rm1)||`rm1==0)&&((`rm0<=`rm2)||`rm2==0)&&((`rm0<=`rm3)||`rm3==0)&&((`rm0<=`rm4)||`rm4==0))begin
                    `rm0 <= `rm0 - 1;
                    lock_exec <= 0;                   
                end
                else if((`rm1!=0) &&((`rm1<=`rm0)||`rm0==0)&&((`rm1<=`rm2)||`rm2==0)&&((`rm1<=`rm3)||`rm3==0)&&((`rm1<=`rm4)||`rm4==0))begin                    
                    `rm1 <= `rm1 - 1;
                    lock_exec <= 1;
                end
                else if((`rm2!=0) &&((`rm2 <= `rm0)||`rm0==0)&&((`rm2 <= `rm1)||`rm1==0)&&((`rm2 <= `rm3)||`rm3==0)&&((`rm2 <= `rm4)||`rm4==0))begin                    
                    `rm2 <= `rm2 - 1;
                    lock_exec <= 2;
                end
                else if((`rm3!=0) &&((`rm3 <= `rm0)||`rm0==0)&&((`rm3 <= `rm1)||`rm1==0)&&((`rm3 <= `rm2)||`rm2==0)&&((`rm3 <= `rm4)||`rm4==0))begin              
                    `rm3 <= `rm3 - 1;
                    lock_exec <= 3;
                end
                else if((`rm4!=0) &&((`rm4 <= `rm0)||`rm0==0)&&((`rm4 <= `rm1)||`rm1==0)&&((`rm4 <= `rm2)||`rm2==0)&&((`rm4 <= `rm3)||`rm3==0))begin
                    `rm4 <= `rm4 -1; 
                    lock_exec <= 4;  
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

               store[lock_exec][19:16] <= store[lock_exec][19:16] - 1;

            end
        endcase
        
    end

    always @(*) begin
        case(current_state)
            S_INIT:next_state=(st)?S_PICK:S_INIT;

            S_PICK:begin
                if(((`rm0!=0) && (`rm0!=1)) &&((`rm0<=`rm1)||`rm1==0)&&((`rm0<=`rm2)||`rm2==0)&&((`rm0<=`rm3)||`rm3==0)&&((`rm0<=`rm4)||`rm4==0))begin
                    next_state = S_EXEC;
                end
                else if(((`rm1!=0) && (`rm1!=1)) &&((`rm1<=`rm0)||`rm0==0)&&((`rm1<=`rm2)||`rm2==0)&&((`rm1<=`rm3)||`rm3==0)&&((`rm1<=`rm4)||`rm4==0))begin                    
                    next_state = S_EXEC;

                end
                else if(((`rm2!=0) && (`rm2!=1)) &&((`rm2 <= `rm0)||`rm0==0)&&((`rm2 <= `rm1)||`rm1==0)&&((`rm2 <= `rm3)||`rm3==0)&&((`rm2 <= `rm4)||`rm4==0))begin                    
                    next_state = S_EXEC;

                end
                else if(((`rm3!=0) && (`rm3!=1)) &&((`rm3 <= `rm0)||`rm0==0)&&((`rm3 <= `rm1)||`rm1==0)&&((`rm3 <= `rm2)||`rm2==0)&&((`rm3 <= `rm4)||`rm4==0))begin              
                    next_state = S_EXEC;

                end
                else if(((`rm4!=0) && (`rm4!=1)) &&((`rm4 <= `rm0)||`rm0==0)&&((`rm4 <= `rm1)||`rm1==0)&&((`rm4 <= `rm2)||`rm2==0)&&((`rm4 <= `rm3)||`rm3==0))begin
                    next_state = S_EXEC;

                end 
                else next_state = S_PICK;

            end

            S_EXEC:next_state = (store[lock_exec][19:16] == 1)?S_PICK:S_EXEC;

            default: next_state  = S_INIT;

        endcase
    end

    always @(*) begin
        task_out = 16'd65535;
        if(current_state == S_PICK)begin
            if((`rm0!=0) &&((`rm0<=`rm1)||`rm1==0)&&((`rm0<=`rm2)||`rm2==0)&&((`rm0<=`rm3)||`rm3==0)&&((`rm0<=`rm4)||`rm4==0))
                task_out = store[0][15:0];
            else if((`rm1!=0) &&((`rm1 <=`rm0)||`rm0==0)&&((`rm1<=`rm2)||`rm2==0)&&((`rm1<=`rm3)||`rm3==0)&&((`rm1<=`rm4)||`rm4==0))
                task_out = store[1][15:0];
            else if((`rm2!=0) &&((`rm2 <= `rm0)||`rm0==0)&&((`rm2 <= `rm1)||`rm1==0)&&((`rm2 <= `rm3)||`rm3==0)&&((`rm2 <= `rm4)||`rm4==0))
                task_out = store[2][15:0];
            else if((`rm3!=0) &&((`rm3 <= `rm0)||`rm0==0)&&((`rm3 <= `rm1)||`rm1==0)&&((`rm3 <= `rm2)||`rm2==0)&&((`rm3 <= `rm4)||`rm4==0))
                task_out = store[3][15:0];
            else if((`rm4!=0) &&((`rm4 <= `rm0)||`rm0==0)&&((`rm4 <= `rm1)||`rm1==0)&&((`rm4 <= `rm2)||`rm2==0)&&((`rm4 <= `rm3)||`rm3==0))
                task_out = store[4][15:0];
        end
        else if(current_state == S_EXEC)begin
            task_out = store[lock_exec][15:0];
        end
    end

endmodule

