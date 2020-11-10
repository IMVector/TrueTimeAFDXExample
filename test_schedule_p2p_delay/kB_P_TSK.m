function [exectime, data] = kB_P_TSK(seg,data)

global gjit;
global Msg_kB;
% global frame_len;

% 当前时间（放大GCD_scale倍）
global GCD_scale;
now_time = int64(ttCurrentTime * GCD_scale);
switch_id = 2; % 端口号
switch seg
    case 1
        msg_vec = struct('vid',{},'bag',{},'pri',{},'lmax',{},'jit',{},'timestamp',{},'from',{},'deadline',{},'sort',{},'recvtime',{});
        for m = Msg_kB
            if mod(now_time, int64(m.bag * GCD_scale)) == 0
                m.timestamp = ttCurrentTime;
                m.from = 'kB';
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
            ttTryPost(['mbB' num2str(j)], m);
        end
        exectime = gjit;
    case 2
        m1 = ttTryFetch(['mbB' num2str(1)]);
        m2 = ttTryFetch(['mbB' num2str(2)]);
        
        if ~isempty(m1) && ~isempty(m2)
            ttSendMsg(switch_id, m1, m1.lmax);
            ttSendMsg(switch_id, m2, m2.lmax);
            exectime = m1.jit;
        else
            exectime = 0;
        end
        % ttCreateJob('kB_TSK_SND');
        % exectime = 0;
    case 3
        exectime = -1;
end
