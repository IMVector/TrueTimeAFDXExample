%-----------------------------读取文件并显示-----------------------------
% data1 = xlsread('v1_delay_array','sheet1', 'A:A');%读取v1_delay_array的第一列

global schedule_type;

y=[];
x=strings([1,4]);
for i=1:4
    file_name="v"+i+"_delay_array";
    data=xlsread(file_name,'sheet1', 'A:A');
    val=mean(data);
    x(i)="v"+i;
    y(end+1)=val*1000000;%转换成微秒
end
bar(y);% Set the axis limits

disp(y)
% Add title and axis labels
title(schedule_type);
xlabel('虚拟链路号');
ylabel('延迟(微秒)');
