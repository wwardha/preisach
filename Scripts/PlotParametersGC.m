function PlotParametersGC(doping)
    clc;
    format long
    
    data = [];
    tmp = [0 0.69537];
    data = [data; tmp]; 
    tmp = [1 6.0585];
    data = [data; tmp];
    tmp = [3 13.6655];
    data = [data; tmp];
    tmp = [6 14.5024];
    data = [data; tmp];
    ext = [100 15];
    extdata = [data; ext];
    
    xdoping = data(:,1);
    sigmac = data(:,2);

    xi = 0:0.1:6;
    xp = xi';
    xd = extdata(:,1);
    ys = extdata(:,2);
    ysi = interp1(xd,ys,xi,'pchip','extrap');
    ypsi = ysi';
    
    ip = xp(:,1) == doping;
    psi = ypsi(ip,1);
    
    disp("doping = " + num2str(doping));
    disp("sigmac = " + num2str(psi));
    
    figure('Visible', 'on');
        
    plot(xdoping,sigmac,'ks','MarkerFaceColor','k', 'MarkerSize',8);
    hold on;

    plot(xi,ysi,'k-');
    hold on;
    
    xlabel('Li Doping Concentration (%)');
    ylabel('\sigma_c','FontSize', 12);

    grid on;
    set(gcf,'color','w');

    ax = gca;
    ax.GridLineStyle = '-';
    ax.GridColor = 'k';
    ax.GridAlpha = 0.4;

    lgd = legend('\sigma_c','FontSize', 14);
    lgd.Location = 'east';

    hold off;
        
end