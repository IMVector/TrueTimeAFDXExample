function [exectime, data] = sA_TSK_Recv(seg,data)

global sA_trigger;

switch seg
  case 1
    % 所有要读取的网络号
    
    netin_id_list = [1];
    [~, c] = size(netin_id_list);
  
    for j = 1:c
      netin_id = netin_id_list(1, j);
      msg = ttGetMsg(netin_id);
       
      if ~isempty(msg)
          
        msg.recvtime = ttCurrentTime;
        disp("==================delay=====================")
        disp(ttCurrentTime-msg.timestamp)
        disp("==================delay=====================")
        if sA_trigger == false
          sA_trigger = true;
            
          ttCreateJob('sA_TSK_SND');
        end
          
        % 扔到Mailbox里面去
        ttTryPost(['mbA' num2str(msg.vid)], msg);
      end
      
    end
      
    disp('sA_TSK_Recv end at');
    disp(ttCurrentTime);
     
exectime = -1;
end
