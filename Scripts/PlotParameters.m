function PlotParameters(doping)
    clc;
    format long
    
    data = [];
    tmp = [0 0.84379 1.1219];
    data = [data; tmp]; 
    tmp = [1 0.094981 0.87948];
    data = [data; tmp];
    tmp = [3 0.0011406 0.99835];
    data = [data; tmp];
    tmp = [6 0.0054572 1.1788];
    data = [data; tmp];
    ext = [100 1.2 0];
    extdata = [data; ext];
    
    xdoping = data(:,1);
    sigma = data(:,2);
    eta = data(:,3);

    xi = 0:0.1:10;
    xp = xi';
    xd = extdata(:,1);
    ys = extdata(:,2);
    ye = extdata(:,3);
    ysi = interp1(xd,ys,xi,'pchip','extrap');
    yei = interp1(xd,ye,xi,'pchip','extrap');
    ypsi = ysi';
    ypei = yei';
    
    ip = find(xp(:,1) == doping);
    psi = ypsi(ip,1);
    pei = ypei(ip,1);
    
    disp("doping = " + num2str(doping));
    disp("sigma = " + num2str(psi));
    disp("eta = " + num2str(pei));
    
    figure('Visible', 'on');
        
    plot(xdoping,sigma,'ks','MarkerFaceColor','k', 'MarkerSize',8);
    hold on;

    plot(xdoping,eta,'ko','MarkerSize',8);
    hold on;

    plot(xi,ysi,'k-');
    hold on;

    plot(xi,yei,'k-');
    hold on;
    
    xlabel('Li Doping Concentration (%)');
    ylabel('\sigma , \eta','FontSize', 12);

    grid on;
    set(gcf,'color','w');

    ax = gca;
    ax.GridLineStyle = '-';
    ax.GridColor = 'k';
    ax.GridAlpha = 0.4;

    lgd = legend('\sigma','\eta','FontSize', 14);
    lgd.Location = 'east';

    hold off;
        
end