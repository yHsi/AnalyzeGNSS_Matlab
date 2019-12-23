classdef MSatStutes < handle
    % MSatStutes
    % 由pri_all 中得到的 卫星状态 
    
    % 定义常量
    properties (Constant)
    m_NSATGPS = 32;   % GPS系统的卫星数
    m_NSATGLO = 32;   % GLO系统的卫星数
    m_NSATBDS = 37;   % BDS系统的卫星数
    m_NSATGAL = 36;   % GAL系统的卫星数
    m_NSATQZS = 4;
    m_SYSGPS = 1;
    m_SYSGLO = 2;
    m_SYSBDS = 3;
    m_SYSGAL = 4;
    m_SYSQAZ = 5;
    m_NFREQ = 3;
    m_PRN0 = [1;33;65;102;138];
    m_PRN1 = [32;64;101;137;140];
    end
    
    % 原始观测数据
    properties
    m_GPSTIME;
    m_CN0;   % 三维数组 [time,sat,f]
    m_CN0_mean; %每个卫星系统、每个频率的信噪比平均值
    m_CN0_std; %每个卫星系统、每个频率的信噪比标准差
    m_SD_P;  % 三维数组 [time,sat,f]
    m_DD_L;  % 三维数组 [time,sat,f]
    m_EL;    % 三维数组 [time,sat,f]
    m_LLI;   % 三维数组 [time,sat,f]
    m_LLI_P;   %LLI标志不为0时的相位残差和 [1,sat,f]
    m_LLI_CN0; %LLI标志不为0时的载噪比和 [1,sat,f]
    m_LLI_el;  %LLI标志不为0时的高度角和 [1,sat,f]
    m_LLI_P_SNR_G_1_y;
    m_LLI_P_SNR_G_1_n;
    m_LLI_P_SNR_R_1_y;
    m_LLI_P_SNR_R_1_n;
    m_LLI_P_SNR_E_1_y;
    m_LLI_P_SNR_E_1_n;
    m_LLI_P_SNR_C_1_y;
    m_LLI_P_SNR_C_1_n;
    m_LLI_P_SNR_J_1_y;
    m_LLI_P_SNR_J_1_n;
    m_LLI_P_SNR_G_2_y;
    m_LLI_P_SNR_G_2_n;
    m_LLI_P_SNR_R_2_y;
    m_LLI_P_SNR_R_2_n;
    m_LLI_P_SNR_E_2_y;
    m_LLI_P_SNR_E_2_n;
    m_LLI_P_SNR_C_2_y;
    m_LLI_P_SNR_C_2_n;
    m_LLI_P_SNR_J_2_y;
    m_LLI_P_SNR_J_2_n;
    m_Validsat; % 三维数组 [time,sys,f]
    m_ValidsatAll; %历元观测卫星数
    m_ValidsatMean; %卫星数平均值
    m_ValidsatStd; %卫星数标准差
    m_SatNum_n1; %频率1有数据的卫星
    m_SatNum_n2; %频率2有数据的卫星
    m_SatNum_nn; %频率1/2都有数据的卫星
    m_SatNum_N; %某卫星出现的历元数
    m_SatNum_NLLI; %LLI标志出现的次数[time,sat,f]
    m_rate_n1;
    m_rate_n2;
    m_rate_nn;
    m_rate_n1_sat;
    m_rate_n2_sat;
    m_rate_nn_sat;
    m_mean_rate_n1;
    m_mean_rate_n2;
    m_mean_rate_nn;
    
    m_SatNum_Nf; %某颗卫星某个频率有观测值出现的历元数目
    m_SatNum_Np; %该颗卫星该频率伪距出现的次数
    m_SatNum_Nl; %相位次数
    m_SatNum_ND; %多普勒测试
    m_rate_np;
    m_rate_nl;
    m_rate_nd;
    m_mean_rate_np;
    m_mean_rate_nl;
    m_mean_rate_nd;
    
    m_LLI_nsum;
    m_LLI_nrate;
    m_LLI_P_mean;
    m_LLI_CN0_mean;
    m_LLI_EL_mean;
    end
    
    % 文件读取
    properties
    m_path = '';
    m_filename = '';
    m_PriAllfile = '';
    m_Matfile = '';
    m_beginTime = 0;
    m_endTime = 0;
    end
    
    % CN0分析结果
    properties
    m_index_CN0_dimension;  % 二维数组 [sys,f]
    m_index_CN0;  % 三维数组 [index,sys,f]
    m_Pall_CN0;       % 三维数组 [index,sys,f]
    m_Psat_CN0;   % 三维数组 [index,sat,obstype]
    m_Lall_CN0;       % 三维数组 [index,sys,f]
    m_Lsat_CN0;   % 三维数组 [index,sat,f]    
    end
    
    % 载噪比-残差（X-Y）：曲线拟合结果
    properties
    m_Pall_CN0_model1;  %%model1:y=a*e^(-b*x)+c output:a b c 三维数组[output,sys,f]
    m_Lall_CN0_model1;  %%model1:y=a*e^(-b*x)+c output:a b c 三维数组[output,sys,f]
    
    m_Pall_CN0_model2;  %%model2 : y=sqrt(a+(1-a)*(x-min_SNR)/(max_SNR-min_SNR)) output:a 三维数组[output,sys,f]
    m_Lall_CN0_model2;
    
    m_Pall_CN0_model3;  %%model2 : y=sqrt(a+(1-a)*(x-min_SNR)/(max_SNR-min_SNR)) output:a 三维数组[output,sys,f]
    m_Lall_CN0_model3;
    
    m_Pall_CN0_model4;
    end
    
    % el分析结果
    properties
    m_index_el_dimension;  % 二维数组 [sys,f]
    m_index_el;  % 三维数组 [index,sys,f]
    m_Pall_el;       % 三维数组 [index,sys,f]
    m_Psat_el;   % 三维数组 [index,sat,f]
    m_Lall_el;       % 三维数组 [index,sys,f]
    m_Lsat_el;   % 三维数组 [index,sat,f]   
    m_SNRsat_el;
    m_SNRall_el;
    end
    
    % 计算信息
    properties
    m_mean;  % 可用卫星数、信噪比 [type,sys,f]
    m_std;   % 可用卫星数、信噪比 [ytpe,sys,f]
    m_mean_res; % 平均残差 [type,sat,f]
    m_std_res; % 残差标准差 [type,sat,f]
    end
    
    % 动态函数
    methods 
      class_obj =  Init(class_obj,path,filename,beginTime,endTime); % 初始化相关参数
      bool = display_time_SNR_el(class_obj,sys,prn,f,OBSTYPE,flag_save); % 绘制残差与SNR el的序列图 
      bool = display_sat_mean_std(class_obj,sys,OBSTYPE,flag_save); % 绘制卫星的残差标准差和均值 
      bool = display_res_SNR(class_obj,sys,prn,f,OBSTYPE,flag_save); % 绘制卫星的残差与信噪比的关系 
      [prn_insys,sys,prn_char] = findSat(class_obj,prn);
    end
    
    % 静态函数
    methods (Static)
      bool =  OpenPriallFile(class_obj);
      bool =  Classfied_P(class_obj,SNR_delt,EL_delt);
      bool =  Classfied_L(class_obj,SNR_delt,EL_delt);
      bool =  Classfied_SNR(class_obj,EL_delt)
      bool =  CacluteMsg_SNR_Vsat(class_obj);
      bool =  CacluteMsg_Res(class_obj);
      bool =  Curve_Fitting_Model1(class_obj);
      bool =  Curve_Fitting_Model2(class_obj);
      bool =  Curve_Fitting_Model3(class_obj);
      bool =  Curve_Fitting_Model4(class_obj);
      bool =  SatNumStatistics(class_obj);
    end
    
    
end

