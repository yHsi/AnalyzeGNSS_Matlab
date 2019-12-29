function createfigure_SNRLLI(X,bar_Y,line_Y,filename,ylabel_str,flag)
%CREATEFIGURE(X1, Y1)
%  X:  scatter x
%  line_Y:  line y    y1  noLLI   y2 LLI
%  bar_Y :  bar  y    y1  noLLI   y2 LLI

%  由 MATLAB 于 26-Dec-2019 09:18:01 自动生成

% 字号大小
fontsize = 16;

% 创建 figure
fh = figure('InvertHardcopy','off','NumberTitle','off','Color',[1 1 1],'Visible','on');

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 5])

 % 创建 axes
 % axes1 = axes('Position',[0.1 0.13 0.87 0.8]);
 % hold(axes1,'on');
 
 % 创建双纵坐标轴
  [hAxes,hBar,hLine]=plotyy(X,bar_Y,X,line_Y,'bar','plot');
 
 % 取消以下行的注释以保留坐标轴的 X 范围
 if flag == 0
     X_min = 20;
     X_max = 55;
 else
     X_min = 5;
     X_max = 60;
 end
 xlim(hAxes(1),[X_min X_max]);
 xlim(hAxes(2),[X_min X_max]);
 % 创建 xlabel
 xlabel('C/N0(dBHz)','FontSize',fontsize,'HorizontalAlignment','center');
 set(gca,'Position',[0.1 0.13 0.8 0.8]');
 
 

% 修改bar
 set(hBar(1),'DisplayName','Pct(noLLI)',...
    'FaceColor',[0.466666668653488 0.674509823322296 0.18823529779911]);
 set(hBar(2),'DisplayName','Pct(LLI)',...
    'FaceColor',[0.850980401039124 0.325490206480026 0.0980392172932625],...
    'BarWidth',1);

% 修改line
  set(hLine(1),'DisplayName',['Res(noLLI)'],...
      'color',[0.0784313753247261 0.168627455830574 0.549019634723663],'LineWidth',0.8,'Marker','*');
  set(hLine(2),'DisplayName',['Res(LLI)'],...
      'color',[0.635294139385223 0.0784313753247261 0.184313729405403],'LineWidth',0.8,'Marker','*');

% 设置Y坐标轴
  ylabel(hAxes(1),'Percentage(%)','FontSize',fontsize,'FontName','Arial','FontWeight','bold');
  ylabel(hAxes(2),[ylabel_str,'(m)'],'FontSize',fontsize,'FontName','Arial','FontWeight','bold');

  % 计算坐标轴的范围和刻度
  Y1delt = 5;
  Y2delt = 2;
  Y1_max = max(max(bar_Y(:,1)),max(bar_Y(:,2)));
  Y1_min = min(bar_Y(:,1),bar_Y(:,2));
  Y2_max = max(max(line_Y(:,1)),max(line_Y(:,2)));
  Y2_min = min(max(line_Y(:,1)),max(line_Y(:,2)));
  
  ntick_Y1 = ceil((Y1_max - 0)/Y1delt);
  ntick_Y2 = ceil((Y2_max - 0)/Y2delt);
  
  Y1_max = ntick_Y1 * Y1delt;
  Y2_max = ntick_Y2 * Y2delt;
  
  Y1_tick = 0:Y1delt:Y1_max;
  Y2_tick = 0:Y2delt:Y2_max;
  
  % 取消以下行的注释以保留坐标轴的 Y 范围
 ylim(hAxes(1),[0 Y1_max]);
 ylim(hAxes(2),[0 Y2_max]);
  
 
 % 删除右和上的刻度
set(hAxes(1),'box','off');
set(hAxes(2),'box','off');
new_ax = axes('Position',get(hAxes(1),'Position'),'XLim',get(hAxes(1),'XLim'),'YTick',[]);
set(new_ax,'box','on');
uistack(hAxes(1),'top');
uistack(hAxes(2),'top');
set(hAxes(1),'Color','None');

 % 设置其余坐标轴属性
set(hAxes(1),'FontName','Arial','FontSize',fontsize,'FontWeight','bold','GridAlpha',...
    0.2,'XTick',[X_min:5:X_max],'YGrid','off','YTick',Y1_tick);
set(hAxes(2),'FontName','Arial','FontSize',fontsize,'FontWeight','bold','GridAlpha',...
    0.2,'XTick',[X_min:5:X_max],'YGrid','off','YTick',Y2_tick);
set(new_ax,'FontName','Arial','FontSize',fontsize,'FontWeight','bold','GridAlpha',...
    0.2,'XTick',[20 25 30 35 40 45 50 55]);

% 创建 legend
legend1 = legend(hAxes(1),'show');
% [0.5 0.78 0.12 0.08]
set(legend1,...
    'Box','on',...
    'Location', 'best',...
    'Fontsize',12,...
    'FontName','Arial');
%    legend2 = legend(hAxes(2),'show');
% set(legend2,...
%     'Box','on',...
%     'Fontsize',12,...
%     'FontName','Arial');

saveas(fh,filename,'tif');
