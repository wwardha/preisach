function PredictSimulation(model, doping, sigmam, sigmac, deltaX, mX, deltaY, mY)
    clc;
    format long;
    
    a0 = 5;
    x0 = -5.5;
    y0 = 5.5;
    nSpline = 500;
    nc = 100;
    nHysterons = 50000;
    Ecs = 0;
    Prs = 0;
    Pss = 0;
    
    expTitle = "ZnO:Li " + num2str(doping) + "%";
    
    if (model == "gc")        
        uNew = [];
        if (sigmac < 0.0001)
            sigmac = 0.0001;
        end
        
        disp("Generate Preisach Distribution for sigmam = " + num2str(sigmam) + ", sigmac = " + num2str(sigmac));
        mu = GenerateGaussianCauchyPreisachDistribution(a0, sigmam, sigmac, x0, y0, nSpline, nc, 0);
        [~,col]=size(mu);
        n = double(col);
        weight = nHysterons/n;

        iter = 2*100;
        freq = 5;
        volt = a0;
        count = 1;

        output = [];

        disp('Start Timer');
        t = timer;
        t.StartFcn = {@timer_callback, n, weight};
        t.TimerFcn = {@timer_callback, n, weight};
        t.Period = 1/freq;
        t.TasksToExecute = 2*iter;
        t.ExecutionMode = 'fixedRate';
        t.UserData = struct('volt', volt, 'freq', freq, 'iter', iter, 'time', 0, 'count', count, 'mu', mu, 'uNew', uNew, 'out', output);
        start(t);
        wait(t);
        output = t.UserData.('out');
        delete(t); 

        up = [];
        down = [];

        [n,~] = size(output);
        for i=1:n
            tmp = [output(i, 1) output(i, 2)];
            if ((i == 1) || (i > 1 && (output(i, 1) > output(i-1, 1))))
                up = [up; tmp];
            else
                down = [down; tmp];
            end
            if (output(i, 1) == a0)
                down = [down; tmp];
            end
        end

        delta = (2*a0)/100;
        xi = -a0:delta:a0;

        XU = up(:,1);
        YU = up(:,2);
        yu = interp1(XU,YU,xi);

        XD = down(:,1);
        YD = down(:,2);
        yd = interp1(XD,YD,xi);

        xut = xi';
        yut = yu';
        oup = [xut yut];

        [n,~] = size(oup);
        tmp = zeros(n,1);
        newCol = 1*ones(size(tmp));
        oup = [oup newCol];

        xdt = xi';
        ydt = yd';
        odown = [xdt ydt];

        newCol = 2*ones(size(tmp));
        odown = [odown newCol];
        odownsort = sortrows(odown,'descend');
        output = [oup; odownsort];
        
        [n,~] = size(output);
        for i=1:n
            output(i,1) = (((output(i,1)/mX) + deltaX)*10^-3)/(10^2); 
            output(i,2) = (((output(i,2)/mY) + deltaY)*10^6)/(10^3); 
        end

        for i=101:n
            e2 = output(i,1);
            p2 = output(i,2);
            if (i == 101)
                Pss = p2;
            end
            if (i>101)
                e1 = output(i-1,1);
                p1 = output(i-1,2);
                if (e2 <= 0 && e1 > 0)
                    m = (p2-p1)/(e2-e1);
                    c = p2-m*e2;
                    Prs = c;
                end
            end
        end

        for i=101:n
            e2 = output(i,1);
            p2 = output(i,2);
            if (i>101)
                e1 = output(i-1,1);
                p1 = output(i-1,2);
                if (p2 <= 0 && p1 > 0)
                    m = (p2-p1)/(e2-e1);
                    c = p2-m*e2;
                    Ecs = abs(-c/m);
                end
            end
        end
                        
        xoutput = output(:,1);
        youtput = output(:,2);

        figure('Visible', 'on');
                
        plot(xoutput,youtput,'k-','LineWidth',1);

        xlabel('E (kV/cm)');
        ylabel('P (\muC/cm^2)');
        title(expTitle);
        
        grid on;
        set(gcf,'color','w');
        
        ax = gca;
        ax.GridLineStyle = '-';
        ax.GridColor = 'k';
        ax.GridAlpha = 0.5;

        lgd = legend('Gaussian-Cauchy');
        lgd.Location = 'southeast';
        hold off;
        
        disp("Ps Gaussian-Cauchy = " + num2str(Pss));
        disp("Pr Gaussian-Cauchy = " + num2str(Prs));
        disp("Ec Gaussian-Cauchy = " + num2str(Ecs));

        disp("deltaX = " + num2str(deltaX));
        disp("mX = " + num2str(mX));
        disp("deltaY = " + num2str(deltaY));
        disp("mY = " + num2str(mY));
    end
end