global BAG;

global sw_delay; % 交换机处理时间
global recv_delay; % 接收端处理时间
global frame_len; % 帧的统一长度
global sw_buflen; % 交换机队列长度
% 每个交换机能处理的vid -> 下一跳
global swA_map;
global swB_map;
% --------------------------------------------------------------
% 调度算法
global schedule_type;
schedule_type = 'SP';

% 全局调度间隔时间
global dt;
dt = 0;

% 全局的jitter
global gjit;
gjit =0;

% --------------------------------------------------------------
% VL的最大数量（Virtual Link Upper Bound）
global VL_UB;
VL_UB = 6;
% MailBox的队列长度
global mb_buflen;
mb_buflen = 80;
% 求GCD时的精度倍数，用来将BAG变成整数以计算GCD
global GCD_scale;
% 求GCD时的精度倍数
GCD_scale = 100000;

% --------------------------------------------------------------

BAG = 0.06;

sw_delay = 0;
recv_delay = 0;
frame_len = 80;
sw_buflen = 2147483647; % （数值是）intmax   交换机mailbox的缓冲区队列长度

% 每个交换机能处理的vid -> 下一跳
swA_map = containers.Map({1,2},{[2 1],[2 1]});
swB_map = containers.Map({1,2},{[3 1],[3 1]});


% -----------------------------【kA】-----------------------------

% 发送端系统待发送的消息
global Msg_kA;
% 端系统的BAG的GCD
global GCD_kA;
BAG_vec = [0.06 0.06];
vid_vec = [1 2];
deadline_vec = [0.12 0.23];
Msg_kA = struct('vid',{},'bag',{},'pri',{},'lmax',{},'jit',{},'deadline',{},'sort',{},'recvtime',{});
[~, c] = size(vid_vec);
for j = 1:c
    msg.vid = vid_vec(1, j);
    msg.bag = BAG_vec(1, j);
    msg.pri = j;
    msg.lmax = 128;
    msg.jit = 0.001;
    msg.deadline = deadline_vec(1, j);
    msg.sort = 0;
    msg.recvtime = 0;
    Msg_kA(end + 1) = msg;
end
% 求kA的BAG的GCD
g = BAG_vec(1, 1) * GCD_scale;
for j = 2:c
    g = gcd(g, BAG_vec(1, j) * GCD_scale);
end
GCD_kA = g / GCD_scale;

% ---------------------交换机（接收）触发器---------------------
global sA_trigger;
global sB_trigger;
sA_trigger = false;
sB_trigger = false;
%----------------全局端到端延时计算数据保存数组----------------
global v1_delay_array;
global v2_delay_array;

v1_delay_array=struct('delay',{},'curTime',{},'from',{},'destination',{});
v2_delay_array=struct('delay',{},'curTime',{},'from',{},'destination',{});

global sim_end_time;%仿真结束的大致时间，文件记录时要根据仿真时间设置
global file_flag_kC;%文件写入标志，写入前是false，写入后是true
file_flag_kC=false;


sim_end_time=9.90;%仿真结束的大致时间，文件记录时要根据仿真时间设置

%----------------为每个flow设置优先级----------------
Msg_kA(1).pri=3; %v1
Msg_kA(2).pri=2; %v2

%----------------为每个flow设置BAG----------------
Msg_kA(1).bag=10; %v1
Msg_kA(2).bag=0.3; %v2

%----------------为每个flow设置Lmax----------------
Msg_kA(1).lmax = 1024*8; %v1
Msg_kA(2).lmax = 128*8; %v2

%----------------为每个flow设置jitter----------------
Msg_kA(1).jit=0; %v1
Msg_kA(2).jit=0; %v2

% --------------每个交换机的Msg数组--------------
% vid 虚拟链路ID
% bag 虚拟链路BAG
% pri 虚拟链路优先级
% lmax 虚拟链路最大帧长度
% jit 虚拟链路抖动(jitter）
% timestamp 发送时间戳
% from 发送端系统标识（字符串）
% deadline EDF算法下允许的最大结束时间
% sort 排序字段（不同调度算法生成方式不同）
% recvtime 交换机接收到该msg的时间戳
global sA_msg_vec;
sA_msg_vec = struct('vid',{},'bag',{},'pri',{},'lmax',{},'jit',{},'timestamp',{},'from',{},'deadline',{},'sort',{},'recvtime',{});
global sB_msg_vec;
sB_msg_vec = struct('vid',{},'bag',{},'pri',{},'lmax',{},'jit',{},'timestamp',{},'from',{},'deadline',{},'sort',{},'recvtime',{});

