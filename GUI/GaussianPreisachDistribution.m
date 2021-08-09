function [result, iter] = GaussianPreisachDistribution(a0, sigma, x0, y0, nSpline, nc, iter, f)   
    h(1) = figure('Visible', 'off');
    ndeg = (1 + iter * 0.5) * 360;
    [X,Y] = meshgrid((-a0:(a0/25):a0));
    
    A = ((X-x0)/sigma).^2;
    B = ((Y-y0)/sigma).^2;
    C = 1/(sqrt(2*pi)*sigma);
    Z = C.*exp(-(A+B));

    [xnew, ynew] = meshgrid(linspace(-a0,a0,nSpline));
    znew = interp2(X,Y,Z,xnew,ynew, 'spline');
    
    minz = min(znew, [], 'all');
    maxz = max(znew, [], 'all');
    
    cmo = [];
    n0 = minz;
    gmaxc = 0;
    for n = 1:nc
        n1 = n0 +(1/nc) * (maxz-minz);  
        delta = (n1 - n0)/2;
        set(0, 'CurrentFigure', h(1))
        cc = contour(xnew,ynew,znew,(n0:delta:n1)); hold on;
        ctc = getContourLineCoordinates(cc);
        cmc = table2array(ctc(:,2:4));           
        cmc(:,1) = cmc(:,1)+gmaxc;
        [cmaxc,~]=size(cmc);
        gmaxc = cmc(cmaxc,1);
        cmo = [cmo; cmc];
        n0 = n1;    
    end

    group = gmaxc;
    result = LinesIntersection(a0,x0,y0,cmo,group,ndeg,true,f);         
        
    iter = iter + 1;
end
