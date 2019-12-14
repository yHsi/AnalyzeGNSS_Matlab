function [bool] = display_sat_mean_std(class_obj,sys,OBSTYPE,flag_save) 
%   MSatStutes的类方法
%   绘制每颗卫星的残差均值和标准差 各个参数具体设置如下：
%   sys : 1: GPS 2: GLONASS 3:BDS 4:GAL -1:all
%   prn : x:某颗卫星在系统内的prn -1:all
%   f   : 1:频率一 2:频率二 -1:all
%   OBSTYPE: 1:伪距 2:相位 -1:all
%   flag_save: 0：not save 1:save  在当前目录下创建文件夹
%   11.11版本先仅支持全部绘制

% 创建文件夹储存 按照系统划分
% 文件夹名称为   SMS_SYS
% 图像命名规则为 SMS_sys_OBSTYPE.png
folder = cell(5,1);
folder{1} = [class_obj.m_path,'SMS_GPS'];
folder{2} = [class_obj.m_path,'SMS_GLO'];
folder{3} = [class_obj.m_path,'SMS_BDS'];
folder{4} = [class_obj.m_path,'SMS_GAL'];
folder{5} = [class_obj.m_path,'SMS_QZS'];

SYS = cell(5,1);
SYS{1} = ['GPS'];
SYS{2} = ['GLO'];
SYS{3} = ['BDS'];
SYS{4} = ['GAL'];
SYS{5} = ['QZS'];

for sys = 1:5
    if ~exist(cell2mat(folder(sys)))
        mkdir(cell2mat(folder(sys)));
    else
        rmdir(cell2mat(folder(sys)),'s');
        mkdir(cell2mat(folder(sys)));
    end
end


% 输出伪距图像
display_sat_mean_std_subP(class_obj,folder,SYS,-1,flag_save);

% 输出相位图像
display_sat_mean_std_subL(class_obj,folder,SYS,-1,flag_save);
end


function [bool] = display_sat_mean_std_subP(class_obj,folder,SYS,sys,flag_save) 
% 进度条
 wait_h = waitbar(0,'绘制伪距残差均值、标准差图像');

% 输出伪距图像
for sys = 1:5
       if sys == 5
            [~,n,~] = size(class_obj.m_SD_P);
           data_end = n;
        else
           data_end = class_obj.m_PRN0(sys+1)-1;
       end
        data_begin = class_obj.m_PRN0(sys);
        
        filename = [cell2mat(folder(sys)),'\\SMS_',cell2mat(SYS(sys)),'_P'];
        fh = figure('Visible','off');
        X = data_begin : data_end;
        errorbar(X,class_obj.m_mean_res(1,data_begin:data_end,1),class_obj.m_std_res(1,data_begin:data_end,1),'r*');
        hold on;
        errorbar(X,class_obj.m_mean_res(1,data_begin:data_end,2),class_obj.m_std_res(1,data_begin:data_end,2),'bo');
        hold off;
        legend('f1','f2');
        saveas(fh,filename,'png');
        close(fh);    
        waitbar(sys/5);
end
   close(wait_h);
end

function [bool] = display_sat_mean_std_subL(class_obj,folder,SYS,sys,flag_save) 
% 进度条
 wait_h = waitbar(0,'绘制相位残差均值、标准差图像');

% 输出伪距图像
for sys = 1:5
       if sys == 5
            [~,n,~] = size(class_obj.m_DD_L);
           data_end = n;
        else
           data_end = class_obj.m_PRN0(sys+1)-1;
       end
        data_begin = class_obj.m_PRN0(sys);
        
        filename = [cell2mat(folder(sys)),'\\SMS_',cell2mat(SYS(sys)),'_L'];
        fh = figure('Visible','off');
        X = data_begin : data_end;
        errorbar(X,class_obj.m_mean_res(2,data_begin:data_end,1),class_obj.m_std_res(2,data_begin:data_end,1),'r*');
        hold on;
        errorbar(X,class_obj.m_mean_res(2,data_begin:data_end,2),class_obj.m_std_res(2,data_begin:data_end,2),'bo');
        hold off;
        legend('f1','f2');
        saveas(fh,filename,'png');
        close(fh);    
        waitbar(sys/5);
end
   close(wait_h);
end

