function [bool] =  Onevecotr_P_noLLI(class_obj)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

[~,n1,f1] = size(class_obj.m_SD_P);

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
folder{1} = [class_obj.m_path,'Pvary_GPS'];
folder{2} = [class_obj.m_path,'Pvary_GLO'];
folder{3} = [class_obj.m_path,'Pvary_BDS'];
folder{4} = [class_obj.m_path,'Pvary_GAL'];
folder{5} = [class_obj.m_path,'Pvary_QZS'];
% for sys = 1:5
%     if ~exist(cell2mat(folder(sys)))
%         mkdir(cell2mat(folder(sys)));
%     else
%         rmdir(cell2mat(folder(sys)),'s');
%         mkdir(cell2mat(folder(sys)));
%     end
% end

% 高度角图像
for sys = 1:5
        for f = 1:f1

            % 伪距
            clear  output_vector filename value_y value_x LLI_sign CN0
            value_y = class_obj.m_SD_P(:,class_obj.m_PRN0(sys),f);
            value_x = class_obj.m_EL(:,class_obj.m_PRN0(sys));
            LLI_sign = class_obj.m_SatNum_NLLI(:,class_obj.m_PRN0(sys),f);
            CN0 = class_obj.m_CN0(:,class_obj.m_PRN0(sys),f);
            for i_data = class_obj.m_PRN0(sys)+1:min(class_obj.m_PRN1(sys),n1)
                value_y = [value_y;class_obj.m_SD_P(:,i_data,f)];
                value_x = [value_x;class_obj.m_EL(:,i_data)];
                LLI_sign = [LLI_sign;class_obj.m_SatNum_NLLI(:,i_data,f)];
                CN0 = [CN0;class_obj.m_CN0(:,i_data,f)];
            end
            
            Locate = find(LLI_sign ~= 0);
            value_y(Locate) = [];
            value_x(Locate) = [];
            CN0(Locate) = [];
            clear Locate;
            Locate = find(CN0 < 35);
            value_y(Locate) = [];
            value_x(Locate) = [];
            clear Locate;
            Locate = find(value_x < 40);
            value_y(Locate) = [];
            value_x(Locate) = [];
            
            [output_vector] =  OneVector(value_x,value_y);
            [vec_m,vec_n] = size(output_vector);
            if vec_m == 0 || vec_n == 0
                continue;
            end
            class_obj.m_SDP_el(1:vec_m,1:vec_n,sys,f) = output_vector;
            filename = [cell2mat(folder(sys)),'\\PEL_noLLI_',num2str(sys),'_',num2str(f)];
            ylabel_str = [cell2mat(SYSNAME(sys)),' Residual ',cell2mat(FRENAME(sys,f)),' (m)'];
            createfigure(output_vector(:,1), output_vector(:,2),filename,ylabel_str,0);
        end
end


% 信噪比图像
for sys = 1:5
        for f = 1:f1

            % 伪距
            % 伪距
            clear  output_vector filename value_y value_x LLI_sign CN0
            value_y = class_obj.m_SD_P(:,class_obj.m_PRN0(sys),f);
            value_x = class_obj.m_CN0(:,class_obj.m_PRN0(sys));
            EL = class_obj.m_EL(:,class_obj.m_PRN0(sys));
            LLI_sign = class_obj.m_SatNum_NLLI(:,class_obj.m_PRN0(sys),f);
            for i_data = class_obj.m_PRN0(sys)+1:min(class_obj.m_PRN1(sys),n1)
                value_y = [value_y;class_obj.m_SD_P(:,i_data,f)];
                value_x = [value_x;class_obj.m_CN0(:,i_data,f)];
                LLI_sign = [LLI_sign;class_obj.m_SatNum_NLLI(:,i_data,f)];
                EL = [EL;class_obj.m_EL(:,i_data)];
            end
            
            Locate = find(LLI_sign ~= 0);
            value_y(Locate) = [];
            value_x(Locate) = [];
            EL(Locate) = [];
            clear Locate;
            Locate = find(EL < 40);
            value_y(Locate) = [];
            value_x(Locate) = [];
            clear Locate;
            Locate = find(value_x < 35);
            value_y(Locate) = [];
            value_x(Locate) = [];
            clear Locate;
            
            [output_vector] =  OneVector(value_x,value_y);
            [vec_m,vec_n] = size(output_vector);
            if vec_m == 0 || vec_n == 0
                continue;
            end
            class_obj.m_SDP_el(1:vec_m,1:vec_n,sys,f) = output_vector;
            filename = [cell2mat(folder(sys)),'\\PCN0_noLLI_',num2str(sys),'_',num2str(f)];
            ylabel_str = [cell2mat(SYSNAME(sys)),' Residual ',cell2mat(FRENAME(sys,f)),' (m)'];
            createfigure(output_vector(:,1), output_vector(:,2),filename,ylabel_str,1);
        end
end

end

