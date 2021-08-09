function [result] = GeneratePolynomialPreisachDistribution(a0, A, B, C, x0, y0, nSpline, nc, nLevel, nHysterons, sf, iter)
    id = 'MATLAB:colon:nonIntegerIndex';
    warning('off',id);

    [cm, iter] = PolynomialPreisachDistribution(a0, A, B, C, x0, y0, nSpline, nc, nLevel, iter); 
    disp('Calculating number of hysterons');          
    cp = zeros(3,2);
    cp(1,:) = [-a0, a0];
    cp(2,:) = [-a0, -a0];
    cp(3,:) = [a0, a0];
    
    xq = cm(:,1);
    yq = cm(:,2);
    gq = cm(:,3);
    dq = cm(:,4);
    xv = cp(:,1);
    yv = cp(:,2);

    [in,~] = inpolygon(xq,yq,xv,yv);
    
    inq = [];
    inq(:,1) = yq(in);
    inq(:,2) = xq(in);
    inq(:,3) = gq(in);
    inq(:,4) = dq(in);
    
    mu = [];
    mu(1,:) = yq(in);
    mu(2,:) = xq(in);
    mu(3,:) = -1;
        
    [~,cin]=size(mu);
    if (cin > nHysterons) 
        mui = [];
        muout = [];
        [nmax,~] = size(inq); 
        gmax = inq(nmax,3)*sf;
        
        iin = 0;
        iout = 0;
        for n=1:nmax
            g = inq(n,3);
            d = inq(n,4);
            if (g > 0 && g <= fix(gmax*0.2))
                mui(1,iin+1) = inq(n,1);
                mui(2,iin+1) = inq(n,2);
                mui(3,iin+1) = -1;
                iin = iin+1;                      
            elseif (g > fix(gmax*0.2) && g <= fix(gmax*0.4))
                if (rem(d,3) == 0)
                    muout(1,iout+1) = inq(n,1);
                    muout(2,iout+1) = inq(n,2);
                    muout(3,iout+1) = -1;
                    iout = iout+1;
                end
            elseif (g > fix(gmax*0.4) && g <= fix(gmax*0.6))
                if (rem(d,6) == 0)
                    muout(1,iout+1) = inq(n,1);
                    muout(2,iout+1) = inq(n,2);
                    muout(3,iout+1) = -1;
                    iout = iout+1;
                end
            elseif (g > fix(gmax*0.6) && g <= fix(gmax*0.8))
                if (rem(d,9) == 0)
                    muout(1,iout+1) = inq(n,1);
                    muout(2,iout+1) = inq(n,2);
                    muout(3,iout+1) = -1;
                    iout = iout+1;
                end
            elseif (g > fix(gmax*0.8) && g <= gmax)
                if (rem(d,12) == 0)
                    muout(1,iout+1) = inq(n,1);
                    muout(2,iout+1) = inq(n,2);
                    muout(3,iout+1) = -1;
                    iout = iout+1;
                end
            end
        end
        nout = iout;
        nin = nHysterons - nout;
        [~,cin]=size(mui);
        delta = cin/nin;
        muin = mui(:,1:delta:cin);
        result = [muin,muout];
        
        [~,cin]=size(result);
        if (cin < (nHysterons))
            dcin = nHysterons-cin;
            madd = [];
            for n=1:dcin
                madd(1,n) = inq(nmax-(n-1),1);
                madd(2,n) = inq(nmax-(n-1),2);
                madd(3,n) = -1;
            end
            
            result = [result,madd];
        end           
    else
        result = GeneratePolynomialPreisachDistribution(a0, A, B, C, x0, y0, nSpline, nc, nLevel, nHysterons, sf, iter);
    end
end