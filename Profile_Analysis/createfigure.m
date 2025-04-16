function createfigure(X1, Y1, YData1, XData1, XMatrix1, YMatrix1, X2, Y2, YData2, XData2, XMatrix2, Y3, X3, Y4, YData3, XData3, XMatrix3, Y5, X4, Y6, YData4, XData4, XMatrix4, X5, Y7, YData5, XData5, XMatrix5)
%CREATEFIGURE(X1, Y1, YData1, XData1, XMatrix1, YMatrix1, X2, Y2, YData2, XData2, XMatrix2, Y3, X3, Y4, YData3, XData3, XMatrix3, Y5, X4, Y6, YData4, XData4, XMatrix4, X5, Y7, YData5, XData5, XMatrix5)
%  X1:  plot x 数据的向量
%  Y1:  plot y 数据的向量
%  YDATA1:  patch ydata
%  XDATA1:  patch xdata
%  XMATRIX1:  plot x 数据的矩阵
%  YMATRIX1:  plot y 数据的矩阵
%  X2:  plot x 数据的向量
%  Y2:  plot y 数据的向量
%  YDATA2:  patch ydata
%  XDATA2:  patch xdata
%  XMATRIX2:  plot x 数据的矩阵
%  Y3:  plot y 数据的向量
%  X3:  plot x 数据的向量
%  Y4:  plot y 数据的向量
%  YDATA3:  patch ydata
%  XDATA3:  patch xdata
%  XMATRIX3:  plot x 数据的矩阵
%  Y5:  plot y 数据的向量
%  X4:  plot x 数据的向量
%  Y6:  plot y 数据的向量
%  YDATA4:  patch ydata
%  XDATA4:  patch xdata
%  XMATRIX4:  plot x 数据的矩阵
%  X5:  plot x 数据的向量
%  Y7:  plot y 数据的向量
%  YDATA5:  patch ydata
%  XDATA5:  patch xdata
%  XMATRIX5:  plot x 数据的矩阵

%  由 MATLAB 于 27-Oct-2024 21:49:37 自动生成

% 创建 figure
figure1 = figure('InvertHardcopy','off','Color',[1 1 1]);

% 创建 axes
axes1 = axes('Parent',figure1,...
    'Position',[0.13 0.689620758483032 0.775 0.279441117764473]);
hold(axes1,'on');

% 创建 plot
plot(X1,Y1,'Parent',axes1,'Color',[0 0 0]);

% 创建 patch
patch('Parent',axes1,'YData',YData1,'XData',XData1,'FaceAlpha',0.6,...
    'FaceColor',[1 0 0.117647058823529]);

% 使用 plot 的矩阵输入创建多个 line 对象
plot1 = plot(XMatrix1,YMatrix1,'Parent',axes1);
set(plot1(1),'LineWidth',1.5,'LineStyle','--','Color',[0 0 1]);
set(plot1(2),'LineWidth',1.5,'LineStyle','--','Color',[0 0 1]);
set(plot1(3),'LineWidth',1.5,'LineStyle','--','Color',[0 0 1]);
set(plot1(4),'LineWidth',1.8,'LineStyle','-.','Color',[1 1 0]);
set(plot1(5),'LineWidth',1.8,'LineStyle','-.','Color',[1 1 0]);
set(plot1(6),'LineWidth',1.8,'LineStyle','-.','Color',[0 1 0]);

% 创建 ylabel
ylabel('Elevation (m)','FontWeight','bold','FontSize',14,'FontName','Arial');

% 创建 xlabel
xlabel('Distance (m)','FontWeight','bold','FontSize',14,'FontName','Arial');

% 创建 title
title('Line 1','FontWeight','bold','FontSize',16);

% 取消以下行的注释以保留坐标区的 X 范围
% xlim(axes1,[0 928.82120430969]);
% 取消以下行的注释以保留坐标区的 Y 范围
% ylim(axes1,[0 120]);
% 取消以下行的注释以保留坐标区的 Z 范围
% zlim(axes1,[-1 1]);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'off');
% 设置其余坐标区属性
set(axes1,'FontName','Arial','FontSize',12,'GridAlpha',0.2,'TickLength',...
    [0.008 0.008]);
% 创建 axes
axes2 = axes('Parent',figure1,...
    'Position',[0.13 0.392215568862275 0.368493068113321 0.232842526476417]);
hold(axes2,'on');

% 创建 plot
plot(X2,Y2,'Parent',axes2,'Color',[0 0 0]);

% 创建 patch
patch('Parent',axes2,'YData',YData2,'XData',XData2,'FaceAlpha',0.6,...
    'FaceColor',[0.274509803921569 0.662745098039216 0.901960784313726]);

% 使用 plot 的矩阵输入创建多个 line 对象
plot(XMatrix2,Y3,'Parent',axes2,'LineWidth',1.5,'LineStyle','--',...
    'Color',[0 0 1]);

% 创建 ylabel
ylabel('Elevation (m)','FontWeight','bold','FontSize',14,'FontName','Arial');

% 创建 title
title('Line 2','FontWeight','bold','FontSize',16);

% 取消以下行的注释以保留坐标区的 X 范围
% xlim(axes2,[0 1115.65403937622]);
% 取消以下行的注释以保留坐标区的 Y 范围
% ylim(axes2,[20 120]);
% 取消以下行的注释以保留坐标区的 Z 范围
% zlim(axes2,[-1 1]);
box(axes2,'on');
grid(axes2,'on');
hold(axes2,'off');
% 设置其余坐标区属性
set(axes2,'FontName','Arial','FontSize',12,'GridAlpha',0.2,'TickLength',...
    [0.008 0.008]);
% 创建 axes
axes3 = axes('Parent',figure1,...
    'Position',[0.539481615430983 0.393213572854291 0.365518384569017 0.231844522484401]);
hold(axes3,'on');

% 创建 plot
plot(X3,Y4,'Parent',axes3,'Color',[0 0 0]);

% 创建 patch
patch('Parent',axes3,'YData',YData3,'XData',XData3,'FaceAlpha',0.5,...
    'FaceColor',[0.792156862745098 0 0.396078431372549]);

% 使用 plot 的矩阵输入创建多个 line 对象
plot(XMatrix3,Y5,'Parent',axes3,'LineWidth',1.5,'LineStyle','--',...
    'Color',[0 0 1]);

% 创建 title
title('Line 3','FontWeight','bold','FontSize',16);

% 取消以下行的注释以保留坐标区的 X 范围
% xlim(axes3,[70 709.45168896747]);
% 取消以下行的注释以保留坐标区的 Y 范围
% ylim(axes3,[70 140]);
% 取消以下行的注释以保留坐标区的 Z 范围
% zlim(axes3,[-1 1]);
box(axes3,'on');
grid(axes3,'on');
hold(axes3,'off');
% 设置其余坐标区属性
set(axes3,'FontName','Arial','FontSize',12,'GridAlpha',0.2,'TickLength',...
    [0.008 0.008]);
% 创建 axes
axes4 = axes('Parent',figure1,...
    'Position',[0.13 0.11 0.36789029535865 0.215425742397517]);
hold(axes4,'on');

% 创建 plot
plot(X4,Y6,'Parent',axes4,'Color',[0 0 0]);

% 创建 patch
patch('Parent',axes4,'YData',YData4,'XData',XData4,'FaceAlpha',0.5,...
    'FaceColor',[0.0392156862745098 0.588235294117647 0]);

% 使用 plot 的矩阵输入创建多个 line 对象
plot(XMatrix4,Y3,'Parent',axes4,'LineWidth',1.5,'LineStyle','--',...
    'Color',[0 0 1]);

% 创建 ylabel
ylabel('Elevation (m)','FontWeight','bold','FontSize',14,'FontName','Arial');

% 创建 xlabel
xlabel('Distance (m)','FontWeight','bold','FontSize',14,'FontName','Arial');

% 创建 title
title('Line 4','FontWeight','bold','FontSize',16);

% 取消以下行的注释以保留坐标区的 X 范围
% xlim(axes4,[0 658.006916961446]);
% 取消以下行的注释以保留坐标区的 Y 范围
% ylim(axes4,[20 120]);
% 取消以下行的注释以保留坐标区的 Z 范围
% zlim(axes4,[-1 1]);
box(axes4,'on');
grid(axes4,'on');
hold(axes4,'off');
% 设置其余坐标区属性
set(axes4,'FontName','Arial','FontSize',12,'GridAlpha',0.2,'TickLength',...
    [0.008 0.008]);
% 创建 axes
axes5 = axes('Parent',figure1,...
    'Position',[0.540687160940326 0.11 0.364312839059674 0.215425742397517]);
hold(axes5,'on');

% 创建 plot
plot(X5,Y7,'Parent',axes5,'Color',[0 0 0]);

% 创建 patch
patch('Parent',axes5,'YData',YData5,'XData',XData5,'FaceAlpha',0.5,...
    'FaceColor',[0.772549019607843 0 1]);

% 使用 plot 的矩阵输入创建多个 line 对象
plot(XMatrix5,Y3,'Parent',axes5,'LineWidth',1.5,'LineStyle','--',...
    'Color',[0 0 1]);

% 创建 xlabel
xlabel('Distance (m)','FontWeight','bold','FontSize',14,'FontName','Arial');

% 创建 title
title('Line 5','FontWeight','bold','FontSize',16);

% 取消以下行的注释以保留坐标区的 X 范围
% xlim(axes5,[0 1076.70119419311]);
% 取消以下行的注释以保留坐标区的 Y 范围
% ylim(axes5,[0 120]);
% 取消以下行的注释以保留坐标区的 Z 范围
% zlim(axes5,[-1 1]);
box(axes5,'on');
grid(axes5,'on');
hold(axes5,'off');
% 设置其余坐标区属性
set(axes5,'FontName','Arial','FontSize',12,'GridAlpha',0.2,'TickLength',...
    [0.008 0.008]);
