function GeneratePolynomialFiles(maxa, A, B, C, nSpline, nc, nLevel, nHysterons, sf)
    clc;

    iter = 0;
    delta = (maxa*2/20);
    cin = [];
    n = 0;
    for x=-maxa:delta:maxa
        for y=-maxa:delta:maxa
            cin(1,n+1) = x;
            cin(2,n+1) = y;
            n=n+1;
        end
    end

    cp = zeros(3,2);
    cp(1,:) = [-maxa, maxa];
    cp(2,:) = [-maxa, -maxa];
    cp(3,:) = [maxa, maxa];

    xq = cin(1,:);
    yq = cin(2,:);
    xv = cp(:,1);
    yv = cp(:,2);

    [in,~] = inpolygon(xq,yq,xv,yv);
    inq = [];
    inq(:,1) = xq(in);
    inq(:,2) = yq(in);

    inp = [];
    [nmax,~]=size(inq);

    i = 0;
    for n=1:nmax
        if (inq(n,1) ~= 0 && inq(n,2) ~= 0)
            inp(i+1,1) = inq(n,1);
            inp(i+1,2) = inq(n,2);
            i = i+1;
        end
    end

    [nmax,~]=size(inp);
    for n=1:nmax
        x0 = inp(n,1);
        y0 = inp(n,2);

        s1 = 'x0=';
        s2 = num2str(x0);
        s3 = ',y0=';
        s4 = num2str(y0);
        s5 = num2str(sf);
        s6 = num2str(nHysterons);
        
        o1 = strrep(s2,".","");
        o1 = strrep(o1,"-","M");
        o2 = strrep(s4,".","");
        o2 = strrep(o2,"-","M");
        o3 = strrep(s5,".","");
        o3 = "SF"+o3;
        o4 = "NC"+s6;
        o5 = ".dat";
        outputFileName = "P"+"X"+o1+"Y"+o2+o3+o4+o5;
        
        if isfile(outputFileName)
            disp(outputFileName + ' is already exists');
        else
            disp([s1 s2 s3 s4]);
            mu = GeneratePolynomialPreisachDistribution(maxa, A, B, C, x0, y0, nSpline, nc, nLevel, nHysterons, sf, iter);
            out = [];
            out(:,1) = mu(1,:);
            out(:,2) = mu(2,:);
            out(:,3) = mu(3,:);

            disp('Writing Output File');

            fid = fopen(outputFileName,'w');
            fprintf( fid, '%s\n', "x0="+num2str(x0));
            fprintf( fid, '%s\n', "y0="+num2str(y0));
            fprintf( fid, '%s\n', "maxa="+num2str(maxa));
            fprintf( fid, '%s\n', "A="+num2str(A));
            fprintf( fid, '%s\n', "B="+num2str(B));
            fprintf( fid, '%s\n', "C="+num2str(C));
            fprintf( fid, '%s\n', "nSpline="+num2str(nSpline));
            fprintf( fid, '%s\n', "nc="+num2str(nc));
            fprintf( fid, '%s\n', "nLevel="+num2str(nLevel));
            fprintf( fid, '%s\n', "sf="+num2str(sf));
            fprintf( fid, '%s\n', "nHysterons="+num2str(nHysterons));
            fclose(fid);

            dlmwrite(outputFileName,out,'-append','precision', 32);
        end
    end

    disp('Finished');
end
