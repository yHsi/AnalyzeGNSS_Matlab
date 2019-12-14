function [ bool ] = CacluteMsg_SNR_Vsat( class_obj )
%   MSatStutes的类方法
%   计算载噪比和可用卫星数的均值及标准差

 class_obj.m_mean = zeros(2,5,2);
 class_obj.m_std = zeros(2,5,2);
 
 % 进度条
 wait_h = waitbar(0,'统计信噪比、可见卫星数信息');
 
for f = 1:2
   
    for sys = 1:5
        if sys == 5
            [~,n,~] = size(class_obj.m_SD_P);
           data_end = n;
        else
           data_end = class_obj.m_PRN0(sys+1)-1;
        end
        
        data_begin = class_obj.m_PRN0(sys);
        CN0 = class_obj.m_CN0(:,data_begin,f);
        for i_data = data_begin+1:data_end
            CN0 = [CN0;class_obj.m_CN0(:,i_data,f)];
        end
        
        Locate = find(CN0 == 0);
        CN0(Locate)=[];
        if std(CN0) ~= 0
            class_obj.m_mean(2,sys,f) = mean(CN0);
            class_obj.m_std(2,sys,f) = std(CN0);
        end
        
        if std(class_obj.m_Validsat(:,sys,f)) ~= 0
            class_obj.m_mean(1,sys,f) = mean(class_obj.m_Validsat(:,sys,f));
            class_obj.m_std(1,sys,f) = std(class_obj.m_Validsat(:,sys,f));
        end
    waitbar((f-1)*5+sys/(2*5));    
    end
end
    close(wait_h);
end

