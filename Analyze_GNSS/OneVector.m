function [output_vector] =  OneVector(value_x,value_y,flag)
%  函数含义是，对输入的value_y和value_x进行整合，合并为一个列向量
%  value_y 的维度为 m*n   value_x 的维度为 m2*n2
%  nan 或者为空的数值将会被去掉
%  flag 控制是否删除0元素 因为某些时候0元素不是无效元素 而是真实存在的
%  flag = 0  x y均删除0元素
%  flag = 1  x 删除0元素
%  flag = 2  y 删除0元素
[m1,n1] = size(value_y);
[m2,n2] = size(value_x);

if  m1 ~= m2 || n1 ~= n2
    return; 
end

output_vector = [];
n = 0;
for sat = 1:n1
    for i = 1:m1
        if flag == 0 && (value_x(i,sat) == 0 || value_y(i,sat) == 0)
            continue;
        end
        
        if flag == 1 && value_x(i,sat) == 0 
            continue;
        end
        
        if flag == 2 && value_y(i,sat) == 0
            continue;
        end
        
        if isnan(value_y(i,sat))
            continue;
        end
        n = n+1;  
        output_vector(n,1) = value_x(i,sat);
        output_vector(n,2) = value_y(i,sat);
        
    end
end


end

