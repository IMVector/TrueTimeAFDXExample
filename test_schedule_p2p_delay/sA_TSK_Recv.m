function [exectime, data] = sA_TSK_Recv(seg,data)

global sA_trigger;
% global last_sA_rcv_time;
switch seg
    case 1
        % ����Ҫ��ȡ�������
        netin_id_list = [1,2];
        [~, c] = size(netin_id_list);
        for j = 1:c
            netin_id = netin_id_list(1, j);
            msg = ttGetMsg(netin_id);
            disp("��ǰ���յ��������"+netin_id);
            if ~isempty(msg)
                msg.recvtime = ttCurrentTime;
                disp("���յ�һ����Ϣ��ʱ����"+ttCurrentTime);
                ttTryPost(['mbA' num2str(msg.vid)], msg);
                ttCreateJob('sA_TSK_Recv');
            end
        end
        exectime = 0;
    case 2
        
        if sA_trigger == false
            sA_trigger = true;
            ttCreateJob('sA_TSK_SND');
        end
        exectime = -1;
end
end
