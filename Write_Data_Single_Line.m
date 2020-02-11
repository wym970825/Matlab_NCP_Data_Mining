%% 
%Function: 从卫健委爬数据
%Author：  小爷一米二 
%Wechat:   husband_of_gakki
%%
function [done] = Write_Data_Single_Line(ie,url,linenum,ii)
%  ie          浏览器组件
%  url         对应的链接
%  linenum     输入的行号
%  ii          输入的序号

%  done        成功返回1，否则为0

    %------------------------------------------- 浏 览 器 配 置 ------------------------------------------%
    done = 0;                                                               %完成标识初始化
    completeness = 0;                                                       %完成度初始化
    ie.Navigate(url);                                                       %目标URL
    try
        disp(['第',num2str(ii),'个网页加载中......'])
        while ~strcmp(ie.readystate,'READYSTATE_COMPLETE')                  %等待加载
            pause(0.1)
            %disp(ie.readystate)
        end
        disp(['第',num2str(ii),'个网页加载完成，处理中'])
        ie.visible = 0;                                                     %将此处改为1可以查看爬取的网页内容
        SearchItem = ie.document.body.getElementsByClassName('con').item(0);%找目标element
        target=SearchItem.text;                                             %找目标element的文本
    catch
        disp('网页信息不满足抓取要求')                                      %找不到文本则放弃
        return
    end

    %------------------------------------------- 文 本 处 理 -------------------------------------------%
    target(find(isspace(target))) = [] ;%去除所有空格
    %disp(target);调试用
    %--获取日期
    date_expression = '\w*月\w*日';
    matchStr = regexp(target,date_expression,'match');
    if(length(matchStr)>1)
        matchStr = cell2mat(matchStr(1));
    end
    if(~isempty(matchStr))
        matchStr=Clipping_Date(matchStr);
    end
    if(isempty(matchStr))
        disp(['第',str2double(ii),'条，信息不匹配'])
        return
    end
    my_date = matchStr;
    %-------------------------------------------获取全国确诊新增个数和湖北确诊新增个数-------------------------------------------%
    search='新增\w*确诊病例\w*例';                                                     %匹配用正则表达式
    Newly_confirmed_cases=char(regexp(target,search,'match'));                      %正则匹配全国确诊新增个数
    index=isstrprop(Newly_confirmed_cases,'digit');                                 %提取数字的索引
    Newly_confirmed_cases = Newly_confirmed_cases(index);                           %提取数字
    search2=['新增确诊病例',Newly_confirmed_cases,'例（\w*湖北\w*例'];               %匹配用正则表达式
    Newly_confirmed_cases_HB=char(regexp(target,search2,'match'));                  %正则匹配湖北确诊新增个数
    index=isstrprop(Newly_confirmed_cases_HB,'digit');                              %提取数字的索引
    Newly_confirmed_cases_HB = Newly_confirmed_cases_HB(index);                     %提取数字
    Newly_confirmed_cases_HB=my_erase(Newly_confirmed_cases_HB,Newly_confirmed_cases); %将全国人数从长字符串中删除
    if(isempty(Newly_confirmed_cases))                                              %检测爬取的数据
        Newly_confirmed_cases = -1;                                                 %数字化,没有捕获则输出默认值
        disp(['搜索项：“',search,'”   没有数据，建议核对匹配表达式']);
    else
        Newly_confirmed_cases = str2double(Newly_confirmed_cases);                  %数字化
        completeness=completeness+1/17;                                             %计算数据完整度
    end
    if(isempty(Newly_confirmed_cases_HB))                                           %检测爬取的数据
        Newly_confirmed_cases_HB = -1;                                              %数字化,没有捕获则输出默认值
        disp(['搜索项：“',search2,'”   没有数据，建议核对匹配表达式']);
    else
        Newly_confirmed_cases_HB = str2double(Newly_confirmed_cases_HB);            %数字化
        completeness=completeness+1/17;                                             %计算数据完整度
    end
%     disp([Newly_confirmed_cases,Newly_confirmed_cases_HB])                          %调试用

    %-------------------------------------------获取全国新增治愈出院个数和湖北新增治愈出院个数-------------------------------------------%
    search='新增治愈出院\w*例';                                                  %匹配用正则表达式
    Newly_cured_cases=char(regexp(target,search,'match'));                          %正则匹配全国新增治愈出院个数
    index=isstrprop(Newly_cured_cases,'digit');                                     %提取数字的索引
    Newly_cured_cases = Newly_cured_cases(index);                                   %提取数字
    search2=['新增治愈出院\w*',Newly_cured_cases,'例（\w*湖北\w*例'];               %匹配用正则表达式
    Newly_cured_cases_HB=char(regexp(target,search2,'match'));                      %正则匹配新增治愈出院个数
    index=isstrprop(Newly_cured_cases_HB,'digit');                                  %提取数字的索引
    Newly_cured_cases_HB = Newly_cured_cases_HB(index);                             %提取数字
    Newly_cured_cases_HB=my_erase(Newly_cured_cases_HB,Newly_cured_cases);             %将全国人数从长字符串中删除
    if(isempty(Newly_cured_cases))                                                  %检测爬取的数据
        Newly_cured_cases = -1;                                                     %数字化,没有捕获则输出默认值
        disp(['搜索项：“',search,'”   没有数据，建议核对匹配表达式']);
    else                                            
        Newly_cured_cases = str2double(Newly_cured_cases);                          %数字化
        completeness=completeness+1/17;                                             %计算数据完整度
    end
    if(isempty(Newly_cured_cases_HB))                                               %检测爬取的数据
        Newly_cured_cases_HB = -1;                                                  %数字化,没有捕获则输出默认值
        disp(['搜索项：“',search2,'”   没有数据，建议核对匹配表达式']);
    else
        Newly_cured_cases_HB = str2double(Newly_cured_cases_HB);                    %数字化
        completeness=completeness+1/17;                                             %计算数据完整度
    end
%     disp([Newly_cured_cases,Newly_cured_cases_HB])                                  %调试用

    %-------------------------------------------获取当日解除医学观察的密切接触者人数-------------------------------------------% 
    search='解除医学观察\w*人';                                     %匹配用正则表达式
    [Number_of_close_contacts_removed,completeness]=get_number_of_class_single(search,target,completeness);     %调用私有函数
%     disp(Number_of_close_contacts_removed);                                         %调试用

    %-------------------------------------------获取新增重症病例个数和湖北新增重症病例个数-------------------------------------------%
    search='新增重症病例\w*例';                            %匹配用正则表达式
    Newly_severe_cases=char(regexp(target,search,'match'));                         %正则匹配全国新增重症个数
    index=isstrprop(Newly_severe_cases,'digit');                                    %提取数字的索引
    Newly_severe_cases = Newly_severe_cases(index);                                 %提取数字
    search2=['新增重症病例',Newly_severe_cases,'例（\w*湖北\w*例）'];               %匹配用正则表达式
    Newly_severe_cases_HB=char(regexp(target,search2,'match'));                     %正则匹配新增重症病例个数
    index=isstrprop(Newly_severe_cases_HB,'digit');                                 %提取数字的索引
    Newly_severe_cases_HB = Newly_severe_cases_HB(index);                           %提取数字
    Newly_severe_cases_HB=my_erase(Newly_severe_cases_HB,Newly_severe_cases);          %将全国人数从长字符串中删除
    if(isempty(Newly_severe_cases))                                                 %检测爬取的数据
        Newly_severe_cases = -1;                                                    %数字化，没有捕获输出默认值                                                  
        disp(['搜索项：“',search,'”   没有数据，建议核对匹配表达式']);
    else
        Newly_severe_cases = str2double(Newly_severe_cases);                        %数字化
        completeness=completeness+1/17;                                             %计算数据完整度
    end
    if(isempty(Newly_severe_cases_HB))                                              %检测爬取的数据
        Newly_severe_cases_HB = -1;                                                 %数字化，没有捕获输出默认值
        disp(['搜索项：“',search2,'”   没有数据，建议核对匹配表达式']);
    else
        Newly_severe_cases_HB = str2double(Newly_severe_cases_HB);                  %数字化
        completeness=completeness+1/17;                                             %计算数据完整度
    end
%     disp([Newly_severe_cases,Newly_severe_cases_HB])                                %调试用

    %-------------------------------------------获取新增死亡病例个数和湖北新增死亡病例个数-------------------------------------------%
    search='新增死亡\w*例';                                                     %匹配用正则表达式
    Newly_death_cases=char(regexp(target,search,'match'));                          %正则匹配全国新增死亡个数
    index=isstrprop(Newly_death_cases,'digit');                                     %提取数字的索引
    Newly_death_cases = Newly_death_cases(index);                                   %提取数字
    search2=['新增死亡\w*',Newly_death_cases,'例（\w*湖北\w*例'];                     %匹配用正则表达式
    Newly_death_cases_HB=char(regexp(target,search2,'match'));                      %正则匹配新增死亡病例个数
    index=isstrprop(Newly_death_cases_HB,'digit');                                  %提取数字的索引
    Newly_death_cases_HB = Newly_death_cases_HB(index);                             %提取数字
    Newly_death_cases_HB=my_erase(Newly_death_cases_HB,Newly_death_cases);             %将全国人数从长字符串中删除
    if(isempty(Newly_death_cases))
        Newly_death_cases = -1;
        disp(['搜索项：“',search,'”   没有数据，建议核对匹配表达式']);
    else
        Newly_death_cases = str2double(Newly_death_cases);                                 %数字化
        completeness=completeness+1/17;                                             %计算数据完整度
    end
    if(isempty(Newly_death_cases_HB))
        Newly_death_cases_HB = -1;
        disp(['搜索项：“',search2,'”   没有数据，建议核对匹配表达式']);
    else
        Newly_death_cases_HB = str2double(Newly_death_cases_HB);                           %数字化
        completeness=completeness+1/17;                                             %计算数据完整度
    end
    %disp([Newly_death_cases,Newly_death_cases_HB])                                  %调试用

    %-------------------------------------------获取新增疑似病例个数和湖北新增疑似病例个数-------------------------------------------%
    search='新增疑似\w*例';                                                     %匹配用正则表达式
    Newly_suspected_cases=char(regexp(target,search,'match'));                      %正则匹配全国新增疑似个数
    index=isstrprop(Newly_suspected_cases,'digit');                                 %提取数字的索引
    Newly_suspected_cases = Newly_suspected_cases(index);                           %提取数字
    search2=['新增疑似\w*',Newly_suspected_cases,'例（\w*湖北\w*例'];                 %匹配用正则表达式
    Newly_suspected_cases_HB=char(regexp(target,search2,'match'));                  %正则匹配新增疑似病例个数
    index=isstrprop(Newly_suspected_cases_HB,'digit');                              %提取数字的索引
    Newly_suspected_cases_HB = Newly_suspected_cases_HB(index);                     %提取数字
    Newly_suspected_cases_HB=my_erase(Newly_suspected_cases_HB,Newly_suspected_cases); %将全国人数从长字符串中删除
    if(isempty(Newly_suspected_cases))
       Newly_suspected_cases = -1; 
       disp(['搜索项：“',search,'”   没有数据，建议核对匹配表达式']);
    else
        Newly_suspected_cases = str2double(Newly_suspected_cases);                   %数字化
        completeness=completeness+1/17;                                             %计算数据完整度
    end
    if(isempty(Newly_suspected_cases_HB))
        Newly_suspected_cases_HB = -1;
        disp(['搜索项：“',search2,'”   没有数据，建议核对匹配表达式']);
    else
        Newly_suspected_cases_HB = str2double(Newly_suspected_cases_HB);            %数字化
        completeness=completeness+1/17;                                             %计算数据完整度
    end
    %disp([Newly_suspected_cases,Newly_suspected_cases_HB])                          %调试用

    search='累计报告\w*确诊病例\w*例';                                                 %匹配用正则表达式
    [cumulative_number_of_confirmed,completeness]=get_number_of_class_single(search,target,completeness);
    %disp(cumulative_number_of_confirmed);                                           %调试用
    search='累计治愈出院\w*例';                                                     %匹配用正则表达式
    [Cumulative_cured,completeness]=get_number_of_class_single(search,target,completeness);
    %disp(Cumulative_cured);                                                         %调试用
%     search='隔离治疗\w*例';                                                         %匹配用正则表达式
%     [Cumulative_isolation_therapy_members,completeness]=get_number_of_class_single(search,target,completeness);
%     %disp(Cumulative_isolation_therapy_members);                                     %调试用
    search='累计死亡\w*例';                                                     %匹配用正则表达式
    [Cumulative_deaths,completeness]=get_number_of_class_single(search,target,completeness);
    %disp(Cumulative_deaths);                                                        %调试用
    search='有疑似病例\w*例';                                                     %匹配用正则表达式
    [Existing_suspected_cases,completeness]=get_number_of_class_single(search,target,completeness);
    %disp(Existing_suspected_cases);                                                 %调试用
    search='累计追踪到密切接触者\w*人';                                             %匹配用正则表达式
    [Close_contacts_have_been_traced,completeness]=get_number_of_class_single(search,target,completeness);
    %disp(Close_contacts_have_been_traced);                                          %调试用
    search='\w*在\w*医学观察\w*';                                         %匹配用正则表达式
    [Observing_case,completeness]=get_number_of_class_single(search,target,completeness);
    %disp(Observing_case);                                                           %调试用
    if(completeness<0.2)
        disp([my_date,'的数据舍去，数据完整度：',num2str(completeness*100),'%,不满足要求，']);
        return
    else
        disp([my_date,'的数据完整度：',num2str(completeness*100),'%,']);
    end
    %%
    %------------------------------------------- 表 格 操 作 -------------------------------------------%
    try
        database_addr = 'nCov_database.xlsx';                                       %数据表路径
        sheetnumber=1;                                                              %数据表选择文件的第一张表
        Datain=[Newly_confirmed_cases,Newly_confirmed_cases_HB,Newly_cured_cases, ...
        Newly_cured_cases_HB,Number_of_close_contacts_removed,Newly_severe_cases, ...
        Newly_severe_cases_HB,Newly_death_cases,Newly_death_cases_HB,Newly_suspected_cases, ...
        Newly_suspected_cases_HB,cumulative_number_of_confirmed, ...
        Cumulative_cured,Cumulative_deaths, ...
        Existing_suspected_cases,Close_contacts_have_been_traced,Observing_case];
        xlRange = ['B',num2str(linenum),':R',num2str(linenum)];                     %B2写入，第一行是表头
        xlswrite(database_addr,cellstr('小爷一米二'),sheetnumber,'A1');
        xlswrite(database_addr,cellstr([my_date,'0-24时']),sheetnumber,['A',num2str(linenum)]);
        xlswrite(database_addr,Datain,sheetnumber,xlRange)                          %写入
        done = 1;                                                                   %写入数据完成
    catch
        disp('数据导出错误');                                                       %显示信息
        done = 0;                                                                   %写入数据失败
    end
%     ie.Quit();                                                                      %及时退出，不然可能会卡死
%     delete(ie);                                                                     %删除下次重新开
%     clear ie
end
%%
%------------------------------------------ 私 有 函 数 定 义 -------------------------------------------%
% close all;
% delete(ie)

function [res,completeness]= get_number_of_class_single(search_str,target,completeness)                   
%封装了一个函数后来觉得没什么必要就没封装后面的
    res=char(regexp(target,search_str,'match'));                                %正则匹配
    if(isempty(res))                                                            %数据没匹配提醒
        disp(['搜索项：“',search_str,'”   没有数据，建议核对匹配表达式']);
        res=-1;                                                                 %返回默认值
    else
        index=isstrprop(res,'digit');                                           %提取数字的索引
        res = str2double(res(index));                                           %提取数字
        completeness=completeness+1/17;                                         %计算数据完整度       
    end   
end
function [Date_out]=Clipping_Date(Date_in)                                      %用于统一格式
    Date_out=Date_in((find(Date_in=='月')-1):end);    
end
function [str_out]=my_erase(str1,str2)                                      %从str1中前面减去str2,只减一次
    temp = str1;
    str_out = erase(str1,str2);
    if(length(str2)+length(str_out)<length(str1))                           %使用erase会减多次，长度和不等于str1说明str1中含有不止一个str2
        temp(1:length(str2)) = '';
        str_out = temp;
    end
end

