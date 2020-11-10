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
    % 对于每个VL
    for i = 1:c
        vid = cell2mat(mp_keys(1, i)); % VL id
        mbName = ['mbB' num2str(vid)]; % 该VL的MailBox的Name
        while true
            msg = ttTryFetch(mbName);
            if isempty(msg)
                break
            end
            % 计算排序字段
              msg.sort = Cal_Sort_Field(msg);
              sB_msg_vec(end + 1) = msg;
        end
    end
    % 先检查非空
    sz = size(sB_msg_vec);
    if sz(1, 2) == 0
        exectime = -1;
    else
        % 归并排序
        sB_msg_vec = Merge_Sort(sB_msg_vec);
        % 取第一个元素，发送出去
        msg = sB_msg_vec(1, 1); 
        ttSendMsg(swB_map(msg.vid), msg, msg.lmax);
        % 删除已经发送的元素
        sB_msg_vec = sB_msg_vec(2 : end);
        % 执行时间
        exectime = dt;
    exectime=0;
    end
  case 2
    % 检查数组非空，则还有需要发送的Msg，在下一个Job中发送
    sz = size(sB_msg_vec);
    if sz(1, 2) > 0
        ttCreateJob('sB_TSK_SND');
    end
    exectime = -1;
end

