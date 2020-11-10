function [exectime, data] = sA_TSK_SND(seg,data)

global sA_trigger;
global sA_msg_vec
global swA_map
global dt

global schedule_type;
global sA_v1_WRR_count;
global sA_v2_WRR_count;
global sA_v3_WRR_count;
global sA_v4_WRR_count;

switch seg
    case 1
        sA_trigger = false;
        if strcmp(schedule_type, 'WRR')
            % 如果调度算法是WRR算法
            [sA_msg_vec,count_vec]=WRR(swA_map,sA_msg_vec,'sA','mbA',sA_v1_WRR_count,sA_v2_WRR_count,sA_v3_WRR_count,sA_v4_WRR_count,0);
            % 修改调度剩余的count
            disp(count_vec);
            sA_v1_WRR_count = count_vec(1);
            sA_v2_WRR_count = count_vec(2);
            sA_v3_WRR_count = count_vec(3);            
            sA_v4_WRR_count = count_vec(4);
            
        else
            %如果调度算法是其他算法
            mp_keys = swA_map.keys();
            [~, c] = size(mp_keys);
            % 对于每个VL
            for i = 1:c
                vid = cell2mat(mp_keys(1, i)); % VL id
                mbName = ['mbA' num2str(vid)]; % 该VL的MailBox的Name
                while true
                    msg = ttTryFetch(mbName);
                    if isempty(msg)
                        break
                    end
                    % 计算排序字段
                    msg.sort = Cal_Sort_Field(msg);
                    sA_msg_vec(end + 1) = msg;
                end
            end
        end
        
        % 先检查非空
        sz = size(sA_msg_vec);
        disp("队列中元素的数量"+length(sA_msg_vec));
        
        if sz(1, 2) == 0
            exectime = -1;
        else
            % 归并排序
            sA_msg_vec = Merge_Sort(sA_msg_vec);
            % 取第一个元素，发送出去
            msg = sA_msg_vec(1, 1);
            ttSendMsg(swA_map(msg.vid), msg, msg.lmax);
            % 删除已经发送的元素
            sA_msg_vec = sA_msg_vec(2 : end);
            % 执行时间
            exectime = dt;
        end
    case 2
        % 此处应排列到队列尾部才可以，否则调度将不正确
        
        % 检查数组非空，则还有需要发送的Msg，在下一个Job中发送
        sz = size(sA_msg_vec);
        if sz(1, 2) > 0
            ttCreateJob('sA_TSK_SND');
        end
        exectime = -1;
end

