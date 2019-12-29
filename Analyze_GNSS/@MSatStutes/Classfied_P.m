function [ bool ] = Classfied_P( class_obj,SNR_delt,EL_delt )
%   MSatStutes的类方法
%   按照信噪比、高度角标签分类伪距残差和相位残差
%   残差分析是否应该加绝对值？

% 进度条
    wait_h = waitbar(0,'分析伪距残差中');
% 分类伪距残差
for f = 1:2
    for sys = 1:5
        if sys == 5
            [~,n,~] = size(class_obj.m_SD_P);
           data_end = n;
        else
           data_end = class_obj.m_PRN0(sys+1)-1;
        end
        
        data_begin = class_obj.m_PRN0(sys);
        P = class_obj.m_SD_P(:,data_begin:data_end,f);
        S = class_obj.m_CN0(:,data_begin:data_end,f);
        el = class_obj.m_EL(:,data_begin:data_end);
        
        [ Pall_CN0,Psat_CN0,dimension_CN0 ] = Classfied_C(abs(P),S,SNR_delt,0 );
        [ Pall_el,Psat_el,dimension_el ] = Classfied_C(abs(P),el,EL_delt,0 );
        
        Pall_CN0 = [Pall_CN0;zeros(100-dimension_CN0,2)];
        Psat_CN0 = [Psat_CN0;zeros(100-dimension_CN0,data_end-data_begin+2)]; % 多加了一列是因为第一列是Index
        Pall_el = [Pall_el;zeros(100-dimension_el,2)];
        Psat_el = [Psat_el;zeros(100-dimension_el,data_end-data_begin+2)];
    
    % 赋值
    class_obj.m_index_CN0_dimension(sys,f) = dimension_CN0;
    class_obj.m_index_el_dimension(sys,f) = dimension_el;
    class_obj.m_index_CN0(:,sys,f) = Pall_CN0(:,1);
    class_obj.m_index_el(:,sys,f) = Pall_el(:,1);
    class_obj.m_Psat_CN0(:,data_begin:data_end,f) = Psat_CN0(:,2:end);
    class_obj.m_Psat_el(:,data_begin:data_end,f) = Psat_el(:,2:end);
    class_obj.m_Pall_CN0(:,sys,f) = Pall_CN0(:,end);
    class_obj.m_Pall_el(:,sys,f) = Pall_el(:,end);
    
    
    clear Pall_CN0 Psat_CN0 Pall_el Psat_el P S el  
    
    waitbar((f-1)*5+sys/(2*5));
    
    end
end
    close(wait_h);
end

