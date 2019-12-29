function [ Classfied_all,Classfied_sat,dimension ] = Classfied_C( value,sign,delt,flag )
%UNTITLED Classfied
% flag 最终输出到value数组中的值的形式 
% flag = 0: 求均值
% flag = 1: 求和
% flag = 2: sqrt(x^2)/sqrt(2*n) 单个历元 n=1 
%   此处显示详细说明
[m_value,n_value] = size(value);
[m_sign,n_sign] = size(sign);
if  m_value ~= m_sign || n_value ~= n_sign
    return; 
end

max_sign = max(max(sign(:,:)));
Classfied_value = zeros(round(round(max_sign)/delt),1);
Classfied_valuen = zeros(round(round(max_sign)/delt),1);
Classfied_value_sat = zeros(round(round(max_sign)/delt),n_value);
Classfied_value_satn = zeros(round(round(max_sign)/delt),n_value);

Classfied_all = zeros(round(round(max_sign)/delt),2); 
Classfied_sat = zeros(round(round(max_sign)/delt),n_value+1); 

Classfied_all(:,1) = (1:delt:round(max_sign))';
Classfied_all(:,1) = Classfied_all(:,1)+(delt-1)*0.5;
Classfied_sat(:,1) = Classfied_all(:,1);
dimension = round(round(max_sign)/delt);

for sat = 1:n_value
for i = 1:m_value
    if sign(i,sat) == 0 || value(i,sat) == 0
        continue;
    end
    index = round(sign(i,sat)/delt);
    if index == 0
        continue;
    end
    
    Classfied_value(index) = Classfied_value(index)+value(i,sat);
    Classfied_valuen(index) = Classfied_valuen(index)+1;
    Classfied_value_sat(index,sat) = Classfied_value_sat(index,sat)+value(i,sat);
    Classfied_value_satn(index,sat) = Classfied_value_satn(index,sat)+1;
    
end
if  std(Classfied_value_satn(:,sat)) == 0
    Classfied_sat(:,sat+1) = 0;
else
    switch(flag)
        case 0
            Classfied_sat(:,sat+1) = Classfied_value_sat(:,sat)./Classfied_value_satn(:,sat);
        case 1
            Classfied_sat(:,sat+1) = Classfied_value_sat(:,sat);
        case 2
            Classfied_sat(:,sat+1) = Classfied_value_sat(:,sat)./(Classfied_value_satn(:,sat)*sqrt(2));
    end
end

end

if  std(Classfied_valuen(:,1)) == 0
    Classfied_all(:,2) = 0;
else
    switch(flag)
        case 0
            Classfied_all(:,2) = Classfied_value(:,1)./Classfied_valuen(:,1);
        case 1
            Classfied_all(:,2) = Classfied_value(:,1);
        case 2
            Classfied_all(:,2) = Classfied_value(:,1)./(Classfied_valuen(:,1)*sqrt(2));
    end
end

end

