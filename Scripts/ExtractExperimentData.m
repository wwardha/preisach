function ExtractExperimentData(folder, filename, nexp)
    clc;
    format long;
    f = figure('Visible', 'on');

    XBOUND = 5;
    YBOUND = 50000;

    csv = [];
    header = "";
    iname = 0;    

    if (filename == "ZnOLi0.dat")
        iname = 1;
    elseif(filename == "ZnOLi1.dat")
        iname = 2;
    elseif(filename == "ZnOLi3.dat")
        iname = 3;
    elseif(filename == "ZnOLi6.dat")
        iname = 4;
    elseif(filename == "ZnOLiAldrich.dat")
        iname = 5;
    end
    
    disp("Reading Experiment File = " + filename);
    fr = "../" + folder + "/" + filename;

    fid = fopen(fr,'rt');
    tline = fgetl(fid);
    data = [];
    xmin = 0;
    xmax = 0;
    while ischar(tline)
        tmp = strsplit(tline);
        dcol1 = str2double(tmp(1));
        dcol2 = str2double(tmp(2));

        if (xmin > dcol1)
            xmin = dcol1;
        end
        if (dcol1 > xmax)
            xmax = dcol1;
        end

        line = [str2double(tmp(1)) str2double(tmp(2))];
        data = [data; line];

        tline = fgetl(fid);
    end
    [n,~] = size(data);

    ymin = [];
    ymax = [];
    for i = 1:n
        if (data(i,1) == xmin)
            tmp = [data(i,2)];
            ymin = [ymin; tmp];
        elseif (data(i,1) == xmax)
            tmp = [data(i,2)];
            ymax = [ymax; tmp];
        end        
    end

    data = sortrows(data,1,'ascend');    
    ymin = sortrows(ymin,'ascend');
    ymax = sortrows(ymax,'ascend'); 

    [nmin,~] = size(ymin);
    [nmax,~] = size(ymax);

    ysmin = (ymin(1) + ymin(nmin))*0.5;
    ysmax = (ymax(1) + ymax(nmax))*0.5;

    m = (ysmax-ysmin)/(xmax-xmin);
    c = ysmax-(m*xmax);

    expdata = [];
    for i = 1:n
        xd = data(i,1);
        yd = (m*xd) + c;
        if (data(i,2) <= yd)
            tmp = [data(i,1) data(i,2) 1];
            expdata = [expdata; tmp];
        else
            tmp = [data(i,1) data(i,2) 2];
            expdata = [expdata; tmp];
        end
    end

    [n,~] = size(expdata);
    sx = expdata(1,1);
    s1 = 0;
    s2 = 0;
    s = 0;
    numdata = [];
    for i = 1:n
        x = expdata(i,1);
        if (sx ~= x)
            if (s1 <= s2 && s1 ~= 0)
                s = s1;
            elseif (s1 > s2 && s2 ~= 0)
                s = s2;
            end

            tmp = [sx s1 s2];
            numdata = [numdata; tmp];

            s1 = 0;
            s2 = 0;
            s = 0;
            sx = x;
        end
        if (expdata(i,3) == 1)
            s1 = s1 + 1;
        else
            s2 = s2 + 1;
        end
    end

    tmp = [sx s1 s2];
    numdata = [numdata; tmp];

    [n,~] = size(numdata);
    upexp = [];
    downexp = [];
    for e = 1:nexp 
        for i = 1: n
            x = numdata(i,1);
            s1 = numdata(i,2);
            s2 = numdata(i,3);
            if (s1 > 0 && s2 > 0)
                inum = numdata(:,1)==x;
                r1 = numdata(inum,2);
                rnum = randsample(r1,1);

                iexp = find(expdata(:,1)==x & expdata(:,3)==1);
                ix = iexp(rnum,1);
                xup = expdata(ix,1);
                yup = expdata(ix,2);
                tmp = [e xup yup];
                upexp = [upexp; tmp];

                r2 = numdata(inum,3);
                rnum = randsample(r2,1);
                iexp = find(expdata(:,1)==x & expdata(:,3)==2);
                ix = iexp(rnum,1);
                xdown = expdata(ix,1);
                ydown = expdata(ix,2);
                tmp = [e xdown ydown];
                downexp = [downexp; tmp];
            elseif (s1 > 0 && s2 == 0)
                inum = numdata(:,1)==x;
                r1 = numdata(inum,2);
                r2 = r1;
                rnum = randsample(r1,1);

                iexp = find(expdata(:,1)==x & expdata(:,3)==1);
                ix = iexp(rnum,1);
                xup = expdata(ix,1);
                yup = expdata(ix,2);
                tmp = [e xup yup];
                upexp = [upexp; tmp];

                rnum = randsample(r2,1);
                iexp = find(expdata(:,1)==x & expdata(:,3)==1);
                ix = iexp(rnum,1);
                xdown = expdata(ix,1);
                ydown = expdata(ix,2);
                tmp = [e xdown ydown];
                downexp = [downexp; tmp]; 
            elseif (s1 == 0 && s2 > 0)
                inum = numdata(:,1)==x;
                r2 = numdata(inum,3);
                r1 = r2;
                rnum = randsample(r1,1);

                iexp = find(expdata(:,1)==x & expdata(:,3)==2);
                ix = iexp(rnum,1);
                xup = expdata(ix,1);
                yup = expdata(ix,2);
                tmp = [e xup yup];
                upexp = [upexp; tmp];

                rnum = randsample(r2,1);
                iexp = find(expdata(:,1)==x & expdata(:,3)==2);
                ix = iexp(rnum,1);
                xdown = expdata(ix,1);
                ydown = expdata(ix,2);
                tmp = [e xdown ydown];
                downexp = [downexp; tmp];                 
            end 
        end
    end

    for ix = 1:nexp
        iup = upexp(:,1)==ix;    
        up = upexp(iup,:);
        idown = downexp(:,1)==ix; 
        down = downexp(idown,:);

        delta = (xmax-xmin)/100;
        xi = xmin:delta:xmax;

        XU = up(:,2);
        YU = up(:,3);
        yu = interp1(XU,YU,xi);

        XD = down(:,2);
        YD = down(:,3);
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

        minx = min(output(:,1), [], 'all');
        maxx = max(output(:,1), [], 'all');
        deltaX = maxx-((maxx-minx)/2);
        mX = XBOUND/(maxx-deltaX);

        miny = min(output(:,2), [], 'all');
        maxy = max(output(:,2), [], 'all');
        deltaY = maxy-((maxy-miny)/2);
        mY = YBOUND/(maxy-deltaY);

        [n,~] = size(output);
        for i=1:n
            output(i,1) = (output(i,1) - deltaX)*mX; 
            output(i,2) = (output(i,2) - deltaY)*mY; 
        end

        xoutput = output(:,1);
        youtput = output(:,2);

        plot(xoutput,youtput,'k*');
        xlabel('E (V/m)');
        ylabel('P (C/m^2)');
        
        tmp = [];
        for k = 1:n
            tmp(1,k) = output(k,2);
            if (ix == 1)
                if (header == "")
                    header = header + "E" + k;
                else
                    header = header + ",E" + k;
                end
            end
        end
        if (ix == 1)
            header = header + ",fname,deltaX,mX,deltaY,mY";
        end
        tmp(1, n+1) = iname;
        tmp(1, n+2) = deltaX;
        tmp(1, n+3) = mX;
        tmp(1, n+4) = deltaY;
        tmp(1, n+5) = mY;
        csv = [csv; tmp];
    end
    
    %{
    [n,~] =size(csv);
    r = randperm(n);
    output = [];
    for i = 1:n
        tmp = csv(r(i),:);
        output = [output; tmp];
    end
    %}
    
    output = csv;
    
    outputFileName = folder + "_" + strrep(filename,".dat","") + "_" + nexp +".csv";
    disp("Writing Output File = " + outputFileName);
    fid = fopen(outputFileName,'w');
    fprintf(fid, '%s\n', header);
    fclose(fid);
    dlmwrite(outputFileName,output,'-append','precision', 8);    
end