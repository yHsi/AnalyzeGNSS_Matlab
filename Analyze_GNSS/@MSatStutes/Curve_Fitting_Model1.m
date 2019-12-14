function [ bool ] = Curve_Fitting_Model1( class_obj )
    %model1 : y=a*e^(-b*x)+c   arg: a b c
    F = @(a,x) a(1).*exp(-a(2)*x) + a(3);
    Curve_Fitting_Model1_P(class_obj,F);
    Curve_Fitting_Model1_L(class_obj,F);
end
function [ bool ] = Curve_Fitting_Model1_P(class_obj,F)
    path = [class_obj.m_path,'Model1_伪距残差-信噪比_曲线拟合'];
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
            if PosEnd <= (PosStart+4)
               PosEnd = Locate_0(2,1) - 1;
            end
            
            X = class_obj.m_index_CN0(PosStart:PosEnd,sys,f);
            Y = class_obj.m_Pall_CN0(PosStart:PosEnd,sys,f);
            locate_0 = find(Y==0);
            if ~isempty(locate_0)
                X(locate_0) = [];
                Y(locate_0) = [];
            end
            locate_nan = find(isnan(Y));
            if ~isempty(locate_nan)
                X(locate_nan) = [];
                Y(locate_nan) = [];
            end
            %a,b,c初值
            a0 = [400,0,0];
            if sys == 5 && f == 2
               a0 = [0,0,0] ;
            end
            if sys == 1 && f == 1
               a0 = [100,0,0] ;
            end
            if sys == 3 && f == 1
               a0 = [100,0,0] ;
            end
            if sys == 2 && f == 2
               a0 = [0,0,0] ; 
            end
            [X0,resnorm] = lsqcurvefit(F,a0,X,Y);%resnorm残差平方和  X0是参数
            
            class_obj.m_Pall_CN0_model1(1,sys,f) = X0(1);
            class_obj.m_Pall_CN0_model1(2,sys,f) = X0(2);
            class_obj.m_Pall_CN0_model1(3,sys,f) = X0(3);
            class_obj.m_Pall_CN0_model1(4,sys,f) = resnorm;
            class_obj.m_Pall_CN0_model1(5,sys,f) = X(1);
            %绘图
            plot_x1 = X(1):0.01:X(length(X));
            plot_y1 = X0(1).*exp(-X0(2).*plot_x1)+X0(3);
            
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

function [ bool ] = Curve_Fitting_Model1_L(class_obj,F)
    path = [class_obj.m_path,'Model1_相位残差-信噪比_曲线拟合'];
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
            if PosEnd <= (PosStart+4)
               PosEnd = Locate_0(2,1) - 1;
            end
            X = class_obj.m_index_CN0(PosStart:PosEnd,sys,f);
            Y = class_obj.m_Lall_CN0(PosStart:PosEnd,sys,f);
            locate_0 = find(Y==0);
            if ~isempty(locate_0)
                X(locate_0) = [];
                Y(locate_0) = [];
            end
            locate_nan = find(isnan(Y));
            if ~isempty(locate_nan)
                X(locate_nan) = [];
                Y(locate_nan) = [];
            end
            %a,b,c初值
            a0 = [100,0,0];
            if sys==1 && f==2
               a0 = [400,0,0] ;
            end
            if sys==5 && f==1
               a0 = [400,0,0] ;
            end
            if sys == 1 && f == 1
               a0 = [800,0,0] ;
            end
            [X0,resnorm] = lsqcurvefit(F,a0,X,Y);%resnorm残差平方和  X0是参数
            
            class_obj.m_Lall_CN0_model1(1,sys,f) = X0(1);
            class_obj.m_Lall_CN0_model1(2,sys,f) = X0(2);
            class_obj.m_Lall_CN0_model1(3,sys,f) = X0(3);
            class_obj.m_Lall_CN0_model1(4,sys,f) = resnorm;
            class_obj.m_Lall_CN0_model1(5,sys,f) = X(1);
            %绘图
            
            plot_x1 = X(1)-1:0.01:X(length(X))+1;
            plot_y1 = X0(1)*exp(-X0(2)*plot_x1)+X0(3);
            
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