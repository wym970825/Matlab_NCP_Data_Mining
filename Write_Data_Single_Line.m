%% 
%Function: ������ί������
%Author��  Сүһ�׶� 
%Wechat:   husband_of_gakki
%%
function [done] = Write_Data_Single_Line(ie,url,linenum,ii)
%  ie          ��������
%  url         ��Ӧ������
%  linenum     ������к�
%  ii          ��������

%  done        �ɹ�����1������Ϊ0

    %------------------------------------------- � �� �� �� �� ------------------------------------------%
    done = 0;                                                               %��ɱ�ʶ��ʼ��
    completeness = 0;                                                       %��ɶȳ�ʼ��
    ie.Navigate(url);                                                       %Ŀ��URL
    try
        disp(['��',num2str(ii),'����ҳ������......'])
        while ~strcmp(ie.readystate,'READYSTATE_COMPLETE')                  %�ȴ�����
            pause(0.1)
            %disp(ie.readystate)
        end
        disp(['��',num2str(ii),'����ҳ������ɣ�������'])
        ie.visible = 0;                                                     %���˴���Ϊ1���Բ鿴��ȡ����ҳ����
        SearchItem = ie.document.body.getElementsByClassName('con').item(0);%��Ŀ��element
        target=SearchItem.text;                                             %��Ŀ��element���ı�
    catch
        disp('��ҳ��Ϣ������ץȡҪ��')                                      %�Ҳ����ı������
        return
    end

    %------------------------------------------- �� �� �� �� -------------------------------------------%
    target(find(isspace(target))) = [] ;%ȥ�����пո�
    %disp(target);������
    %--��ȡ����
    date_expression = '\w*��\w*��';
    matchStr = regexp(target,date_expression,'match');
    if(length(matchStr)>1)
        matchStr = cell2mat(matchStr(1));
    end
    if(~isempty(matchStr))
        matchStr=Clipping_Date(matchStr);
    end
    if(isempty(matchStr))
        disp(['��',str2double(ii),'������Ϣ��ƥ��'])
        return
    end
    my_date = matchStr;
    %-------------------------------------------��ȡȫ��ȷ�����������ͺ���ȷ����������-------------------------------------------%
    search='����\w*ȷ�ﲡ��\w*��';                                                     %ƥ����������ʽ
    Newly_confirmed_cases=char(regexp(target,search,'match'));                      %����ƥ��ȫ��ȷ����������
    index=isstrprop(Newly_confirmed_cases,'digit');                                 %��ȡ���ֵ�����
    Newly_confirmed_cases = Newly_confirmed_cases(index);                           %��ȡ����
    search2=['����ȷ�ﲡ��',Newly_confirmed_cases,'����\w*����\w*��'];               %ƥ����������ʽ
    Newly_confirmed_cases_HB=char(regexp(target,search2,'match'));                  %����ƥ�����ȷ����������
    index=isstrprop(Newly_confirmed_cases_HB,'digit');                              %��ȡ���ֵ�����
    Newly_confirmed_cases_HB = Newly_confirmed_cases_HB(index);                     %��ȡ����
    Newly_confirmed_cases_HB=my_erase(Newly_confirmed_cases_HB,Newly_confirmed_cases); %��ȫ�������ӳ��ַ�����ɾ��
    if(isempty(Newly_confirmed_cases))                                              %�����ȡ������
        Newly_confirmed_cases = -1;                                                 %���ֻ�,û�в��������Ĭ��ֵ
        disp(['�������',search,'��   û�����ݣ�����˶�ƥ����ʽ']);
    else
        Newly_confirmed_cases = str2double(Newly_confirmed_cases);                  %���ֻ�
        completeness=completeness+1/17;                                             %��������������
    end
    if(isempty(Newly_confirmed_cases_HB))                                           %�����ȡ������
        Newly_confirmed_cases_HB = -1;                                              %���ֻ�,û�в��������Ĭ��ֵ
        disp(['�������',search2,'��   û�����ݣ�����˶�ƥ����ʽ']);
    else
        Newly_confirmed_cases_HB = str2double(Newly_confirmed_cases_HB);            %���ֻ�
        completeness=completeness+1/17;                                             %��������������
    end
%     disp([Newly_confirmed_cases,Newly_confirmed_cases_HB])                          %������

    %-------------------------------------------��ȡȫ������������Ժ�����ͺ�������������Ժ����-------------------------------------------%
    search='����������Ժ\w*��';                                                  %ƥ����������ʽ
    Newly_cured_cases=char(regexp(target,search,'match'));                          %����ƥ��ȫ������������Ժ����
    index=isstrprop(Newly_cured_cases,'digit');                                     %��ȡ���ֵ�����
    Newly_cured_cases = Newly_cured_cases(index);                                   %��ȡ����
    search2=['����������Ժ\w*',Newly_cured_cases,'����\w*����\w*��'];               %ƥ����������ʽ
    Newly_cured_cases_HB=char(regexp(target,search2,'match'));                      %����ƥ������������Ժ����
    index=isstrprop(Newly_cured_cases_HB,'digit');                                  %��ȡ���ֵ�����
    Newly_cured_cases_HB = Newly_cured_cases_HB(index);                             %��ȡ����
    Newly_cured_cases_HB=my_erase(Newly_cured_cases_HB,Newly_cured_cases);             %��ȫ�������ӳ��ַ�����ɾ��
    if(isempty(Newly_cured_cases))                                                  %�����ȡ������
        Newly_cured_cases = -1;                                                     %���ֻ�,û�в��������Ĭ��ֵ
        disp(['�������',search,'��   û�����ݣ�����˶�ƥ����ʽ']);
    else                                            
        Newly_cured_cases = str2double(Newly_cured_cases);                          %���ֻ�
        completeness=completeness+1/17;                                             %��������������
    end
    if(isempty(Newly_cured_cases_HB))                                               %�����ȡ������
        Newly_cured_cases_HB = -1;                                                  %���ֻ�,û�в��������Ĭ��ֵ
        disp(['�������',search2,'��   û�����ݣ�����˶�ƥ����ʽ']);
    else
        Newly_cured_cases_HB = str2double(Newly_cured_cases_HB);                    %���ֻ�
        completeness=completeness+1/17;                                             %��������������
    end
%     disp([Newly_cured_cases,Newly_cured_cases_HB])                                  %������

    %-------------------------------------------��ȡ���ս��ҽѧ�۲�����нӴ�������-------------------------------------------% 
    search='���ҽѧ�۲�\w*��';                                     %ƥ����������ʽ
    [Number_of_close_contacts_removed,completeness]=get_number_of_class_single(search,target,completeness);     %����˽�к���
%     disp(Number_of_close_contacts_removed);                                         %������

    %-------------------------------------------��ȡ������֢���������ͺ���������֢��������-------------------------------------------%
    search='������֢����\w*��';                            %ƥ����������ʽ
    Newly_severe_cases=char(regexp(target,search,'match'));                         %����ƥ��ȫ��������֢����
    index=isstrprop(Newly_severe_cases,'digit');                                    %��ȡ���ֵ�����
    Newly_severe_cases = Newly_severe_cases(index);                                 %��ȡ����
    search2=['������֢����',Newly_severe_cases,'����\w*����\w*����'];               %ƥ����������ʽ
    Newly_severe_cases_HB=char(regexp(target,search2,'match'));                     %����ƥ��������֢��������
    index=isstrprop(Newly_severe_cases_HB,'digit');                                 %��ȡ���ֵ�����
    Newly_severe_cases_HB = Newly_severe_cases_HB(index);                           %��ȡ����
    Newly_severe_cases_HB=my_erase(Newly_severe_cases_HB,Newly_severe_cases);          %��ȫ�������ӳ��ַ�����ɾ��
    if(isempty(Newly_severe_cases))                                                 %�����ȡ������
        Newly_severe_cases = -1;                                                    %���ֻ���û�в������Ĭ��ֵ                                                  
        disp(['�������',search,'��   û�����ݣ�����˶�ƥ����ʽ']);
    else
        Newly_severe_cases = str2double(Newly_severe_cases);                        %���ֻ�
        completeness=completeness+1/17;                                             %��������������
    end
    if(isempty(Newly_severe_cases_HB))                                              %�����ȡ������
        Newly_severe_cases_HB = -1;                                                 %���ֻ���û�в������Ĭ��ֵ
        disp(['�������',search2,'��   û�����ݣ�����˶�ƥ����ʽ']);
    else
        Newly_severe_cases_HB = str2double(Newly_severe_cases_HB);                  %���ֻ�
        completeness=completeness+1/17;                                             %��������������
    end
%     disp([Newly_severe_cases,Newly_severe_cases_HB])                                %������

    %-------------------------------------------��ȡ�����������������ͺ�������������������-------------------------------------------%
    search='��������\w*��';                                                     %ƥ����������ʽ
    Newly_death_cases=char(regexp(target,search,'match'));                          %����ƥ��ȫ��������������
    index=isstrprop(Newly_death_cases,'digit');                                     %��ȡ���ֵ�����
    Newly_death_cases = Newly_death_cases(index);                                   %��ȡ����
    search2=['��������\w*',Newly_death_cases,'����\w*����\w*��'];                     %ƥ����������ʽ
    Newly_death_cases_HB=char(regexp(target,search2,'match'));                      %����ƥ������������������
    index=isstrprop(Newly_death_cases_HB,'digit');                                  %��ȡ���ֵ�����
    Newly_death_cases_HB = Newly_death_cases_HB(index);                             %��ȡ����
    Newly_death_cases_HB=my_erase(Newly_death_cases_HB,Newly_death_cases);             %��ȫ�������ӳ��ַ�����ɾ��
    if(isempty(Newly_death_cases))
        Newly_death_cases = -1;
        disp(['�������',search,'��   û�����ݣ�����˶�ƥ����ʽ']);
    else
        Newly_death_cases = str2double(Newly_death_cases);                                 %���ֻ�
        completeness=completeness+1/17;                                             %��������������
    end
    if(isempty(Newly_death_cases_HB))
        Newly_death_cases_HB = -1;
        disp(['�������',search2,'��   û�����ݣ�����˶�ƥ����ʽ']);
    else
        Newly_death_cases_HB = str2double(Newly_death_cases_HB);                           %���ֻ�
        completeness=completeness+1/17;                                             %��������������
    end
    %disp([Newly_death_cases,Newly_death_cases_HB])                                  %������

    %-------------------------------------------��ȡ�������Ʋ��������ͺ����������Ʋ�������-------------------------------------------%
    search='��������\w*��';                                                     %ƥ����������ʽ
    Newly_suspected_cases=char(regexp(target,search,'match'));                      %����ƥ��ȫ���������Ƹ���
    index=isstrprop(Newly_suspected_cases,'digit');                                 %��ȡ���ֵ�����
    Newly_suspected_cases = Newly_suspected_cases(index);                           %��ȡ����
    search2=['��������\w*',Newly_suspected_cases,'����\w*����\w*��'];                 %ƥ����������ʽ
    Newly_suspected_cases_HB=char(regexp(target,search2,'match'));                  %����ƥ���������Ʋ�������
    index=isstrprop(Newly_suspected_cases_HB,'digit');                              %��ȡ���ֵ�����
    Newly_suspected_cases_HB = Newly_suspected_cases_HB(index);                     %��ȡ����
    Newly_suspected_cases_HB=my_erase(Newly_suspected_cases_HB,Newly_suspected_cases); %��ȫ�������ӳ��ַ�����ɾ��
    if(isempty(Newly_suspected_cases))
       Newly_suspected_cases = -1; 
       disp(['�������',search,'��   û�����ݣ�����˶�ƥ����ʽ']);
    else
        Newly_suspected_cases = str2double(Newly_suspected_cases);                   %���ֻ�
        completeness=completeness+1/17;                                             %��������������
    end
    if(isempty(Newly_suspected_cases_HB))
        Newly_suspected_cases_HB = -1;
        disp(['�������',search2,'��   û�����ݣ�����˶�ƥ����ʽ']);
    else
        Newly_suspected_cases_HB = str2double(Newly_suspected_cases_HB);            %���ֻ�
        completeness=completeness+1/17;                                             %��������������
    end
    %disp([Newly_suspected_cases,Newly_suspected_cases_HB])                          %������

    search='�ۼƱ���\w*ȷ�ﲡ��\w*��';                                                 %ƥ����������ʽ
    [cumulative_number_of_confirmed,completeness]=get_number_of_class_single(search,target,completeness);
    %disp(cumulative_number_of_confirmed);                                           %������
    search='�ۼ�������Ժ\w*��';                                                     %ƥ����������ʽ
    [Cumulative_cured,completeness]=get_number_of_class_single(search,target,completeness);
    %disp(Cumulative_cured);                                                         %������
%     search='��������\w*��';                                                         %ƥ����������ʽ
%     [Cumulative_isolation_therapy_members,completeness]=get_number_of_class_single(search,target,completeness);
%     %disp(Cumulative_isolation_therapy_members);                                     %������
    search='�ۼ�����\w*��';                                                     %ƥ����������ʽ
    [Cumulative_deaths,completeness]=get_number_of_class_single(search,target,completeness);
    %disp(Cumulative_deaths);                                                        %������
    search='�����Ʋ���\w*��';                                                     %ƥ����������ʽ
    [Existing_suspected_cases,completeness]=get_number_of_class_single(search,target,completeness);
    %disp(Existing_suspected_cases);                                                 %������
    search='�ۼ�׷�ٵ����нӴ���\w*��';                                             %ƥ����������ʽ
    [Close_contacts_have_been_traced,completeness]=get_number_of_class_single(search,target,completeness);
    %disp(Close_contacts_have_been_traced);                                          %������
    search='\w*��\w*ҽѧ�۲�\w*';                                         %ƥ����������ʽ
    [Observing_case,completeness]=get_number_of_class_single(search,target,completeness);
    %disp(Observing_case);                                                           %������
    if(completeness<0.2)
        disp([my_date,'��������ȥ�����������ȣ�',num2str(completeness*100),'%,������Ҫ��']);
        return
    else
        disp([my_date,'�����������ȣ�',num2str(completeness*100),'%,']);
    end
    %%
    %------------------------------------------- �� �� �� �� -------------------------------------------%
    try
        database_addr = 'nCov_database.xlsx';                                       %���ݱ�·��
        sheetnumber=1;                                                              %���ݱ�ѡ���ļ��ĵ�һ�ű�
        Datain=[Newly_confirmed_cases,Newly_confirmed_cases_HB,Newly_cured_cases, ...
        Newly_cured_cases_HB,Number_of_close_contacts_removed,Newly_severe_cases, ...
        Newly_severe_cases_HB,Newly_death_cases,Newly_death_cases_HB,Newly_suspected_cases, ...
        Newly_suspected_cases_HB,cumulative_number_of_confirmed, ...
        Cumulative_cured,Cumulative_deaths, ...
        Existing_suspected_cases,Close_contacts_have_been_traced,Observing_case];
        xlRange = ['B',num2str(linenum),':R',num2str(linenum)];                     %B2д�룬��һ���Ǳ�ͷ
        xlswrite(database_addr,cellstr('Сүһ�׶�'),sheetnumber,'A1');
        xlswrite(database_addr,cellstr([my_date,'0-24ʱ']),sheetnumber,['A',num2str(linenum)]);
        xlswrite(database_addr,Datain,sheetnumber,xlRange)                          %д��
        done = 1;                                                                   %д���������
    catch
        disp('���ݵ�������');                                                       %��ʾ��Ϣ
        done = 0;                                                                   %д������ʧ��
    end
%     ie.Quit();                                                                      %��ʱ�˳�����Ȼ���ܻῨ��
%     delete(ie);                                                                     %ɾ���´����¿�
%     clear ie
end
%%
%------------------------------------------ ˽ �� �� �� �� �� -------------------------------------------%
% close all;
% delete(ie)

function [res,completeness]= get_number_of_class_single(search_str,target,completeness)                   
%��װ��һ��������������ûʲô��Ҫ��û��װ�����
    res=char(regexp(target,search_str,'match'));                                %����ƥ��
    if(isempty(res))                                                            %����ûƥ������
        disp(['�������',search_str,'��   û�����ݣ�����˶�ƥ����ʽ']);
        res=-1;                                                                 %����Ĭ��ֵ
    else
        index=isstrprop(res,'digit');                                           %��ȡ���ֵ�����
        res = str2double(res(index));                                           %��ȡ����
        completeness=completeness+1/17;                                         %��������������       
    end   
end
function [Date_out]=Clipping_Date(Date_in)                                      %����ͳһ��ʽ
    Date_out=Date_in((find(Date_in=='��')-1):end);    
end
function [str_out]=my_erase(str1,str2)                                      %��str1��ǰ���ȥstr2,ֻ��һ��
    temp = str1;
    str_out = erase(str1,str2);
    if(length(str2)+length(str_out)<length(str1))                           %ʹ��erase�����Σ����ȺͲ�����str1˵��str1�к��в�ֹһ��str2
        temp(1:length(str2)) = '';
        str_out = temp;
    end
end

