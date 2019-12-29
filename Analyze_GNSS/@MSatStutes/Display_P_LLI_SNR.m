function [ bool ] = Display_P_LLI_SNR(class_obj)
%   Display_P_LLI_SNR   MSatStutes类的静态方法
%   显示LLI、单差伪距残差、SNR的变化图像
[~,n1,f1] = size(class_obj.m_SatNum_Nf);

SYSNAME = cell(5,1);
FRENAME = cell(5,2);
SYSNAME{1} = ['GPS'];
SYSNAME{2} = ['GLONASS'];
SYSNAME{3} = ['BDS'];
SYSNAME{4} = ['Galileo'];
SYSNAME{5} = ['QZSS'];

FRENAME{1,1} = ['L1'];FRENAME{1,2} = ['L2'];
FRENAME{2,1} = ['R1'];FRENAME{2,2} = ['R2'];
FRENAME{3,1} = ['B1'];FRENAME{3,2} = ['B2'];
FRENAME{4,1} = ['E1'];FRENAME{4,2} = ['E5a'];
FRENAME{5,1} = ['L1'];FRENAME{5,2} = ['L2'];


folder = cell(5,1);
folder{1} = [class_obj.m_path,'P_LLI_SNR_GPS'];
folder{2} = [class_obj.m_path,'P_LLI_SNR_GLO'];
folder{3} = [class_obj.m_path,'P_LLI_SNR_BDS'];
folder{4} = [class_obj.m_path,'P_LLI_SNR_GAL'];
folder{5} = [class_obj.m_path,'P_LLI_SNR_QZS'];
for sys = 1:5
    if ~exist(cell2mat(folder(sys)))
        mkdir(cell2mat(folder(sys)));
    else
        rmdir(cell2mat(folder(sys)),'s');
        mkdir(cell2mat(folder(sys)));
    end
end

SNR_delt = 1;

for sys = 1:5
        for f = 1:f1
 
            % 伪距
            clear  value_SD_P value_CN0 value_LLI  value_nSat filename
            clear  Onevec_P Onevec_LLI Onevec_nSat
            clear  Classfied_P_noLLI Classfied_P_LLI Classfied_nSat_noLLI Classfied_nSat_LLI
            value_SD_P = class_obj.m_SD_P(:,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),n1),f);
            value_CN0 = class_obj.m_CN0(:,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),n1),f);
            value_LLI = class_obj.m_LLI(:,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),n1),f);
            if f1 == 1
                value_nSat = class_obj.m_SatNum_Nf(:,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),n1));
            else
                value_nSat = class_obj.m_SatNum_Nf(:,class_obj.m_PRN0(sys):min(class_obj.m_PRN1(sys),n1),f);
            end
            if mean(mean(value_SD_P)) == 0
                continue;
            end
            
            % 合并
            [Onevec_P] =  OneVector(value_CN0,value_SD_P,1);
            [Onevec_LLI] =  OneVector(value_CN0,value_LLI,1);
            [Onevec_nSat] =  OneVector(value_CN0,value_nSat,1);
            
            % 过滤
            clear Locate;
            Locate = find(Onevec_LLI(:,2) > 0);
            Onevec_P_noLLI = Onevec_P;
            Onevec_nSat_noLLI = Onevec_nSat;
            Onevec_P_noLLI(Locate,:) = [];
            Onevec_nSat_noLLI(Locate,:) = [];
            
            clear Locate;
            Locate = find(Onevec_LLI(:,2) == 0);
            Onevec_P_LLI = Onevec_P;
            Onevec_nSat_LLI = Onevec_nSat;
            Onevec_P_LLI(Locate,:) = [];
            Onevec_nSat_LLI(Locate,:) = [];
            
            % 分类
            [ Classfied_P_noLLI,~,d_noLLI ] = Classfied_C( abs(Onevec_P_noLLI(:,2)),Onevec_P_noLLI(:,1),SNR_delt ,2);
            [ Classfied_P_LLI,~,d_LLI ] = Classfied_C( abs(Onevec_P_LLI(:,2)),Onevec_P_LLI(:,1),SNR_delt ,2);
            [ Classfied_nSat_noLLI,~,~ ] = Classfied_C( Onevec_nSat_noLLI(:,2),Onevec_nSat_noLLI(:,1),SNR_delt ,1);
            [ Classfied_nSat_LLI,~,~ ] = Classfied_C( Onevec_nSat_LLI(:,2),Onevec_nSat_LLI(:,1),SNR_delt,1 );
            
            clear Onevec_P_LLI  Onevec_nSat_LLI Onevec_P_noLLI  Onevec_nSat_noLLI
            
            [vec_m1,vec_n1] = size(Classfied_P_noLLI);
            [vec_m2,vec_n2] = size(Classfied_P_LLI);
            if vec_m1 == 0 && vec_n1 == 0 && vec_m2 == 0 && vec_n2 == 0
                continue;
            end
            X = Classfied_P_noLLI(:,1);
            % 有可能noLLI和LLI的维度不一致
            if d_noLLI ~= d_LLI
                delt_d = abs(d_noLLI - d_LLI);
                if  d_noLLI > d_LLI
                    X = Classfied_P_noLLI(:,1);
                    Classfied_P_LLI = [Classfied_P_noLLI(:,1),[Classfied_P_LLI(:,2);-1*ones(delt_d,1)]];
                    Classfied_nSat_LLI = [Classfied_nSat_noLLI(:,1),[Classfied_nSat_LLI(:,2);-1*ones(delt_d,1)]];
                else
                    X = Classfied_P_LLI(:,1);
                    Classfied_P_noLLI = [Classfied_P_LLI(:,1),[Classfied_P_noLLI(:,2);-1*ones(delt_d,1)]];
                    Classfied_nSat_noLLI = [Classfied_nSat_LLI(:,1),[Classfied_nSat_noLLI(:,2);-1*ones(delt_d,1)]];
                end                
            end
            
            bar_y1 = 100*Classfied_nSat_noLLI(:,2)./sum(sum(Classfied_nSat_noLLI(:,2)));
            bar_y2 = 100*Classfied_nSat_LLI(:,2)./sum(sum(Classfied_nSat_LLI(:,2)));
            
            line_Y = -10*ones(max(vec_m1,vec_m2),2);
            bar_Y = -10*ones(max(vec_m1,vec_m2),2);
            
            if vec_m1 ~= 0
              line_Y(:,1) = Classfied_P_noLLI(:,2);
              bar_Y(:,1) = bar_y1;  
            end
            
            if vec_m2 ~= 0
               line_Y(:,2) = Classfied_P_LLI(:,2);
               bar_Y(:,2) = bar_y2;  
            end
            
            filename = [cell2mat(folder(sys)),'\\PSNRLLI_',num2str(sys),'_',num2str(f)];
            ylabel_str = [cell2mat(SYSNAME(sys)),' Res ',cell2mat(FRENAME(sys,f))];
            createfigure_SNRLLI(X,bar_Y,line_Y, filename,ylabel_str,0);
        end
end


end

