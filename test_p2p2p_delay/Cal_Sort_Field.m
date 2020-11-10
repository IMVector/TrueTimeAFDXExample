function [val] = Cal_Sort_Field(msg)
  global schedule_type;
  if strcmp(schedule_type, 'SP')
    val = -msg.pri;
  elseif strcmp(schedule_type, 'FIFO')
    val = msg.recvtime;
  end
end

