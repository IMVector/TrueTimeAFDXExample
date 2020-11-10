function [exectime, data] = sA_TSK_SND(seg,data)

global sA_trigger;
global sA_msg_vec
global swA_map
global dt

switch seg
  case 1
    sA_trigger = false;
    mp_keys = swA_map.keys();
    [~, c] = size(mp_keys);
    % ����ÿ��VL
    for i = 1:c
        vid = cell2mat(mp_keys(1, i)); % VL id
        mbName = ['mbA' num2str(vid)]; % ��VL��MailBox��Name
        while true
            msg = ttTryFetch(mbName);
            if isempty(msg)
                break
            end
            % ���������ֶ�
              msg.sort = Cal_Sort_Field(msg);
              sA_msg_vec(end + 1) = msg;
        end
    end

   
    % �ȼ��ǿ�
    sz = size(sA_msg_vec);
    if sz(1, 2) == 0
        exectime = -1;
    else
        disp("ǰ================");
        for m = sA_msg_vec
            disp(m.vid);
        end
        disp("================");
        % �鲢����
        sA_msg_vec = Merge_Sort(sA_msg_vec);
        disp("��================");
        for m = sA_msg_vec
            disp(m.vid);
        end
        disp("================");
        % ȡ��һ��Ԫ�أ����ͳ�ȥ
        msg = sA_msg_vec(1, 1); 
        ttSendMsg(swA_map(msg.vid), msg, msg.lmax);
        % ɾ���Ѿ����͵�Ԫ��
        sA_msg_vec = sA_msg_vec(2 : end);
        % ִ��ʱ��
        exectime = dt;
    exectime=0;
    end
  case 2
    % �������ǿգ�������Ҫ���͵�Msg������һ��Job�з���
    sz = size(sA_msg_vec);
    if sz(1, 2) > 0
        ttCreateJob('sA_TSK_SND');
    end
    exectime = -1;
end

