function [exectime, data] = sA_TSK_SND(seg,data)

global sA_trigger;
global sA_msg_vec
global swA_map
global dt

global schedule_type;
global sA_v1_WRR_count;
global sA_v2_WRR_count;
global sA_v3_WRR_count;

switch seg
    case 1
        sA_trigger = false;
        if strcmp(schedule_type, 'WRR')
            % ��������㷨��WRR�㷨
            [sA_msg_vec,count_vec]=WRR(swA_map,sA_msg_vec,'sA','mbA',sA_v1_WRR_count,sA_v2_WRR_count,sA_v3_WRR_count,0,0);
            % �޸ĵ���ʣ���count
            sA_v1_WRR_count = count_vec(1);
            sA_v2_WRR_count = count_vec(2);
            sA_v3_WRR_count = count_vec(3);
            
        else
            %��������㷨�������㷨
            
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
        end
        
        % �ȼ��ǿ�
        sz = size(sA_msg_vec);
        if sz(1, 2) == 0
            exectime = -1;
        else
            % �鲢����
            sA_msg_vec = Merge_Sort(sA_msg_vec);
            % ȡ��һ��Ԫ�أ����ͳ�ȥ
            msg = sA_msg_vec(1, 1);
            ttSendMsg(swA_map(msg.vid), msg, msg.lmax);
            % ɾ���Ѿ����͵�Ԫ��
            sA_msg_vec = sA_msg_vec(2 : end);
            % ִ��ʱ��
            exectime = dt;
        end
    case 2
        % �������ǿգ�������Ҫ���͵�Msg������һ��Job�з���
        sz = size(sA_msg_vec);
        if sz(1, 2) > 0
            ttCreateJob('sA_TSK_SND');
        end
        exectime = -1;
end

