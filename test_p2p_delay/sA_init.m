function sA_init

% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority

% 创建MailBox
global sw_buflen;
global swA_map;

mp_keys = swA_map.keys();
[~, c] = size(mp_keys);
for i = 1:c
  vid = cell2mat(mp_keys(1, i));
  ttCreateMailbox(['mbA' num2str(vid)], sw_buflen);
end

recv_task = 'sA_TSK_Recv';
send_task = 'sA_TSK_SND';

ttCreateTask(recv_task, 1, recv_task);
ttCreateTask(send_task, 1, send_task);

ttSetPriority(1, recv_task);
% 调度的优先级比Recv优先级低（调度在接收之后）
ttSetPriority(2, send_task);

% 所有接收信息的网络号
ttAttachNetworkHandler(1, recv_task);
% ttAttachNetworkHandler(2, recv_task);

% ttCreateMailbox('mbA_Send', sw_buflen);
