function [ bool ] = Classfied_SNR( class_obj,EL_delt )
%   MSatStutes的类方法
%   按照高度角标签分类载噪比


% 进度条
    wait_h = waitbar(0,'分析载噪比中');
% 分类伪距残差
for f = 1:2
    for sys = 1:5
        if sys == 5
            [~,n,~] = size(class_obj.m_CN0);
           data_end = n;
        else
           data_end = class_obj.m_PRN0(sys+1)-1;
        end
        
        data_begin = class_obj.m_PRN0(sys);
        S = class_obj.m_CN0(:,data_begin:data_end,f);
        el = class_obj.m_EL(:,data_begin:data_end);
       
        [ SNRall_el,SNRsat_el,dimension_el ] = Classfied_C(S,el,EL_delt );
        
        SNRall_el = [SNRall_el;zeros(100-dimension_el,2)];
        SNRsat_el = [SNRsat_el;zeros(100-dimension_el,data_end-data_begin+2)];
    
    % 赋值
    class_obj.m_SNRsat_el(:,data_begin:data_end,f) = SNRsat_el(:,2:end);
    class_obj.m_SNRall_el(:,sys,f) = SNRall_el(:,end);
    
    
    clear SNRall_el SNRsat_el S el  
    
    waitbar((f-1)*5+sys/(2*5));
    
    end
end
    close(wait_h);
end

