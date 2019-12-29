function [ bool ] = SatNumStatistics( class_obj )
path_txt = [class_obj.m_path,'观测整体质量评价文本'];
if ~exist(path_txt)
   mkdir(path_txt);
else
   rmdir(path_txt,'s');
   mkdir(path_txt);
end
path_txt = [path_txt,'\\观测整体质量评价文本.txt'];
% 统计各个系统，每颗卫星每个频率数据出现的比例
    SatNumStatistics1(class_obj,path_txt);
% 统计各个系统，每颗卫星每个频率伪距、相位观测值出现的比例
    SatNumStatistics2(class_obj,path_txt);
% 绘制不同卫星系统卫星数目的时序图。
   % SatNumStatistics3(class_obj);
% 统计每个卫星系统、每个频率的信噪比平均值与标准差
    SatNumStatistics4(class_obj,path_txt);
% 统计每个卫星系统、每个频率的LLI标志出现次数的平均值以及出现的比例
    SatNumStatistics5(class_obj,path_txt);
% 绘制LLI（残差-SNR）图散点
    %SatNumStatistics6(class_obj);
% 绘制LLI（残差-SNR）柱状图
   % SatNumStatistics7(class_obj);
end


function [ bool ] = SatNumStatistics1( class_obj ,path_txt)
    m_sum_n1 = sum(class_obj.m_SatNum_n1);
    m_sum_n2 = sum(class_obj.m_SatNum_n2);
    m_sum_nn = sum(class_obj.m_SatNum_nn);
    [~,n1] = size(m_sum_n1);
    [~,n2] = size(m_sum_n2);
    [~,nn] = size(m_sum_nn);
    class_obj.m_rate_n1_sat = m_sum_n1./class_obj.m_SatNum_N(1,1:n1);
    class_obj.m_rate_n2_sat = m_sum_n2./class_obj.m_SatNum_N(1,1:n2);
    class_obj.m_rate_nn_sat = m_sum_nn./class_obj.m_SatNum_N(1,1:nn);
    for sys = 1:5
        

        
        % 卫星平均数
        class_obj.m_ValidsatMean(1,sys)=mean(class_obj.m_ValidsatAll(:,sys));
        % 卫星数标准差 
        class_obj.m_ValidsatStd(1,sys)=std(class_obj.m_ValidsatAll(:,sys),1);
        % 统计各个系统，每颗卫星每个频率数据出现的比例
        if n1 >= class_obj.m_PRN0(sys)
            clear ALL;
            if class_obj.m_PRN1(sys) > n1
                index_end = n1;
            else
                index_end = class_obj.m_PRN1(sys);
            end
            ALL = class_obj.m_SatNum_N(1,class_obj.m_PRN0(sys):index_end);
            ALL(isnan(ALL))=[];
            if isempty(m_sum_n1) || sum(m_sum_n1) == 0
            class_obj.m_mean_rate_n1(sys) = 0 ;
            else
            A = m_sum_n1(1,class_obj.m_PRN0(sys):index_end);
            A(isnan(A))=[];
            class_obj.m_mean_rate_n1(sys) = sum(A)./sum(ALL)*100;
            end
        end
        
        if n2 >= class_obj.m_PRN0(sys)
            clear ALL;
            if class_obj.m_PRN1(sys) > n2
                index_end = n2;
            else
                index_end = class_obj.m_PRN1(sys);
            end
            ALL = class_obj.m_SatNum_N(1,class_obj.m_PRN0(sys):index_end);
            ALL(isnan(ALL))=[];
            if isempty(m_sum_n2) || sum(m_sum_n2) == 0
            class_obj.m_mean_rate_n2(sys) = 0;
            else
            B = m_sum_n2(1,class_obj.m_PRN0(sys):index_end);
            B(isnan(B))=[];
            class_obj.m_mean_rate_n2(sys) = sum(B)./sum(ALL)*100;           
            end
        end

        if nn >= class_obj.m_PRN0(sys)
            clear ALL;
            if class_obj.m_PRN1(sys) > nn
                index_end = nn;
            else
                index_end = class_obj.m_PRN1(sys);
            end
            ALL = class_obj.m_SatNum_N(1,class_obj.m_PRN0(sys):index_end);
            ALL(isnan(ALL))=[];
            if isempty(m_sum_nn) || sum(m_sum_nn) == 0
            class_obj.m_mean_rate_nn(sys) = 0 ;
            else
            C = m_sum_nn(1,class_obj.m_PRN0(sys):index_end);
            C(isnan(C))=[];
            class_obj.m_mean_rate_nn(sys) = sum(C)./sum(ALL)*100;
            end
        end
    end
    
    fp = fopen(path_txt,'a');
    fprintf(fp,'%.4f %.4f %.4f %.4f %.4f\r\n',class_obj.m_ValidsatMean);
    fprintf(fp,'%.4f %.4f %.4f %.4f %.4f\r\n',class_obj.m_ValidsatStd);
    fprintf(fp,'\r\n');
    fprintf(fp,'%.4f %.4f %.4f %.4f %.4f\r\n',class_obj.m_mean_rate_n1);
    fprintf(fp,'%.4f %.4f %.4f %.4f %.4f\r\n',class_obj.m_mean_rate_n2);
    fprintf(fp,'%.4f %.4f %.4f %.4f %.4f\r\n',class_obj.m_mean_rate_nn);
    fprintf(fp,'\r\n');
    fclose(fp);
end    

function [ bool ] = SatNumStatistics2( class_obj,path_txt )
    m_sum_nf = sum(class_obj.m_SatNum_Nf);
    m_sum_np = sum(class_obj.m_SatNum_Np);
    m_sum_nl = sum(class_obj.m_SatNum_Nl);
    m_sum_nd = sum(class_obj.m_SatNum_ND);
    [~,n1,~] = size(m_sum_np);
    [~,n2,~] = size(m_sum_nl);
    [~,n3,~] = size(m_sum_nd);
    [~,~,f1] = size(m_sum_nf);
%     if f1 == 1
%         ADD = zeros(1,140,1);
%         m_sum_np = cat(3,m_sum_np,ADD);
%         m_sum_nl = cat(3,m_sum_nl,ADD);
%         m_sum_nf = cat(3,m_sum_nf,ADD);
%     end
    class_obj.m_rate_np = m_sum_np./m_sum_nf(1,1:n1,:);
    class_obj.m_rate_nl = m_sum_nl./m_sum_nf(1,1:n2,:);
    class_obj.m_rate_nd = m_sum_nd./m_sum_nf(1,1:n3,:);
    for sys = 1:5
        for f = 1:f1
        % 伪距
        if ~isempty(m_sum_np(1,:,f))
            clear ALL;
            if ~isempty(m_sum_nf(1,:,f))
                ALL = m_sum_nf(1,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),n1),f);
            else
                ALL = 0;
            end
            
            A = m_sum_np(1,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),n1),f);
            A(isnan(A))=[];
            class_obj.m_mean_rate_np(sys,f) = sum(A)./sum(ALL)*100;
        else
            class_obj.m_mean_rate_np(sys,f) = 0;
        end
        
        % 相位
        if ~isempty(m_sum_nl(1,:,f))
            clear ALL;
            if ~isempty(m_sum_nf(1,:,f))
                ALL = m_sum_nf(1,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),n2),f);
            else
                ALL = 0;
            end
            
            B = m_sum_nl(1,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),n2),f);
            B(isnan(B))=[];
            class_obj.m_mean_rate_nl(sys,f) = sum(B)./sum(ALL)*100;
        else
            class_obj.m_mean_rate_nl(sys,f) = 0;
        end
        
        % 多普勒
        if ~isempty(m_sum_nd(1,:,f))
            clear ALL;
            if ~isempty(m_sum_nd(1,:,f))
                ALL = m_sum_nd(1,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),n3),f);
            else
                ALL = 0;
            end
            
            B = m_sum_nd(1,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),n3),f);
            B(isnan(B))=[];
            class_obj.m_mean_rate_nd(sys,f) = sum(B)./sum(ALL)*100;
        else
            class_obj.m_mean_rate_nd(sys,f) = 0;
        end
        
        
        end
    end
    
    fp = fopen(path_txt,'a');
    for f = 1:f1
         fprintf(fp,'%.4f %.4f %.4f %.4f %.4f\r\n',class_obj.m_mean_rate_np(:,f));
    end
    for f = 1:f1
         fprintf(fp,'%.4f %.4f %.4f %.4f %.4f\r\n',class_obj.m_mean_rate_nl(:,f));
    end
    for f = 1:f1
         fprintf(fp,'%.4f %.4f %.4f %.4f %.4f\r\n',class_obj.m_mean_rate_nd(:,f));
    end
    fprintf(fp,'\r\n');
    fclose(fp);
end
%% 卫星数目时序图
function [ bool ] = SatNumStatistics3( class_obj )
path = [class_obj.m_path,'卫星数时序图'];
if ~exist(path)
   mkdir(path);
else
   rmdir(path,'s');
   mkdir(path);
end
for sys = 1:5
    if sys == 1
       title1 = 'GPS'; 
    end
    if sys == 2
       title1 = 'GLONASS'; 
    end
    if sys == 3
       title1 = 'BDS'; 
    end
    if sys == 4
       title1 = 'Galileo'; 
    end
    if sys == 5
       title1 = 'QZSS'; 
    end
    fh = figure();
    plot(class_obj.m_GPSTIME,class_obj.m_ValidsatAll(:,sys),'->');
    title([title1,'卫星数时序图']);
    ylabel('卫星数');
    xlabel('GPS Time/s');
    filename = [path,'\\',title1];
    saveas(fh,filename,'png');
end
end

function [ bool ] = SatNumStatistics4( class_obj ,path_txt)
    %标准差
    [~,nsat,~] = size(class_obj.m_CN0);
    
    for sys = 1:5
        for f = 1:2
            if ~isempty(class_obj.m_CN0(:,:,f))
                
            B = class_obj.m_CN0(:,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),nsat),f);
            C = [];
            [m,n] = size(B);
            for i = 1:n
                for j = 1:m
                   if B(j,i) ~= 0 
                      C=[C B(j,i)];
                   end
                end
            end
            class_obj.m_CN0_std(sys,f) = std(C,1);
            class_obj.m_CN0_mean(sys,f) = mean(C);
            else
            class_obj.m_CN0_std(sys,f) = 0;
            class_obj.m_CN0_mean(sys,f) = 0;
            end
        end
    end
    fp = fopen(path_txt,'a');
    fprintf(fp,'%.4f %.4f %.4f %.4f %.4f\r\n',class_obj.m_CN0_mean(:,1));
    fprintf(fp,'%.4f %.4f %.4f %.4f %.4f\r\n',class_obj.m_CN0_std(:,1));
    fprintf(fp,'%.4f %.4f %.4f %.4f %.4f\r\n',class_obj.m_CN0_mean(:,2));
    fprintf(fp,'%.4f %.4f %.4f %.4f %.4f\r\n',class_obj.m_CN0_std(:,2));
    fprintf(fp,'\r\n');
    fclose(fp);
end

function [ bool ] = SatNumStatistics5( class_obj ,path_txt)
    m_sum_NLLI = sum(class_obj.m_SatNum_NLLI);
    m_sum_nf = sum(class_obj.m_SatNum_Nf);
    [~,nsat_NLLI,~] = size(m_sum_NLLI);
    [~,nsat_nf,f1] = size(m_sum_nf);
    nsat = min(nsat_nf,nsat_NLLI);
%     if f1 == 1
%        ADD = zeros(1,140,1);
%        m_sum_nf = cat(3,m_sum_nf,ADD);
%     end
    m_lli_rate = m_sum_NLLI(1,1:nsat,:)./m_sum_nf(1,1:nsat,:);
    m_P = class_obj.m_LLI_P(1,1:nsat,:)./m_sum_NLLI(1,1:nsat,:);
    m_CN0 = class_obj.m_LLI_CN0(1,1:nsat,:)./m_sum_NLLI(1,1:nsat,:);
    m_el = class_obj.m_LLI_el(1,1:nsat,:)./m_sum_NLLI(1,1:nsat,:);
    for sys = 1:5
        for f = 1:f1
            if ~isempty(m_sum_NLLI(1,:,f))
            A = m_sum_NLLI(1,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),nsat),f);
            A(find(A==0)) = [];
            class_obj.m_LLI_nsum(sys,f) = sum(A); 
            else
            class_obj.m_LLI_nsum(sys,f) = 0;    
            end
            
            if ~isempty(m_lli_rate(1,:,f))
            B = m_sum_nf(1,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),nsat),f);
            B(isnan(B))=[];
            class_obj.m_LLI_nrate(sys,f) = class_obj.m_LLI_nsum(sys,f)./sum(B)*100;
            else
            class_obj.m_LLI_nrate(sys,f) = 0;
            end
            
            if ~isempty(m_P(1,:,f))
            C = class_obj.m_LLI_P(1,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),nsat),f);
            C(isnan(C))=[];
            class_obj.m_LLI_P_mean(sys,f) = sum(C)/class_obj.m_LLI_nsum(sys,f);
            else
            class_obj.m_LLI_P_mean(sys,f) = 0;
            end
            
            if ~isempty(m_CN0(1,:,f))
            D = class_obj.m_LLI_CN0(1,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),nsat),f);
            D(isnan(D))=[];
            class_obj.m_LLI_CN0_mean(sys,f) = sum(D)./class_obj.m_LLI_nsum(sys,f);
            else
            class_obj.m_LLI_CN0_mean(sys,f) = 0 ;    
            end
            
            if ~isempty(m_el(1,:,f))
            E = class_obj.m_LLI_el(1,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),nsat),f);
            E(isnan(E))=[];
            class_obj.m_LLI_EL_mean(sys,f) = sum(E)./class_obj.m_LLI_nsum(sys,f);
            else
            class_obj.m_LLI_EL_mean(sys,f) = 0 ;
            end
        end
    end
    
    fp = fopen(path_txt,'a');
    for f=1:f1
        fprintf(fp,'%g %g %g %g %g\r\n', class_obj.m_LLI_nsum(:,f));
    end
    
    for f=1:f1
        fprintf(fp,'%g %g %g %g %g\r\n', class_obj.m_LLI_nrate(:,f));
    end

    for f=1:f1
        fprintf(fp,'%g %g %g %g %g\r\n', class_obj.m_LLI_P_mean(:,f));
    end
    
    for f=1:f1
        fprintf(fp,'%g %g %g %g %g\r\n', class_obj.m_LLI_CN0_mean(:,f));
    end
    
    for f=1:f1
        fprintf(fp,'%g %g %g %g %g\r\n', class_obj.m_LLI_EL_mean(:,f));
    end
    
    fprintf(fp,'\r\n');
    fclose(fp);
end

function [ bool ] = SatNumStatistics6( class_obj )
path = [class_obj.m_path,'伪距残差信噪比关系图'];
if ~exist(path)
   mkdir(path);
else
   rmdir(path,'s');
   mkdir(path);
end
   if ~isempty(class_obj.m_LLI_P_SNR_G_1_n)
   title1 = '伪距残差信噪比关系图-频率1-GPS';
   plot_LLI_P_SNR(class_obj.m_LLI_P_SNR_G_1_y,class_obj.m_LLI_P_SNR_G_1_n,title1,path);
   end
   if ~isempty(class_obj.m_LLI_P_SNR_R_1_n)
   title1 = '伪距残差信噪比关系图-频率1-GLO';
   plot_LLI_P_SNR(class_obj.m_LLI_P_SNR_R_1_y,class_obj.m_LLI_P_SNR_R_1_n,title1,path);
   end
   if ~isempty(class_obj.m_LLI_P_SNR_C_1_n)
   title1 = '伪距残差信噪比关系图-频率1-BDS';
   plot_LLI_P_SNR(class_obj.m_LLI_P_SNR_C_1_y,class_obj.m_LLI_P_SNR_C_1_n,title1,path);
   end
   if ~isempty(class_obj.m_LLI_P_SNR_E_1_n)
   title1 = '伪距残差信噪比关系图-频率1-GAL';
   plot_LLI_P_SNR(class_obj.m_LLI_P_SNR_E_1_y,class_obj.m_LLI_P_SNR_E_1_n,title1,path);
   end
   if ~isempty(class_obj.m_LLI_P_SNR_J_1_n)
   title1 = '伪距残差信噪比关系图-频率1-QZS';
   plot_LLI_P_SNR(class_obj.m_LLI_P_SNR_J_1_y,class_obj.m_LLI_P_SNR_J_1_n,title1,path);
   end
   
   if ~isempty(class_obj.m_LLI_P_SNR_G_2_n)
   title1 = '伪距残差信噪比关系图-频率2-GPS';
   plot_LLI_P_SNR(class_obj.m_LLI_P_SNR_G_2_y,class_obj.m_LLI_P_SNR_G_2_n,title1,path);
   end
   if ~isempty(class_obj.m_LLI_P_SNR_R_2_n)
   title1 = '伪距残差信噪比关系图-频率2-GLO';
   plot_LLI_P_SNR(class_obj.m_LLI_P_SNR_R_2_y,class_obj.m_LLI_P_SNR_R_2_n,title1,path);
   end
   if ~isempty(class_obj.m_LLI_P_SNR_C_2_n)
   title1 = '伪距残差信噪比关系图-频率2-BDS';
   plot_LLI_P_SNR(class_obj.m_LLI_P_SNR_C_2_y,class_obj.m_LLI_P_SNR_C_2_n,title1,path);
   end
   %title1 = '伪距残差信噪比关系图-频率2-GAL';
   %plot_LLI_P_SNR(class_obj.m_LLI_P_SNR_E_2_y,class_obj.m_LLI_P_SNR_E_2_n,title1,path);
   if ~isempty(class_obj.m_LLI_P_SNR_J_2_n)
   title1 = '伪距残差信噪比关系图-频率2-QZS';
   plot_LLI_P_SNR(class_obj.m_LLI_P_SNR_J_2_y,class_obj.m_LLI_P_SNR_J_2_n,title1,path);
   end
end

function [ bool ] =  plot_LLI_P_SNR(X1,X2,title1,path)
    fh = figure();
    t = 0;
    if ~isnan(X1)
        locate_1 = find(X1(:,1)==0);
        X1(locate_1,:)=[];
        plot(X1(:,1),X1(:,2),'>');
        hold on;
        t = 1;
    end
    if ~isnan(X2)
        locate_2 = find(X2(:,1)==0);
        X2(locate_2,:)=[];
        plot(X2(:,1),X2(:,2),'<');
        t = t + 2;
    end
    hold off;
    if t == 1
        legend('LLI');
    end
    if t == 2
        legend('no LLI');
    end
    if t == 3
        legend('LLI','no LLI');
    end
    title(title1);
    xlabel('伪距残差');
    ylabel('载噪比');
    filename = [path,'\\',title1];
    saveas(fh,filename,'png');
end
function [ bool ] = SatNumStatistics7( class_obj )
   path = [class_obj.m_path,'LLI-P-SNR柱状图'];
if ~exist(path)
   mkdir(path);
else
   rmdir(path,'s');
   mkdir(path);
end
if ~isempty(class_obj.m_LLI_P_SNR_G_1_n)
    title1 = 'LLI标志-伪距残差-信噪比关系图-频率1-GPS';
    plot_nLLI_P_SNR(class_obj.m_LLI_P_SNR_G_1_y,class_obj.m_LLI_P_SNR_G_1_n,title1,path);
end
if ~isempty(class_obj.m_LLI_P_SNR_R_1_n)
    title1 = 'LLI标志-伪距残差-信噪比关系图-频率1-GLO';
    plot_nLLI_P_SNR(class_obj.m_LLI_P_SNR_R_1_y,class_obj.m_LLI_P_SNR_R_1_n,title1,path);
end
if ~isempty(class_obj.m_LLI_P_SNR_C_1_n)
    title1 = 'LLI标志-伪距残差-信噪比关系图-频率1-BDS';
    plot_nLLI_P_SNR(class_obj.m_LLI_P_SNR_C_1_y,class_obj.m_LLI_P_SNR_C_1_n,title1,path);
end
if ~isempty(class_obj.m_LLI_P_SNR_E_1_n)
    title1 = 'LLI标志-伪距残差-信噪比关系图-频率1-GAL';
    plot_nLLI_P_SNR(class_obj.m_LLI_P_SNR_E_1_y,class_obj.m_LLI_P_SNR_E_1_n,title1,path);
end
if ~isempty(class_obj.m_LLI_P_SNR_J_1_n)
    title1 = 'LLI标志-伪距残差-信噪比关系图-频率1-QZS';
    plot_nLLI_P_SNR(class_obj.m_LLI_P_SNR_J_1_y,class_obj.m_LLI_P_SNR_J_1_n,title1,path);
end
if ~isempty(class_obj.m_LLI_P_SNR_G_2_n)
    title1 = 'LLI标志-伪距残差-信噪比关系图-频率2-GPS';
    plot_nLLI_P_SNR(class_obj.m_LLI_P_SNR_G_2_y,class_obj.m_LLI_P_SNR_G_2_n,title1,path);
end
if ~isempty(class_obj.m_LLI_P_SNR_R_2_n)
    title1 = 'LLI标志-伪距残差-信噪比关系图-频率2-GLO';
    plot_nLLI_P_SNR(class_obj.m_LLI_P_SNR_R_2_y,class_obj.m_LLI_P_SNR_R_2_n,title1,path);
end
if ~isempty(class_obj.m_LLI_P_SNR_C_2_n)
    title1 = 'LLI标志-伪距残差-信噪比关系图-频率2-BDS';
    plot_nLLI_P_SNR(class_obj.m_LLI_P_SNR_C_2_y,class_obj.m_LLI_P_SNR_C_2_n,title1,path);
end
    %title1 = 'LLI标志-伪距残差-信噪比关系图-频率2-GAL';
    %plot_nLLI_P_SNR(class_obj.m_LLI_P_SNR_E_2_y,class_obj.m_LLI_P_SNR_E_2_n,title1,path);
if ~isempty(class_obj.m_LLI_P_SNR_J_2_n)
    title1 = 'LLI标志-伪距残差-信噪比关系图-频率2-QZS';
    plot_nLLI_P_SNR(class_obj.m_LLI_P_SNR_J_2_y,class_obj.m_LLI_P_SNR_J_2_n,title1,path);
end
end
function [ bool ] = plot_nLLI_P_SNR(A1,B1,title1,path)
if ~isempty(A1)   
    X1 = [abs(A1(:,1)) A1(:,2)] ;
else
    X1 = [];
end
if ~isempty(B1)  
    X2 = [abs(B1(:,1)) B1(:,2)] ;
else
    X2 = [];
end

   if ~isempty(X1)
       locate_1 = find(X1(:,1)==0);
       X1(locate_1,:)=[];
   end
   if ~isempty(X2)
       locate_2 = find(X2(:,1)==0);
       X2(locate_2,:)=[];
   end
   if isempty(X1)
      X1 = zeros(2,2); 
   end
   if isempty(X2)
      X2 = zeros(2,2); 
   end
   X1 = sortrows(X1,2);
   X2 = sortrows(X2,2);
   tabX1 = tabulate(X1(:,2));
   tabX2 = tabulate(X2(:,2));
   min_X1 = min(X1(:,2));
   max_X1 = max(X1(:,2));
   min_X2 = min(X2(:,2));
   max_X2 = max(X2(:,2));
   
   min_X = min(min_X1,min_X2);
   if min_X == 0
      min_X = max(min_X1,min_X2); 
   end
   max_X = max(max_X1,max_X2);
   [m1,~,~] = size(tabX1);
   [m2,~,~] = size(tabX2);
   if max_X > m2
      tabX2(max_X,1:3) = [max_X 0 0];
   end
   if max_X > m1
      tabX1(max_X,1:3) = [max_X 0 0];
   end
   
   if min_X == 0 || max_X == 0
       min_X = 1;
       max_X = 2;
   end
   tabX1 = tabX1(min_X:max_X,:);
   tabX2 = tabX2(min_X:max_X,:);

   plotX = [tabX1(:,3) tabX2(:,3)];
   
   for j=min_X:max_X
       A = X1(find(X1(:,2)==j));
       B = X2(find(X2(:,2)==j));
       plotY1(j-min_X+1,1)=mean(A);
       plotY1(j-min_X+1,2)=mean(B);
   end
   plotX1 = 1:max_X-min_X+1;
   fh = figure();
   [hAxes,hBar,hLine]=plotyy(plotX1,plotX,plotX1,plotY1,'bar','plot');
   set(hLine(1),'color',[1,0,0],'LineWidth',1,'Marker','*');
   set(hLine(2),'color',[0,0,1],'LineWidth',1,'Marker','*');
for i = 1:length(plotX1)
    text(i-0.3,plotX(i,1),num2str(tabX1(i,3),'%.1f'),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
    text(i+0.3,plotX(i,2),num2str(tabX2(i,3),'%.1f'),...
    'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
end
   grid on;
   set(gca,'xtick',1:max_X-min_X+1,'xticklabel',tabX2(:,1));
   legend(hBar,'LLI','no LLI'); 
   legend(hLine,'LLI','no LLI'); 
   xlabel('C/N0(dBHz)');
   ylabel(hAxes(1),'Percentage(%)','FontSize',20);
   ylabel(hAxes(2),'Absolute pseudorange residuals(m)','FontSize',20);
   set(fh,'PaperUnits','inches','PaperPosition',[0 0 10 5])
   filename = [path,'\\',title1];
   saveas(fh,filename,'png');
end