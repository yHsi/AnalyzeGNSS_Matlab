function [bool] = OpenPriallFile(class_obj )
%   MSatStutes的类方法
%   由类中的file相关变量中读取数据，一旦读取成功保存为mat文件
%   PriAllfile.txt 文件格式为
%   time
%   prn  SDP1 SDP2 DDL1 DDL2 S1 S2 EL
%   读取结果最终保存在MSatStutes类中

    if ~exist(class_obj.m_PriAllfile)
        bool = 0;
        disp('The PriAllfile is not exist!')
        return;
    end
    
    fp = fopen(class_obj.m_PriAllfile,'r+');
    newEpoch = 1;
    n = 0;
    class_obj.m_SatNum_N = zeros(1,141);
    class_obj.m_LLI_P = zeros(1,140,2);
    class_obj.m_LLI_CN0 = zeros(1,140,2);
    class_obj.m_LLI_el = zeros(1,140,2);
    flag_time = 0;
while(~feof(fp))
    oneline = fgets(fp);
    S = regexp(oneline,'(\s+)|:|\t','split');
    S = deblank(S);   % 形成了cell矩阵
    if isempty(char(S(1)))
        newEpoch = 1;
        continue;
    end
    
    if(newEpoch)
        if class_obj.m_beginTime ~= 0 && str2num(char(S(1))) < class_obj.m_beginTime
            newEpoch = 0;
            flag_time = 0;
            continue;
        end
        
        if class_obj.m_endTime ~= 0 && str2num(char(S(1))) > class_obj.m_endTime
            break;
        end
        n = n+1;
        class_obj.m_GPSTIME(n,1) = str2num(char(S(1)));
        newEpoch = 0;
        class_obj.m_Validsat(n,:,1) = zeros(1,5);
        class_obj.m_Validsat(n,:,2) = zeros(1,5);
        class_obj.m_ValidsatAll(n,:) = zeros(1,5);
        class_obj.m_SatNum_NLLI(n,:,1) = zeros(1,140);
        class_obj.m_SatNum_NLLI(n,:,2) = zeros(1,140);
        sys = 0;
        flag_time = 1;
    else
        if flag_time == 0
            continue;
        end
        a = char(S(1));
        satnum =  str2num(a(2:3));
        switch oneline(1)
            case 'G'
                satnum = satnum + 0;
                sys = 1;
            case 'R'
                satnum = satnum + class_obj.m_NSATGPS;
                sys = 2;
            case 'C'
                satnum = satnum + class_obj.m_NSATGPS + class_obj.m_NSATGLO;
                sys = 3;
            case 'E'
                satnum = satnum + class_obj.m_NSATGPS + class_obj.m_NSATGLO + class_obj.m_NSATBDS;
                sys = 4;
            case 'J'
                satnum = satnum + class_obj.m_NSATGPS + class_obj.m_NSATGLO + class_obj.m_NSATBDS + class_obj.m_NSATGAL;
                sys = 5;  
        end
        P1 = str2num(char(S(2)));
        P2 = str2num(char(S(3)));
        L1 = str2num(char(S(4)));
        L2 = str2num(char(S(5)));
        S1 = str2num(char(S(6)));
        S2 = str2num(char(S(7)));
        LLI1 = str2num(char(S(8)));
        LLI2 = str2num(char(S(9)));
        EL = str2num(char(S(10)));
        
        class_obj.m_EL(n,satnum) = EL;
        class_obj.m_SD_P(n,satnum,1) = P1;
        class_obj.m_SD_P(n,satnum,2) = P2;
        class_obj.m_DD_L(n,satnum,1) = L1;
        class_obj.m_DD_L(n,satnum,2) = L2;
        class_obj.m_CN0(n,satnum,1) =  S1;
        class_obj.m_CN0(n,satnum,2) =  S2;
        class_obj.m_LLI(n,satnum,1) = LLI1;
        class_obj.m_LLI(n,satnum,2) = LLI2;
        
        if S1 > 0
            class_obj.m_Validsat(n,sys,1) = class_obj.m_Validsat(n,sys,1)+1;
            class_obj.m_SatNum_Nf(n,satnum,1) = 1;
        end
        if S2 > 0
            class_obj.m_Validsat(n,sys,2) = class_obj.m_Validsat(n,sys,2)+1;
            class_obj.m_SatNum_Nf(n,satnum,2) = 1;
        end
        
        if P1 ~= 0
           class_obj.m_SatNum_Np(n,satnum,1) = 1; 
        end
        if P2 ~= 0
           class_obj.m_SatNum_Np(n,satnum,2) = 1; 
        end
        if L1 ~= 0
           class_obj.m_SatNum_Nl(n,satnum,1) = 1; 
        end
        if L2 ~= 0
           class_obj.m_SatNum_Nl(n,satnum,2) = 1; 
        end
        
        if L1 ~= 0 && P1 ~= 0
           class_obj.m_SatNum_n1(n,satnum) = 1; 
        end
        if L2 ~= 0 && P2 ~= 0
           class_obj.m_SatNum_n2(n,satnum) = 1; 
        end
        if L1 ~= 0 && P1 ~= 0 && L2 ~= 0 && P2 ~= 0
           class_obj.m_SatNum_nn(n,satnum) = 1; 
        end

        if LLI1 ~= 0 
           class_obj.m_SatNum_NLLI(n,satnum,1) = 1;
           class_obj.m_LLI_P(1,satnum,1) = class_obj.m_LLI_P(1,satnum,1)+abs(P1);
           class_obj.m_LLI_CN0(1,satnum,1) = class_obj.m_LLI_CN0(1,satnum,1)+S1;
           class_obj.m_LLI_el(1,satnum,1) = class_obj.m_LLI_el(1,satnum,1)+EL;
           mat_P_SNR = [P1 S1];
           switch oneline(1)
               case 'G'
               class_obj.m_LLI_P_SNR_G_1_y = [class_obj.m_LLI_P_SNR_G_1_y;mat_P_SNR]; 
               case 'R'
               class_obj.m_LLI_P_SNR_R_1_y = [class_obj.m_LLI_P_SNR_R_1_y;mat_P_SNR];
               case 'C'
               class_obj.m_LLI_P_SNR_C_1_y = [class_obj.m_LLI_P_SNR_C_1_y;mat_P_SNR];
               case 'E'
               class_obj.m_LLI_P_SNR_E_1_y = [class_obj.m_LLI_P_SNR_E_1_y;mat_P_SNR];
               case 'J'
               class_obj.m_LLI_P_SNR_J_1_y = [class_obj.m_LLI_P_SNR_J_1_y;mat_P_SNR];
           end
        end
        if LLI1 == 0 && S1 > 0
            mat_P_SNR = [P1 S1];
            switch oneline(1)
               case 'G'
               class_obj.m_LLI_P_SNR_G_1_n = [class_obj.m_LLI_P_SNR_G_1_n;mat_P_SNR]; 
               case 'R'
               class_obj.m_LLI_P_SNR_R_1_n = [class_obj.m_LLI_P_SNR_R_1_n;mat_P_SNR];
               case 'C'
               class_obj.m_LLI_P_SNR_C_1_n = [class_obj.m_LLI_P_SNR_C_1_n;mat_P_SNR];
               case 'E'
               class_obj.m_LLI_P_SNR_E_1_n = [class_obj.m_LLI_P_SNR_E_1_n;mat_P_SNR];
               case 'J'
               class_obj.m_LLI_P_SNR_J_1_n = [class_obj.m_LLI_P_SNR_J_1_n;mat_P_SNR];
            end
        end
        
        if LLI2 ~= 0
           class_obj.m_SatNum_NLLI(n,satnum,2) = 1; 
           class_obj.m_LLI_P(1,satnum,2) = class_obj.m_LLI_P(1,satnum,2)+abs(P2);
           class_obj.m_LLI_CN0(1,satnum,2) = class_obj.m_LLI_CN0(1,satnum,2)+S2;
           class_obj.m_LLI_el(1,satnum,2) = class_obj.m_LLI_el(1,satnum,2)+EL;
           mat_P_SNR2 = [P2 S2];
           switch oneline(1)
               case 'G'
               class_obj.m_LLI_P_SNR_G_2_y = [class_obj.m_LLI_P_SNR_G_2_y;mat_P_SNR2]; 
               case 'R'
               class_obj.m_LLI_P_SNR_R_2_y = [class_obj.m_LLI_P_SNR_R_2_y;mat_P_SNR2];
               case 'C'
               class_obj.m_LLI_P_SNR_C_2_y = [class_obj.m_LLI_P_SNR_C_2_y;mat_P_SNR2];
               case 'E'
               class_obj.m_LLI_P_SNR_E_2_y = [class_obj.m_LLI_P_SNR_E_2_y;mat_P_SNR2];
               case 'J'
               class_obj.m_LLI_P_SNR_J_2_y = [class_obj.m_LLI_P_SNR_J_2_y;mat_P_SNR2];
           end
        end
        if LLI2 == 0 && S2 > 0
           mat_P_SNR2 = [P2 S2];
           switch oneline(1)
               case 'G'
               class_obj.m_LLI_P_SNR_G_2_n = [class_obj.m_LLI_P_SNR_G_2_n;mat_P_SNR2]; 
               case 'R'
               class_obj.m_LLI_P_SNR_R_2_n = [class_obj.m_LLI_P_SNR_R_2_n;mat_P_SNR2];
               case 'C'
               class_obj.m_LLI_P_SNR_C_2_n = [class_obj.m_LLI_P_SNR_C_2_n;mat_P_SNR2];
               case 'E'
               class_obj.m_LLI_P_SNR_E_2_n = [class_obj.m_LLI_P_SNR_E_2_n;mat_P_SNR2];
               case 'J'
               class_obj.m_LLI_P_SNR_J_2_n = [class_obj.m_LLI_P_SNR_J_2_n;mat_P_SNR2];
           end
        end
        
        class_obj.m_ValidsatAll(n,sys) = class_obj.m_ValidsatAll(n,sys) + 1;
        class_obj.m_SatNum_N(1,satnum) = class_obj.m_SatNum_N(1,satnum) + 1;
    end
end
fclose(fp);
save(class_obj.m_Matfile,'class_obj');
bool = 1;
end

