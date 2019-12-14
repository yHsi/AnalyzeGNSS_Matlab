function [bool] = Init(class_obj,path,filename)
%   MSatStutes的类方法
%   更新有关读文件的变量
    class_obj.m_path = path;
    class_obj.m_filename = filename;
    class_obj.m_PriAllfile = [path,filename,'.txt'];
    if ~exist(class_obj.m_PriAllfile)
        bool = 0;
        disp('The PriAllfile is not exist!')
        return;
    end
    class_obj.m_Matfile =  [path,filename,'_class','.mat'];
    % 进度条
    wait_h = waitbar(0,'初始化参数中');
    
    if ~exist(class_obj.m_Matfile)
        MSatStutes.OpenPriallFile(class_obj);
    else
        Mat_obj = load(class_obj.m_Matfile); % 仅将mat读取出来是无法修改类成员的
        class_obj.m_SD_P = Mat_obj.class_obj.m_SD_P;
        class_obj.m_DD_L = Mat_obj.class_obj.m_DD_L;
        class_obj.m_CN0 = Mat_obj.class_obj.m_CN0;
        class_obj.m_GPSTIME = Mat_obj.class_obj.m_GPSTIME;
        class_obj.m_EL = Mat_obj.class_obj.m_EL;
        class_obj.m_Validsat = Mat_obj.class_obj.m_Validsat;
        class_obj.m_ValidsatAll = Mat_obj.class_obj.m_ValidsatAll;
        
        class_obj.m_SatNum_n1 = Mat_obj.class_obj.m_SatNum_n1;
        class_obj.m_SatNum_n2 = Mat_obj.class_obj.m_SatNum_n2;
        class_obj.m_SatNum_nn = Mat_obj.class_obj.m_SatNum_nn;
        class_obj.m_SatNum_N = Mat_obj.class_obj.m_SatNum_N;
        
        class_obj.m_SatNum_Nf = Mat_obj.class_obj.m_SatNum_Nf;
        class_obj.m_SatNum_Np = Mat_obj.class_obj.m_SatNum_Np;
        class_obj.m_SatNum_Nl = Mat_obj.class_obj.m_SatNum_Nl;
        
        class_obj.m_SatNum_NLLI = Mat_obj.class_obj.m_SatNum_NLLI;
        class_obj.m_LLI_P = Mat_obj.class_obj.m_LLI_P;  
        class_obj.m_LLI_CN0 = Mat_obj.class_obj.m_LLI_CN0;
        class_obj.m_LLI_el = Mat_obj.class_obj.m_LLI_el;
        
        class_obj.m_LLI_P_SNR_G_1_n = Mat_obj.class_obj.m_LLI_P_SNR_G_1_n;
        class_obj.m_LLI_P_SNR_G_1_y = Mat_obj.class_obj.m_LLI_P_SNR_G_1_y;
        class_obj.m_LLI_P_SNR_R_1_n = Mat_obj.class_obj.m_LLI_P_SNR_R_1_n;
        class_obj.m_LLI_P_SNR_R_1_y = Mat_obj.class_obj.m_LLI_P_SNR_R_1_y;
        class_obj.m_LLI_P_SNR_E_1_n = Mat_obj.class_obj.m_LLI_P_SNR_E_1_n;
        class_obj.m_LLI_P_SNR_E_1_y = Mat_obj.class_obj.m_LLI_P_SNR_E_1_y;
        class_obj.m_LLI_P_SNR_C_1_n = Mat_obj.class_obj.m_LLI_P_SNR_C_1_n;
        class_obj.m_LLI_P_SNR_C_1_y = Mat_obj.class_obj.m_LLI_P_SNR_C_1_y;
        class_obj.m_LLI_P_SNR_J_1_n = Mat_obj.class_obj.m_LLI_P_SNR_J_1_n;
        class_obj.m_LLI_P_SNR_J_1_y = Mat_obj.class_obj.m_LLI_P_SNR_J_1_y;
        
        class_obj.m_LLI_P_SNR_G_2_n = Mat_obj.class_obj.m_LLI_P_SNR_G_2_n;
        class_obj.m_LLI_P_SNR_G_2_y = Mat_obj.class_obj.m_LLI_P_SNR_G_2_y;
        class_obj.m_LLI_P_SNR_R_2_n = Mat_obj.class_obj.m_LLI_P_SNR_R_2_n;
        class_obj.m_LLI_P_SNR_R_2_y = Mat_obj.class_obj.m_LLI_P_SNR_R_2_y;
        class_obj.m_LLI_P_SNR_E_2_n = Mat_obj.class_obj.m_LLI_P_SNR_E_2_n;
        class_obj.m_LLI_P_SNR_E_2_y = Mat_obj.class_obj.m_LLI_P_SNR_E_2_y;
        class_obj.m_LLI_P_SNR_C_2_n = Mat_obj.class_obj.m_LLI_P_SNR_C_2_n;
        class_obj.m_LLI_P_SNR_C_2_y = Mat_obj.class_obj.m_LLI_P_SNR_C_2_y;
        class_obj.m_LLI_P_SNR_J_2_n = Mat_obj.class_obj.m_LLI_P_SNR_J_2_n;
        class_obj.m_LLI_P_SNR_J_2_y = Mat_obj.class_obj.m_LLI_P_SNR_J_2_y;
    end
    bool = 1;
    waitbar(100);
    close(wait_h);
end

