function [ bool ] = display_res_SNR(class_obj,Sys,Prn,F,OBSTYPE,flag_save)
%   MSatStutes的类方法
%   绘制残差与SNR的二维点图 各个参数具体设置如下：
%   sys : 1: GPS 2: GLONASS 3:BDS 4:GAL 5:QZS -1:all
%   prn : x:某颗卫星在系统内的prn -1:all
%   f   : 1:频率一 2:频率二 -1:all
%   OBSTYPE: 1:伪距 2:相位 -1:all
%   flag_save: 0：not save 1:save  在当前目录下创建文件夹
%   1111版本先仅支持全部绘制

% 创建文件夹储存 按照系统划分
% 文件夹名称为   SNRRES_SYS
% 图像命名规则为 SNRRES_prn_f_OBSTYPE.png
% 另外额外有一张图片是SNRRES_all_f_OBSTYPE.png

folder = cell(5,1);
folder{1} = [class_obj.m_path,'SNRRES_GPS'];
folder{2} = [class_obj.m_path,'SNRRES_GLO'];
folder{3} = [class_obj.m_path,'SNRRES_BDS'];
folder{4} = [class_obj.m_path,'SNRRES_GAL'];
folder{5} = [class_obj.m_path,'SNRRES_QZS'];
for sys = 1:5
    if ~exist(cell2mat(folder(sys)))
        mkdir(cell2mat(folder(sys)));
    else
        rmdir(cell2mat(folder(sys)),'s');
        mkdir(cell2mat(folder(sys)));
    end
end

display_res_SNR_subP(class_obj,folder,Sys,Prn,F,flag_save);
display_res_SNR_subL(class_obj,folder,Sys,Prn,F,flag_save);

end

function [ bool ] = display_res_SNR_subP(class_obj,folder,Sys,Prn,F,flag_save)

% 进度条
 wait_h = waitbar(0,'绘制总的伪距残差与信噪比关系图像');

% 输出伪距总图像
for f = 1:2
    for sys = 1:2
        
        X = class_obj.m_index_CN0(1:class_obj.m_index_CN0_dimension(sys,f),sys,f);
        Y = class_obj.m_Pall_CN0(1:class_obj.m_index_CN0_dimension(sys,f),sys,f);
        
        filename = [cell2mat(folder(sys)),'\\SNRRES_all_',num2str(f),'_P'];
        fh = figure('Visible','off');
        plot(X,Y,'g.','MarkerSize',15);
        saveas(fh,filename,'png');
        close(fh);    
        clear X Y
        waitbar((f-1)*5+sys/10);
    end
end

 close(wait_h);
 
 % 进度条
 wait_h = waitbar(0,'绘制每颗卫星的伪距残差与信噪比关系图像');
 
% 输出伪距图像
for f =1:2
for sys = 1:5
       if sys == 5
            [~,n,~] = size(class_obj.m_SD_P);
           data_end = n;
        else
           data_end = class_obj.m_PRN0(sys+1)-1;
       end
        data_begin = class_obj.m_PRN0(sys);
        
            for sat = data_begin:data_end
                 % dimension是按照总的维数来说的 因此单颗卫星会有零值
                 X = class_obj.m_index_CN0(1:class_obj.m_index_CN0_dimension(sys,f),sys,f);
                 Y = class_obj.m_Psat_CN0(1:class_obj.m_index_CN0_dimension(sys,f),sat,f);
                 if std(Y) == 0
                     continue;
                 end
                 Locate = find(Y == 0);
                 Y(Locate) = nan;

                 [~,~,prn_char] = class_obj.findSat(sat);
                 filename = [cell2mat(folder(sys)),'\\SNRRES_',prn_char,'_',num2str(f),'_P'];
                 fh = figure('Visible','off');
                  plot(X,Y,'r.','MarkerSize',15);
                 saveas(fh,filename,'png');
                 close(fh);
                 clear X Y Locate
            end
   waitbar((f-1)*5+sys/10);
end
end
   close(wait_h);
end


function [ bool ] = display_res_SNR_subL(class_obj,folder,Sys,Prn,F,flag_save)

% 进度条
 wait_h = waitbar(0,'绘制总的相位残差与信噪比关系图像');

% 输出伪距总图像
for f = 1:2
    for sys = 1:2
        
        X = class_obj.m_index_CN0(1:class_obj.m_index_CN0_dimension(sys,f),sys,f);
        Y = class_obj.m_Lall_CN0(1:class_obj.m_index_CN0_dimension(sys,f),sys,f);
        
        filename = [cell2mat(folder(sys)),'\\SNRRES_all_',num2str(f),'_L'];
        fh = figure('Visible','off');
         plot(X,Y,'g.','MarkerSize',15);
        saveas(fh,filename,'png');
        close(fh);    
        clear X Y
        waitbar((f-1)*4+sys/8);
    end
end

 close(wait_h);
 
 % 进度条
 wait_h = waitbar(0,'绘制每颗卫星的相位残差与信噪比关系图像');
 
% 输出伪距图像
for f =1:2
for sys = 1:5
       if sys == 5
            [~,n,~] = size(class_obj.m_DD_L);
           data_end = n;
        else
           data_end = class_obj.m_PRN0(sys+1)-1;
       end
        data_begin = class_obj.m_PRN0(sys);
        
            for sat = data_begin:data_end
                 % dimension是按照总的维数来说的 因此单颗卫星会有零值
                 X = class_obj.m_index_CN0(1:class_obj.m_index_CN0_dimension(sys,f),sys,f);
                 Y = class_obj.m_Lsat_CN0(1:class_obj.m_index_CN0_dimension(sys,f),sat,f);
                 
                 if std(Y) == 0
                     continue;
                 end
                 
                 Locate = find(Y == 0);
                 Y(Locate) = nan;

                 [~,~,prn_char] = class_obj.findSat(sat);
                 filename = [cell2mat(folder(sys)),'\\SNRRES_',prn_char,'_',num2str(f),'_L'];
                 fh = figure('Visible','off');
                  plot(X,Y,'r.','MarkerSize',15);
                 saveas(fh,filename,'png');
                 close(fh);
                 clear X Y Locate
            end
   waitbar((f-1)*5+sys/10);
end
end
   close(wait_h);
end