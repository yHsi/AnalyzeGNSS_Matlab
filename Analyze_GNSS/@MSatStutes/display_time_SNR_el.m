function [ bool ] = display_time_SNR_el(class_obj,Sys,Prn,F,OBSTYPE,flag_save)
%   MSatStutes的类方法
%   绘制残差、SNR与el的时间序列图 各个参数具体设置如下：
%   sys : 1: GPS 2: GLONASS 3:BDS 4:GAL -1:all
%   prn : x:某颗卫星在系统内的prn -1:all
%   f   : 1:频率一 2:频率二 -1:all
%   OBSTYPE: 1:伪距 2:相位 -1:all
%   flag_save: 0：not save 1:save  在当前目录下创建文件夹
%   1109版本先仅支持全部绘制

% 创建文件夹储存 按照系统划分
% 文件夹名称为   TSE_SYS
% 图像命名规则为 TSE_prn_f_OBSTYPE.png
folder = cell(5,1);
folder{1} = [class_obj.m_path,'TSE_GPS'];
folder{2} = [class_obj.m_path,'TSE_GLO'];
folder{3} = [class_obj.m_path,'TSE_BDS'];
folder{4} = [class_obj.m_path,'TSE_GAL'];
folder{5} = [class_obj.m_path,'TSE_QZS'];
for sys = 1:5
    if ~exist(cell2mat(folder(sys)))
        mkdir(cell2mat(folder(sys)));
    else
        rmdir(cell2mat(folder(sys)),'s');
        mkdir(cell2mat(folder(sys)));
    end
end

% 绘制伪距残差
display_time_SNR_el_subP(class_obj,folder,Sys,Prn,-1,flag_save);
display_time_SNR_el_subL(class_obj,folder,Sys,Prn,-1,flag_save);

end


function [ bool ] = display_time_SNR_el_subP(class_obj,folder,Sys,Prn,f,flag_save)
 % 进度条
 wait_h = waitbar(0,'绘制伪距残差、信噪比、高度角图像');

% 输出伪距图像
for sys = 1:5
    for f = 1:2
       if sys == 5
            [~,n,~] = size(class_obj.m_SD_P);
           data_end = n;
        else
           data_end = class_obj.m_PRN0(sys+1)-1;
       end
        data_begin = class_obj.m_PRN0(sys);
        
            for sat = data_begin:data_end
                 P = class_obj.m_SD_P(:,sat,f);
                 CN0 = class_obj.m_CN0(:,sat,f);
                 EL = class_obj.m_EL(:,sat);
                 if mean(P) == 0 &&  mean(CN0) == 0 &&  mean(EL) == 0
                     continue;
                 end
                 [~,~,prn_char] = class_obj.findSat(sat);
                 Locate = find(P == 0);
                 P(Locate) = nan;
                 Locate = find(CN0 == 0);
                 CN0(Locate) = nan;
                 Locate = find(EL == 0);
                 EL(Locate) = nan;
                 
                 filename = [cell2mat(folder(sys)),'\\TES_',prn_char,'_',num2str(f),'P'];
                 fh = figure('Visible','off');
                 plot(class_obj.m_GPSTIME(:,1),P,'r.',...
                      class_obj.m_GPSTIME(:,1),CN0,'g.',... 
                      class_obj.m_GPSTIME(:,1),EL,'b.');
                  saveas(fh,filename,'png');
                  close(fh);
                 clear P
            end
          
    waitbar((f-1)*5+sys/10);      
    end
    
end
    close(wait_h);
end


function [ bool ] = display_time_SNR_el_subL(class_obj,folder,Sys,Prn,f,flag_save)
 % 进度条
 wait_h = waitbar(0,'绘制相位残差、信噪比、高度角图像');

% 输出相位图像
for sys = 1:5
    for f = 1:2
       if sys == 5
            [~,n,~] = size(class_obj.m_DD_L);
           data_end = n;
        else
           data_end = class_obj.m_PRN0(sys+1)-1;
       end
        data_begin = class_obj.m_PRN0(sys);
        
            for sat = data_begin:data_end
                 L = class_obj.m_DD_L(:,sat,f);
                 CN0 = class_obj.m_CN0(:,sat,f);
                 EL = class_obj.m_EL(:,sat);
                 if mean(L) == 0 &&  mean(CN0) == 0 &&  mean(EL) == 0
                     continue;
                 end
                 [~,~,prn_char] = class_obj.findSat(sat);
                 Locate = find(L == 0);
                 L(Locate) = nan;
                 Locate = find(CN0 == 0);
                 CN0(Locate) = nan;
                 Locate = find(EL == 0);
                 EL(Locate) = nan;
                 
                 filename = [cell2mat(folder(sys)),'\\TES_',prn_char,'_',num2str(f),'L'];
                 fh = figure('Visible','off');
                 plot(class_obj.m_GPSTIME(:,1),L,'r.',...
                      class_obj.m_GPSTIME(:,1),CN0,'g.',... 
                      class_obj.m_GPSTIME(:,1),EL,'b.');
                  saveas(fh,filename,'png');
                  close(fh);
                 clear L
            end
          
    waitbar((f-1)*5+sys/10);      
    end
    
end
    close(wait_h);
end
