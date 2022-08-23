# Combinational Task Scheduling module

<img alt="GitHub License" src="https://img.shields.io/github/license/hankshyu/TaskScheduler?color=orange&logo=github"> <img alt="GitHub release (latest SemVer)" src="https://img.shields.io/github/v/release/hankshyu/TaskScheduler?color=orange&logo=github"> <img alt="GitHub language count" src="https://img.shields.io/github/languages/count/hankshyu/TaskScheduler"> <img alt="GitHub top language" src="https://img.shields.io/github/languages/top/hankshyu/TaskScheduler"> <img alt="GitHub code size in bytes" src="https://img.shields.io/github/languages/code-size/hankshyu/TaskScheduler"> <img alt="GitHub contributors" src="https://img.shields.io/github/contributors/hankshyu/TaskScheduler?logo=git&color=green"> <img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/y/hankshyu/TaskScheduler?logo=git&color=green">  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/hankshyu/TaskScheduler?logo=git&color=green">

### a hardware task scheduler design

## Scheduling Algorithm Module I/O ports

```
module Scheduling_Algorithm(  input clk,
                              input rst,
                              input st,
                              input inputtask,
                              input[20-1 : 0] task_in,
                              output empty,
                              output reg [16-1 : 0] task_out
);
```

|  I/O    | Signal name  | Signal definition
|----|:----|:---|
| input  | clk |clock signal|
| input  | rst |synchronous resert signal|
| input  | st  |signal to start the module
|input |inputtask| raised when there's a task comming into the scheduler
|output |empty | fired when no task under schedule
|output|task_out |output the scheduled task under current cycle


## 1.First-Come, First Served

*simplest scheduling algorithm*

- Task that request first gets allocated first
- Usually comes with a **long waiting time**
- May lead to **convoy effect** - all tasks wait for a big one to get off
- Illustration:

| |Arrival time|Burst time|Payload
|:---|:--:|:--:|:--:|
Task 1|0 |7| 16’d1|
Task 2|2 |4 |16’d2|
Task 3|4 |1 |16’d3|
Task 4|5 |4 |16’d4|

