function [result] = GenerateDATPreisachDistribution(a0, sigma, eta, x0, y0, nSpline, nc, iter, f)
    id = 'MATLAB:colon:nonIntegerIndex';
    warning('off',id);
        
    [cm, ~] = DATPreisachDistribution(a0, sigma, eta, x0, y0, nSpline, nc, iter, f);
    waitbar(1,f,'Calculating number of hysterons');
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
    
    result = mu;
    waitbar(1,f,'Finishing');
    close(f); 
end