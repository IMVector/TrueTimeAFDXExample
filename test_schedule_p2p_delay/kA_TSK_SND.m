function [exectime, data] = kA_TSK_SND(seg,data)


switch seg
    case 1
        m1 = ttTryFetch(['mbA' num2str(1)]);
        m2 = ttTryFetch(['mbA' num2str(2)]);
        ttSendMsg([1 2], m1, m1.lmax);
        ttSendMsg([1 2], m2, m2.lmax);
        exectime = -1;
        
end

