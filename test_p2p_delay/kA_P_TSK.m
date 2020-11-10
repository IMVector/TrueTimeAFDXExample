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
    m1 = ttTryFetch(['mbA' num2str(1)]);
    m2 = ttTryFetch(['mbA' num2str(2)]);
    if ~isempty(m1) && ~isempty(m2)
        ttSendMsg(switch_id, m1, m1.lmax);
        ttSendMsg(switch_id, m1, m1.lmax);
        ttSendMsg(switch_id, m1, m1.lmax);
        ttSendMsg(switch_id, m1, m1.lmax);
        ttSendMsg(switch_id, m1, m1.lmax);
        ttSendMsg(switch_id, m2, m2.lmax);
        ttSendMsg(switch_id, m2, m2.lmax);
        ttSendMsg(switch_id, m2, m2.lmax);
        ttSendMsg(switch_id, m1, m1.lmax);
        ttSendMsg(switch_id, m1, m1.lmax);
        exectime = m1.jit;
    else
        exectime = 0;
    end
 case 3
     exectime = -1;
end
