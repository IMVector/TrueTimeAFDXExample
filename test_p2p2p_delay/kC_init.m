function kC_init

% Initialize TrueTime kernel
ttInitKernel('prioFP');  % scheduling policy - fixed priority

deadline = 10.0;
ttCreateTask('kC_task', deadline, 'kC_task');

ttAttachNetworkHandler('kC_task')
