%% 读取验前残差文件 .txt
% 12.20日修改 修改单频情况下的BUG

%% 结构体定义
%  pri_all: prn sys el S[3] SD_rea_P[3] DD_res_L[3]
clear;

% 类定义
SatStutes = MSatStutes;
 path = 'K:\硕士毕业论文\城市环境下GNSS信号质量分析\data\20191010\PP7\验前残差\全时段\';
 name = 'PriRes_SD_GCREJ_LLIl';
%path = 'K:\硕士毕业论文\城市环境下GNSS信号质量分析\data\20191010\ZY1\ublox1\';
%name = 'HW1010_ZY1_ublox1_PriRes_SD_All';
% 全时段
%beginTime = 0;
%endTime = 0;
% U型弯场景
%beginTime = 374773;
%endTime = 374970;
% 立交桥林荫道复合场景
%beginTime = 374990;
%endTime = 375361;
% 城市峡谷场景
 beginTime = 378667;
 endTime = 378890;
SNR_delt = 2;
EL_delt = 2;

%% 数据读取与变量初始化
if ~SatStutes.Init(path,name,beginTime,endTime)
    disp('Init is wrong');
    exist(0);
end

%% 寻找残差与标签的关系
MSatStutes.Classfied_P( SatStutes,SNR_delt,EL_delt );
MSatStutes.Classfied_L( SatStutes,SNR_delt,EL_delt );
MSatStutes.Classfied_SNR( SatStutes,EL_delt );

%% 统计相关的信息
% 文件里面输出的都是可用卫星，并不是观测卫星 即nsat_valid <= n_obs
% 每个系统、每个频率的平均卫星数
% 每个系统、每个频率的平均信噪比、信噪比标准差
% 每个系统、每个频率的平均伪距残差、平均相位残差
MSatStutes.CacluteMsg_SNR_Vsat(SatStutes);
MSatStutes.CacluteMsg_Res(SatStutes);

%% 绘制图像
% 输出残差与高度角或信噪比的关系
% 输入信噪比、高度角、残差时域图
%SatStutes.display_time_SNR_el(-1,-1,-1,-1,-1);

% 绘制每个系统每颗卫星伪距、或相位的平均值和标准差
%SatStutes.display_sat_mean_std(-1,-1,-1);

% 绘制信噪比与伪距残差的关系图
%SatStutes.display_res_SNR(-1,-1,-1,-1,-1);
%% 曲线拟合
%  模型需要后续确定 
% %  model1 : y=a*e^(-b*x)+c   arg: a b c
%MSatStutes.Curve_Fitting_Model1(SatStutes);
% %  model2 : y=sqrt(a+(1-a)*(x-min_SNR)/(max_SNR-min_SNR)) output:a
 %MSatStutes.Curve_Fitting_Model2(SatStutes);
 %  model3 : y=a*e^(-b*(x-min_SNR)/(max_SNR-min_SNR))+c   arg: a b c
% MSatStutes.Curve_Fitting_Model3(SatStutes);
% model4 : 在model3 的基础上 去掉LLI标志的数据
% MSatStutes.Curve_Fitting_Model4(SatStutes);
%% 卫星数目统计
MSatStutes.SatNumStatistics(SatStutes);