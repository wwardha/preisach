function PlotTransformation(plotType, doping)
    clc;
    format long
    
    data = [];
    tmp = [0 2000 4.717e-05 2.916e-06 1674051127.3];
    data = [data; tmp]; 
    tmp = [1 1000 4.4248e-05 1.0452e-05 102617864.71];
    data = [data; tmp];
    tmp = [3 3000 4.1322e-05 1.5008e-05 71367376.338];
    data = [data; tmp];
    tmp = [6 3000 3.937e-05 9.4845e-06 51925062.084];
    data = [data; tmp];
    
    xdoping = data(:,1);
    deltaX = data(:,2);
    mX = data(:,3);
    deltaY = data(:,4);
    mY = data(:,5);

    xi = 0:0.05:20;
    xp = xi';
    ydeltaX = interp1(xdoping,deltaX,xi,'linear','extrap');
    ymX = interp1(xdoping,mX,xi,'linear','extrap');
    ydeltaY = interp1(xdoping,deltaY,xi,'linear','extrap');
    ymY = interp1(xdoping,mY,xi,'linear','extrap');
        
    plotTrans = [];
    if (plotType == "deltaX")
        plotTrans = ydeltaX;
    elseif (plotType == "mX")
        plotTrans = ymX;
    elseif (plotType == "deltaY")
        plotTrans = ydeltaY;
    elseif (plotType == "mY")
        plotTrans = ymY;
    end
    
    plotTransp = plotTrans';
    ip = xp(:,1) == doping;
    ptp = plotTransp(ip,1);
    disp("doping = " + num2str(doping));
    disp(plotType + " = " + num2str(ptp));
    
    figure('Visible', 'on');
        
    plot(xi,plotTrans,'k-');
    hold on;
    
    xlabel('Li Doping Concentration (%)');
    ylabel(plotType,'FontSize', 12);

    grid on;
    set(gcf,'color','w');

    ax = gca;
    ax.GridLineStyle = '-';
    ax.GridColor = 'k';
    ax.GridAlpha = 0.4;

    lgd = legend(plotType,'FontSize', 14);
    lgd.Location = 'north';

    hold off;
        
end