function [ bool ] = Curve_Fitting_Model2( class_obj )
%  model2 : y=sqrt(a+(1-a)*(x-min_SNR)/(max_SNR-min_SNR)) output:a
    Curve_Fitting_Model2_P(class_obj);
    Curve_Fitting_Model2_L(class_obj);
end
function [ bool ] = Curve_Fitting_Model2_P(class_obj)
    path = [class_obj.m_path,'Model2_伪距残差-信噪比_曲线拟合'];
    if ~exist(path)
        mkdir(path);
    else
        rmdir(path,'s');
        mkdir(path);
    end
    for f = 1:2
        if f == 1
          title1 = '频率1';  
        end
        if f == 2
          title1 = '频率2';  
        end
        for sys = 1:5
            if sys == 1
               title2 = 'GPS'; 
            end
            if sys == 2
               title2 = 'GLO'; 
            end
            if sys == 3
               title2 = 'BDS'; 
            end
            if sys == 4
               title2 = 'GAL'; 
            end
            if sys == 5
               title2 = 'QZS'; 
            end
            %[~,~,l] = size(class_obj.m_Pall_CN0);
            if max(class_obj.m_Pall_CN0(:,sys,f)) == 0
               continue; 
            end
            [~,PosStart] = max(class_obj.m_Pall_CN0(:,sys,f));
%             if class_obj.m_Pall_CN0(PosStart,sys,f)-class_obj.m_Pall_CN0(PosStart-1,sys,f) <= 0.5
%                PosStart = PosStart - 1; 
%             end
            Locate_0 = find(class_obj.m_Pall_CN0(:,sys,f) == 0);
            PosEnd = Locate_0(1,1) - 1;
            if PosEnd == PosStart
               PosEnd = Locate_0(2,1) - 1;
            end
            X = class_obj.m_index_CN0(PosStart:PosEnd,sys,f);
            Y = class_obj.m_Pall_CN0(PosStart:PosEnd,sys,f);
            locate_0 = find(Y==0);
            if ~isempty(locate_0)
                X(locate_0) = [];
                Y(locate_0) = [];
            end
            min_SNR = min(X);
            max_SNR = max(X);
            %a,b,c初值
            a0 = 0;
            F = @(a,x) sqrt(a+(1-a)*(x-min_SNR)/(max_SNR-min_SNR));
            [X0,resnorm] = lsqcurvefit(F,a0,X,Y);%resnorm残差平方和  X0是参数
            
            class_obj.m_Pall_CN0_model2(1,sys,f) = X0(1);
            class_obj.m_Pall_CN0_model2(2,sys,f) = resnorm;
            %绘图
            plot_x1 = X(1)-1:0.01:X(length(X))+1;
            plot_y1 = sqrt(X0(1)+(1-X0(1))*(plot_x1-min_SNR)/(max_SNR-min_SNR));
            
            Locate_1 = find(class_obj.m_Pall_CN0(:,sys,f)>0);
            plot_x2 = class_obj.m_index_CN0(Locate_1(1,1):PosEnd,sys,f);
            plot_y2 = class_obj.m_Pall_CN0(Locate_1(1,1):PosEnd,sys,f);
            
            fh = figure();
            plot(plot_x1,plot_y1,'linewidth',1.5);
            hold on;
            plot(plot_x2,plot_y2,'ro');
            hold off;
            legend('拟合曲线','数据点');
            title(['伪距残差-信噪比拟合曲线-',title1,'-',title2]);
            ylabel('伪距残差/m');
            xlabel('信噪比');
            filename = [path,'\\伪距残差-信噪比拟合曲线-',title1,'-',title2];
            saveas(fh,filename,'png');
            %close(fh); 
        end
     end
end

function [ bool ] = Curve_Fitting_Model2_L(class_obj)
    path = [class_obj.m_path,'Model2_相位残差-信噪比_曲线拟合'];
    if ~exist(path)
        mkdir(path);
    else
        rmdir(path,'s');
        mkdir(path);
    end
    for f = 1:2
        if f == 1
          title1 = '频率1';  
        end
        if f == 2
          title1 = '频率2';  
        end
        for sys = 1:5
            if sys == 1
               title2 = 'GPS'; 
            end
            if sys == 2
               title2 = 'GLO'; 
            end
            if sys == 3
               title2 = 'BDS'; 
            end
            if sys == 4
               title2 = 'GAL'; 
            end
            if sys == 5
               title2 = 'QZS'; 
            end
            %[~,~,l] = size(class_obj.m_Pall_CN0);
            if max(class_obj.m_Lall_CN0(:,sys,f)) == 0
               continue;  
            end
            [~,PosStart] = max(class_obj.m_Lall_CN0(:,sys,f));
%             if class_obj.m_Lall_CN0(PosStart,sys,f)-class_obj.m_Lall_CN0(PosStart-1,sys,f) <= 0.5
%                PosStart = PosStart - 1; 
%             end
            Locate_0 = find(class_obj.m_Lall_CN0(:,sys,f) == 0);
            PosEnd = Locate_0(1,1) - 1;
            if PosEnd == PosStart
               PosEnd = Locate_0(2,1) - 1;
            end
            X = class_obj.m_index_CN0(PosStart:PosEnd,sys,f);
            Y = class_obj.m_Lall_CN0(PosStart:PosEnd,sys,f);
            locate_0 = find(Y==0);
            if ~isempty(locate_0)
                X(locate_0) = [];
                Y(locate_0) = [];
            end   
            min_SNR = min(X);
            max_SNR = max(X);
            %a,b,c初值
            a0 = 0;
            F = @(a,x) sqrt(a+(1-a)*(x-min_SNR)/(max_SNR-min_SNR));
            [X0,resnorm] = lsqcurvefit(F,a0,X,Y);%resnorm残差平方和  X0是参数
            
            class_obj.m_Lall_CN0_model2(1,sys,f) = X0(1);
            class_obj.m_Lall_CN0_model2(2,sys,f) = resnorm;
            %绘图
            plot_x1 = X(1)-1:0.01:X(length(X))+1;
            plot_y1 = sqrt(X0(1)+(1-X0(1))*(plot_x1-min_SNR)/(max_SNR-min_SNR));
            
            Locate_1 = find(class_obj.m_Lall_CN0(:,sys,f)>0);
            plot_x2 = class_obj.m_index_CN0(Locate_1(1,1):PosEnd,sys,f);
            plot_y2 = class_obj.m_Lall_CN0(Locate_1(1,1):PosEnd,sys,f);
            
            fh = figure();
            plot(plot_x1,plot_y1,'linewidth',1.5);
            hold on;
            plot(plot_x2,plot_y2,'ro');
            hold off;
            legend('拟合曲线','数据点');
            title(['相位残差-信噪比拟合曲线-',title1,'-',title2]);
            ylabel('相位残差/m');
            xlabel('信噪比');
            filename = [path,'\\相位残差-信噪比拟合曲线-',title1,'-',title2];
            saveas(fh,filename,'png');
            %close(fh); 
        end
     end
end