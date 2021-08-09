function PlotExtrapolation()
    clc;
    format long
    
    data = [];
    tmp = [0.000018 203504];
    data = [data; tmp]; 
    tmp = [0.000036 101752];
    data = [data; tmp]; 
    tmp = [0.000054 67835];
    data = [data; tmp]; 
    tmp = [0.000180 20358];
    data = [data; tmp];
    
    xd = data(:,1);
    mX = data(:,2);

    delta = 1.620000000000000e-06;
    xi = 0.0000180:delta:0.0001800;
    
    ymX = interp1(xd,mX,xi,'spline','extrap');
           
    figure('Visible', 'on');
        
    plot(xi,ymX,'k-');
    hold on;
    
    plot(xd,mX,'ko','MarkerSize',8);
    hold on;

    grid on;
    set(gcf,'color','w');

    ax = gca;
    ax.GridLineStyle = '-';
    ax.GridColor = 'k';
    ax.GridAlpha = 0.4;

    hold off;
        
end