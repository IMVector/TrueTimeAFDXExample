function [exectime, data] = sB_TSK_Recv(seg,data)

global sB_trigger;

switch seg
  case 1
    % 所有要读取的网络号
    
    netin_id_list = [2];
    [~, c] = size(netin_id_list);
      
    for j = 1:c
      netin_id = netin_id_list(1, j);
      msg = ttGetMsg(netin_id);
   
      if ~isempty(msg)
          
        msg.recvtime = ttCurrentTime;
        disp("==================sBdelay=====================")
        disp((ttCurrentTime-msg.timestamp)*1000000)
        disp("==================sBdelay=====================")
        if sB_trigger == false
          sB_trigger = true;
          ttCreateJob('sB_TSK_SND');
        end
          
        % 扔到Mailbox里面去
        ttTryPost(['mbB' num2str(msg.vid)], msg);
      end
      
    end
      
    disp('sB_TSK_Recv end at');
    disp(ttCurrentTime);
    
exectime = -1;
end
