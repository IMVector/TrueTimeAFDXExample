function struct2file(vector,file_name)
%将结构体保存到文件
[~, num]=size(vector);

excel_vector=cell(num,4);
% excel_vector{1,1}='delay';
% excel_vector{1,2}='curTime';
% excel_vector{1,3}='from';
% excel_vector{1,4}='destination';
for i=1:num
    excel_vector{i,1}=vector(i).delay;
    excel_vector{i,2}=vector(i).curTime;
    excel_vector{i,3}=vector(i).from;
    excel_vector{i,4}=vector(i).destination;
end
xlswrite(file_name,excel_vector,'sheet1');