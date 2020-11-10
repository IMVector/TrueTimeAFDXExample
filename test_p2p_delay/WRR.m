function [msg_vec,count] = WRR(sw_map,msg_vec,sw_name,mb_name,wrr_count1,wrr_count2,wrr_count3,wrr_count4,wrr_count5)

% TODO：处理当其余队列没有元素时，一个队列一直等待的情况

% 根据不同的交换机配置不同的调度的优先级初始值
% 每个虚拟链路对应队列的原始计数值数组
switch sw_name
    case "sA"
        ori_count=[4,2,1];
    case "sB"
        ori_count=[1,2];
    case "sC"
        ori_count=[1,3,4,4,2];
    case "sD"
        ori_count=[1,2,1,3,3];
    case "sE"
        ori_count=[1,2,1,3,3];
end


mp_keys = sw_map.keys();
% 队列的数量
c = length(mp_keys);
% 是否结束循环的标志
flag = true;
% 查看某个队列是否为空的标志
vl_flag = [true,true,true,true,true];
% 每个虚拟链路对应队列的计数值数组
count = [wrr_count1,wrr_count2,wrr_count3,wrr_count4,wrr_count5];
% 每个虚拟链路对应队列的原始计数值数组
% TODO:
% ori_count=[1,2,3,4,5];

while true
    for i = 1:c
        vid = cell2mat(mp_keys(1, i)); % VL id
        mbName = [mb_name num2str(vid)]; % 对于每个队列
        % 有剩余的count，可以进行调度
        if count(i) > 0 && sum(count) > 0
            msg = ttTryFetch(mbName);
            % 队列内容是空时
            if isempty(msg)
                vl_flag(i) = false; % 设置当前队列内容标志是空
                flag = false; % 先设置是否还有未调度队列标志设置为false
                for j = 1:c
                    if vl_flag(j) == true %如果有某个队列中还有内容
                        flag = true; % 是否还有未调度队列标志设置为true
                    end
                end
                continue;
            end
            % 将该计数器减1
            % 先入先出调度，设置msg.recvtime = ttCurrentTime;
            % 由于是稳定的排序算法，所以先放进去的是会被先调度
            count(i) = count(i) -1;
            msg.recvtime = ttCurrentTime;
            msg.sort = Cal_Sort_Field(msg);
            msg_vec(end + 1) = msg;
            
        elseif count(i) == 0 && sum(count) > 0
            % 如果当前的队列的计数count==0,
            % 跳过该队列
            
            flag_is_empty = false;
            %判断是否有队列为空，如果有为空的队列
            for j =1:c
                if j ~= i && vl_flag(j) == true
                    flag_is_empty = true;
                end
            end
            
            % 如果其余所有的虚拟链路的队列都是空的，只有当前队列有元素，并且count==0了
            % 此时如果不进行计数器还原，会出现死循环，计数器还原，继续调度。
            if flag_is_empty == false
                % 计数器还原，回到初始值继续调度
                for j = 1:c
                    count(j) = ori_count(j);
                end
            end
            continue;
            
        elseif count(i) == 0 && sum(count) == 0 % WRR算法当所有的
            % 计数器还原，回到初始值继续调度
            for j = 1:c
                count(j) = ori_count(j);
            end
        end
        
    end
    if flag == false % 所有的队列中的内容都被调度，结束当前调度过程
        break;
    end
end

end
    % 根据schedule_type修改取队列的方式
    % flag = true;
    
    % wile(true)
    
    % for 每个队列
        % 如果不为空
            % 如果该虚拟链路的计数器不为0 并且（不是所有的计数器都是0）
                % 将该计数器减1
                % 先入先出调度，设置msg.recvtime =
                % ttCurrentTime; 由于是稳定的排序算法，所以先放进去的是会被先调度
            % 如果该虚拟链路的计数器为0 并且 (不是所有的计数器都是0)
                % 跳过该队列
            % 如果该虚拟链路的计数器为0 并且 (所有的计数器都是0)
                % 计数器还原，回到初始值继续调度
        %else 
            % flags[i]=false;
            % flag=false;
            % for 每个队列
                % if flags[i] == true;
                   % flag = true;
            % continue
    % if !flag
        % break
        
