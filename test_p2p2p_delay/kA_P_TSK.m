function [exectime, data] = kA_P_TSK(seg,data)

global gjit;
global Msg_kA;
% global frame_len;

% 当前时间（放大GCD_scale倍）
global GCD_scale;
now_time = int64(ttCurrentTime * GCD_scale);
%disp(['ttCurrentTime = ' num2str(ttCurrentTime)]);
%disp(['now_time = ' num2str(now_time)]);
% 交换机在同网络上的节点号
switch_id = 2;


switch seg
  case 1
    msg_vec = struct('vid',{},'bag',{},'pri',{},'lmax',{},'jit',{},'timestamp',{},'from',{},'deadline',{},'sort',{},'recvtime',{});
    for m = Msg_kA
        if mod(now_time, int64(m.bag * GCD_scale)) == 0
            m.timestamp = ttCurrentTime;
            m.from = 'kA';
            msg_vec(end + 1) = m;
        end
    end
    % 排序
    % msg_vec = MSG_SORT(msg_vec);
    % 有多少msg
    [~, msg_num] = size(msg_vec);
    % 发到对应的MailBox里去
    for j = 1:msg_num
        m = msg_vec(1, j);
        ttTryPost(['mbA' num2str(j)], m);
    end
    exectime = gjit;
 case 2
    m = ttTryFetch(['mbA' num2str(1)]);
    if ~isempty(m)
        ttSendMsg(switch_id, m, m.lmax);
        exectime = m.jit;
    else
        exectime = 0;
    end
 case 3
    m = ttTryFetch(['mbA' num2str(2)]);
    if ~isempty(m)
        ttSendMsg(switch_id, m, m.lmax);
        exectime = m.jit;
    else
        exectime = 0;
    end
 case 4
    m = ttTryFetch(['mbA' num2str(3)]);
    if ~isempty(m)
        ttSendMsg(switch_id, m, m.lmax);
        exectime = m.jit;
    else
        exectime = 0;
    end
 case 5
    m = ttTryFetch(['mbA' num2str(4)]);
    if ~isempty(m)
        ttSendMsg(switch_id, m, m.lmax);
        exectime = m.jit;
    else
        exectime = 0;
    end
 case 6
    m = ttTryFetch(['mbA' num2str(5)]);
    if ~isempty(m)
        ttSendMsg(switch_id, m, m.lmax);
        exectime = m.jit;
    else
        exectime = 0;
    end
 case 7
    m = ttTryFetch(['mbA' num2str(6)]);
    if ~isempty(m)
        ttSendMsg(switch_id, m, m.lmax);
        exectime = m.jit;
    else
        exectime = 0;
    end
 case 8
    exectime = -1;
end
