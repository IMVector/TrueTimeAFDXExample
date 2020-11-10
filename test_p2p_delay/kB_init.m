function kB_init

run('AFDX_Init.m');
global GCD_kB; % kB的BAG的GCD
% outputs periodic traffic to esc

% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority

% 创建MailBox
global VL_UB;
global mb_buflen;
% 优先级队列，mbX(i) > mbX(i+1)
for i = 1:VL_UB
    ttCreateMailbox(['mbB' num2str(i)], mb_buflen);
end

% Periodic sensor task
starttime = 0.0;
period = GCD_kB;

%ttCreatePeriodicTask('kB_p_task', starttime, period, 'kB_p_task');
ttCreatePeriodicTask('kB_P_TSK', starttime, period, 'kB_P_TSK');
