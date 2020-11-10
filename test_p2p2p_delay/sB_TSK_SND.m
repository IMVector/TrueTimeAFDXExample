function [exectime, data] = sB_TSK_SND(seg,data)

global sB_trigger;
global sB_msg_vec
global swB_map
global dt

switch seg
  case 1
    sB_trigger = false;
    mp_keys = swB_map.keys();
    [~, c] = size(mp_keys);
    % ����ÿ��VL
    for i = 1:c
        vid = cell2mat(mp_keys(1, i)); % VL id
        mbName = ['mbB' num2str(vid)]; % ��VL��MailBox��Name
        while true
            msg = ttTryFetch(mbName);
            if isempty(msg)
                break
            end
            % ���������ֶ�
              msg.sort = Cal_Sort_Field(msg);
              sB_msg_vec(end + 1) = msg;
        end
    end
    % �ȼ��ǿ�
    sz = size(sB_msg_vec);
    if sz(1, 2) == 0
        exectime = -1;
    else
        % �鲢����
        sB_msg_vec = Merge_Sort(sB_msg_vec);
        % ȡ��һ��Ԫ�أ����ͳ�ȥ
        msg = sB_msg_vec(1, 1); 
        ttSendMsg(swB_map(msg.vid), msg, msg.lmax);
        % ɾ���Ѿ����͵�Ԫ��
        sB_msg_vec = sB_msg_vec(2 : end);
        % ִ��ʱ��
        exectime = dt;
    exectime=0;
    end
  case 2
    % �������ǿգ�������Ҫ���͵�Msg������һ��Job�з���
    sz = size(sB_msg_vec);
    if sz(1, 2) > 0
        ttCreateJob('sB_TSK_SND');
    end
    exectime = -1;
end

