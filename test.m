close all;
clear all;
clc;

ie=actxserver('internetexplorer.application');
target='http://www.nhc.gov.cn/xcs/yqtb/list_gzbd.shtml';
ie.Navigate(target);                                    %Ŀ��URL
while ~strcmp(ie.readystate,'READYSTATE_COMPLETE')      %�ȴ�����
    pause(0.5)
    disp(ie.readystate)                                 %��ʾ��Ϣ
end
ie.visible = 0;                                         %���˴���Ϊ1���Բ鿴��ȡ����ҳ����
URL_length = ie.document.body.getElementsByTagName('a').length;             %��Ŀ��element
URL_array=cell(1,URL_length);                                               %����Ԫ������
for index=1:URL_length                                                      %�����鸳ֵ
    Temp_URL=ie.document.body.getElementsByTagName('a').item(index-1).href;
%     disp(Temp_URL)
    URL_array(index) = cellstr(Temp_URL);
end

% delete(ie);
% clear ie;
line_num=2;  
%�ӵڶ��п�ʼд����һ���Ǳ�ͷ
for index=1:URL_length
    Temp_URL=cell2mat(URL_array(index));
    flag=Write_Data_Single_Line(ie,Temp_URL,line_num,index);
    if(flag)
        line_num = line_num+1;                                                      %д��ɹ��ͻ���һ�У���Ȼ����
    end
end
ie.Quit();                                                                      %��ʱ�˳�����Ȼ���ܻῨ��
delete(ie);                                                                     %ɾ���´����¿�
clear ie