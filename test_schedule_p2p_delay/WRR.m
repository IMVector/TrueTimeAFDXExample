function [msg_vec,count] = WRR(sw_map,msg_vec,sw_name,mb_name,wrr_count1,wrr_count2,wrr_count3,wrr_count4,wrr_count5)
% TODO：处理当其余队列没有元素时，一个队列一直等待的情况

% 根据不同的交换机配置不同的调度的优先级初始值
% 每个虚拟链路对应队列的原始计数值数组
breakflag=1;
switch sw_name
    case "sA"
        ori_count=[1,1,4,2];
end
mp_keys = sw_map.keys();
% 队列的数量
c = length(mp_keys);
% 是否结束循环的标志
flag = true;
% 查看某个队列是否为空的标志
vl_flag = [true,true,true,true,true];
re_flag = [true,true,true,true,true];
% 每个虚拟链路对应队列的计数值数组
count = [wrr_count1,wrr_count2,wrr_count3,wrr_count4,wrr_count5];

left_count = [0,0,0,0,0]; %每个队列剩余的元素数量
temp_name = [mb_name '_temp']; %临时队列的名字

% 倒腾一遍，统计每个队列的元素数量
for i = 1:c
    vid = cell2mat(mp_keys(1, i)); % VL id
    mbName = [mb_name num2str(vid)]; % 对于每个队列
    while true
        msg = ttTryFetch(mbName);
        if isempty(msg)
            break;
        else
            left_count(i) = left_count(i)+1;
            ttTryPost([temp_name num2str(vid)], msg);
        end
    end
end
% -------------------------倒腾结束------------------------

while true
    breakflag = breakflag+1;
    for i = 1:c
        vid = cell2mat(mp_keys(1, i)); % VL id
        mbName = [temp_name num2str(vid)]; % 对于每个队列
        if left_count(i) == 0 %如果当前队列没有内容
            vl_flag(i) = false;
            re_flag(i) = false;
            continue;
        else
            
            if count(i) > 0 && sum(count) > 0
                msg = ttTryFetch(mbName);
                % 队列内容是空时
                if isempty(msg)
                    re_flag(i) = false; % 设置当前队列内容标志是空
                    vl_flag(i) = false;
                    
                    continue;
                end
                % 将该计数器减1
                % 先入先出调度，设置msg.recvtime = ttCurrentTime;
                % 由于是稳定的排序算法，所以先放进去的是会被先调度
                left_count(i) = left_count(i)-1;
                count(i) = count(i) -1;
                disp("当前调度的虚拟链路是"+i)
                msg.recvtime = ttCurrentTime;
                msg.sort = Cal_Sort_Field(msg);
                msg_vec(end + 1) = msg;
                
            elseif count(i) == 0 && sum(count) > 0
                % 这里存在bug，如果有两个队列都是0
                % 对其置false，否则同时到达的多个队列会出问题
                % ----------------------------------------------
                % 解决上述bug
                if count(i) == 0
                    re_flag(i) = false;
                end
                % 出现了新的bug，本次调度可能没有完成，会积攒到下一轮，这样就不正确了
                % ----------------------------------------------
                % 如果当前的队列的计数count==0,
                % 跳过该队列
                flag_is_empty = false;
                %判断是否有队列不为空，如果有不为空的队列
                for j =1:c
                    if j ~= i && re_flag(j) == true
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
    end
    flag = false; % 先设置是否还有未调度队列标志设置为false
    for j = 1:c
        if vl_flag(j) == true %如果有某个队列中还有内容
            flag = true; % 是否还有未调度队列标志设置为true,继续循环，否则跳出while
        end
    end
    if flag == false % 所有的队列中的内容都被调度，结束当前调度过程
        break;
    end
    if breakflag>100
        disp("----------错误----------")
        break;
    end
end

end


