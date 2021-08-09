function GenerateDATFiles(startSigma, endSigma, deltaSigma, startEta, endEta, deltaEta)
    clc;

    a0 = 5;
    x0 = -5.5;
    y0 = 5.5;
    nSpline = 500;
    nc = 100;
    uNew = [];

    iteration = 0;
    for sigma = startSigma:deltaSigma:endSigma
        for eta = startEta:deltaEta:endEta   
            iteration = iteration + 1;
            disp("Sigma = "+num2str(sigma));
            disp("Eta = "+num2str(eta));
            disp("Iteration = " + num2str(iteration));

            s1 = num2str(sigma);
            s2 = num2str(eta);
            o1 = strrep(s1,".","P");
            o2 = strrep(s2,".","P");
            o3 = ".dat";
            outputFileName = "DAT"+"S"+o1+"E"+o2+o3;
            
            if isfile(outputFileName)
                disp(outputFileName + ' is already exists');
            else
                nHysterons = 50000;
                disp('Generate Preisach Distribution');
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

                disp('Writing Output File = ' + outputFileName);

                fid = fopen(outputFileName,'w');
                fprintf( fid, '%s\n', "x0="+num2str(x0));
                fprintf( fid, '%s\n', "y0="+num2str(y0));
                fprintf( fid, '%s\n', "sigma="+num2str(sigma));
                fprintf( fid, '%s\n', "eta="+num2str(eta));
                fprintf( fid, '%s\n', "nSpline="+num2str(nSpline));
                fprintf( fid, '%s\n', "nc="+num2str(nc));
                fprintf( fid, '%s\n', "nHysterons="+num2str(nHysterons));
                fclose(fid);

                dlmwrite(outputFileName,output,'-append','precision', 8);
            end
        end
    end
end

