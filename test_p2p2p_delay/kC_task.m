function [exectime, data] = kC_task(seg,data)

global recv_delay;
global v1_delay_array
global v2_delay_array
global sim_end_time;
global file_flag_kC;

switch seg
  case 1
    exectime = recv_delay;
  case 2
     msg = ttGetMsg;
     if ~isempty(msg)
       delay = ttCurrentTime - msg.timestamp; % 计算延迟
       if(msg.vid==1)
           plot_data.delay=delay;
           plot_data.curTime=ttCurrentTime;
           plot_data.from=msg.from;
           plot_data.destination='kC';
           v1_delay_array(end+1)=plot_data;
       end
     
        if(msg.vid==2)
           plot_data.delay=delay;
           plot_data.curTime=ttCurrentTime;
           plot_data.from=msg.from;
           plot_data.destination='kC';
           v2_delay_array(end+1)=plot_data;
       end
       disp(['ttCurr = ', num2str(msg.timestamp)]);
       disp(msg)
     else
       delay = 0;
     end
    
%      disp([mfilename('fullpath') ' Delay = ' num2str(delay)]);
%      disp(['msg.from = ' msg.from]);
     
      if ttCurrentTime>=sim_end_time && file_flag_kC==false
          struct2file(v1_delay_array,'v1_delay_array.xlsx');
          struct2file(v2_delay_array,'v2_delay_array.xlsx');
          file_flag_kC = true;
      end
    exectime = -1;
end
