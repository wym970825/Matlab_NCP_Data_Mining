close all;
clear all;
clc;

ie=actxserver('internetexplorer.application');
target='http://www.nhc.gov.cn/xcs/yqtb/list_gzbd.shtml';
ie.Navigate(target);                                    %目标URL
while ~strcmp(ie.readystate,'READYSTATE_COMPLETE')      %等待加载
    pause(0.5)
    disp(ie.readystate)                                 %显示信息
end
ie.visible = 0;                                         %将此处改为1可以查看爬取的网页内容
URL_length = ie.document.body.getElementsByTagName('a').length;             %找目标element
URL_array=cell(1,URL_length);                                               %创建元胞数组
for index=1:URL_length                                                      %给数组赋值
    Temp_URL=ie.document.body.getElementsByTagName('a').item(index-1).href;
%     disp(Temp_URL)
    URL_array(index) = cellstr(Temp_URL);
end

% delete(ie);
% clear ie;
line_num=2;  
%从第二行开始写，第一行是表头
for index=1:URL_length
    Temp_URL=cell2mat(URL_array(index));
    flag=Write_Data_Single_Line(ie,Temp_URL,line_num,index);
    if(flag)
        line_num = line_num+1;                                                      %写入成功就换下一行，不然不换
    end
end
ie.Quit();                                                                      %及时退出，不然可能会卡死
delete(ie);                                                                     %删除下次重新开
clear ie