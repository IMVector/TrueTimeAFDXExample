function kA_init

run('AFDX_Init.m');
global GCD_kA; % kA的BAG的GCD
% outputs periodic traffic to esc

% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority

% 创建MailBox
global VL_UB;
global mb_buflen;
% 优先级队列，mbX(i) > mbX(i+1)
for i = 1:VL_UB
    ttCreateMailbox(['mbA' num2str(i)], mb_buflen);
end

% Periodic sensor task
starttime = 0.0;
period = GCD_kA;

%ttCreatePeriodicTask('kA_p_task', starttime, period, 'kA_p_task');
ttCreatePeriodicTask('kA_P_TSK', starttime, period, 'kA_P_TSK');
