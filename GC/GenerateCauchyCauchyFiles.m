function GenerateCauchyCauchyFiles(startSigma, endSigma, delta)
    sigmam = 1000000;
    a0 = 5;
    x0 = -5;
    y0 = 5;
    nSpline = 500;
    nc = 100;
    uNew = [];

    for sigma = startSigma:delta:endSigma
        if (sigma == delta*100)
            delta = delta*10;
            startSigma = sigma;
            break;
        else
            disp("SigmaC = "+num2str(sigma));

            nHysterons = 50000;
            sigmac = sigma;
            disp('Generate Preisach Distribution');
            mu = GenerateCauchyCauchyPreisachDistribution(a0, sigmam, sigmac, x0, y0, nSpline, nc, 0);
            [~,col]=size(mu);
            n = double(col);
            weight = nHysterons/n;

            iter = 100;
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

            format long;

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

            s1 = num2str(sigmam);
            s2 = num2str(sigmac);
            o1 = strrep(s1,".","");
            o2 = strrep(s2,".","");
            o3 = ".dat";
            outputFileName = "CC"+"M"+o1+"C"+o2+o3;
            disp('Writing Output File = ' + outputFileName);

            fid = fopen(outputFileName,'w');
            fprintf( fid, '%s\n', "x0="+num2str(x0));
            fprintf( fid, '%s\n', "y0="+num2str(y0));
            fprintf( fid, '%s\n', "sigmam="+num2str(sigmam));
            fprintf( fid, '%s\n', "sigmac="+num2str(sigmac));
            fprintf( fid, '%s\n', "nSpline="+num2str(nSpline));
            fprintf( fid, '%s\n', "nc="+num2str(nc));
            fprintf( fid, '%s\n', "nHysterons="+num2str(nHysterons));
            fclose(fid);

            dlmwrite(outputFileName,output,'-append','precision', 8);
        end 
    end
    if (sigma < endSigma)
        GenerateCauchyCauchyFiles(startSigma, endSigma, delta);
    end
end

