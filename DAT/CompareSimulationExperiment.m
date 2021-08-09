function CompareSimulationExperiment(filename, model, expname)
    clc;
    format long;
    
    a0 = 5;
    x0 = -5.5;
    y0 = 5.5;
    nSpline = 500;
    nc = 100;
    nHysterons = 50000;
    maxSigma = 1.2;
    maxEta = 1.2;
    Ecs = 0;
    Ece = 0;
    Prs = 0;
    Pre = 0;
    Pss = 0;
    Pse = 0;
    
    expTitle = "";
    iname = 0;
    if (expname == "ZnOLi0")
        expTitle = "ZnO";
        iname = 1;
    elseif(expname == "ZnOLi1")
        expTitle = "ZnO:Li 1%";
        iname = 2;
    elseif(expname == "ZnOLi3")
        expTitle = "ZnO:Li 3%";
        iname = 3;
    elseif(expname == "ZnOLi6")
        expTitle = "ZnO:Li 6%";
        iname = 4;
    elseif(expname == "ZnOLiAldrich")
        expTitle = "ZnO Aldrich";
        iname = 5;
    end
    
    if (model == "dat")
        fr = "../output/" + filename;
        dat = readmatrix(fr);
        iexp = dat(:,203)==iname;
        
        sigma = mean(dat(iexp,208)) * maxSigma;
        eta = mean(dat(iexp,209)) * maxEta;
        deltaX = mean(dat(iexp,204));
        mX = mean(dat(iexp,205));
        deltaY = mean(dat(iexp,206));
        mY = mean(dat(iexp,207));
        
        yexp = [];
        for i = 1:202
            tmp = mean(dat(iexp,i));
            tmp = (((tmp/mY) + deltaY)*10^6)/(10^3); 
            yexp = [yexp; tmp];
        end
        
        uNew = [];
        if (sigma < 0.0001)
            sigma = 0.0001;
        end

        if (eta < 0.0001)
            eta = 0.0001;
        end
        
        disp('Generate Preisach Distribution for ' + fr + ' with sigma = ' + sigma + ', eta = ' + eta);
        mu = GenerateDATPreisachDistribution(a0, sigma, eta, x0, y0, nSpline, nc, 0);
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
        
        for i=101:n
            e2 = output(i,1);
            p2 = yexp(i,1);
            if (i == 101)
                Pse = p2;
            end
            if (i>101)
                e1 = output(i-1,1);
                p1 = yexp(i-1,1);
                if (e2 <= 0 && e1 > 0)
                    m = (p2-p1)/(e2-e1);
                    c = p2-m*e2;
                    Pre = c;
                end
            end
        end
        
        for i=101:n
            e2 = output(i,1);
            p2 = yexp(i,1);
            if (i>101)
                e1 = output(i-1,1);
                p1 = yexp(i-1,1);
                if (p2 <= 0 && p1 > 0)
                    m = (p2-p1)/(e2-e1);
                    c = p2-m*e2;
                    Ece = abs(-c/m);
                end
            end
        end
        
        xoutput = output(:,1);
        youtput = output(:,2);

        figure('Visible', 'on');
        
        plot(xoutput,yexp,'ks','MarkerSize',4);
        hold on;
        
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

        lgd = legend('Experiment','DAT');
        lgd.Location = 'southeast';
        hold off;
        
        disp("Ps DAT = " + num2str(Pss));
        disp("Pr DAT = " + num2str(Prs));
        disp("Ec DAT = " + num2str(Ecs));
        disp("Ps Experiment = " + num2str(Pse));
        disp("Pr Experiment = " + num2str(Pre));
        disp("Ec Experiment = " + num2str(Ece));

        disp("deltaX = " + num2str(deltaX));
        disp("mX = " + num2str(mX));
        disp("deltaY = " + num2str(deltaY));
        disp("mY = " + num2str(mY));
    end
end