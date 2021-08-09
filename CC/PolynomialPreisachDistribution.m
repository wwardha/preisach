function [result, iter] = PolynomialPreisachDistribution(a0, A, B, C, x0, y0, nSpline, nc, nLevel, iter)   
    h(1) = figure('Visible', 'off');
    ndeg = (1 + iter * 0.5) * 360;
    [X,Y] = meshgrid((-a0:.2:a0));
    Z = A*(X-x0).^2 + B*(Y-y0).^2 + C;
    
    [xnew, ynew] = meshgrid(linspace(-a0,a0,nSpline));
    znew = interp2(X,Y,Z,xnew,ynew, 'spline');
    
    minz = min(znew, [], 'all');
    maxz = max(znew, [], 'all');
        
    disp('Calculating Contours');
    set(0, 'CurrentFigure', h(1))
    c0 = contour(xnew,ynew,znew,(minz:0.05:minz+0.05+nLevel)); hold on;
    ct0 = getContourLineCoordinates(c0);
    cm0 = table2array(ct0(:,2:4));    
    [cmax,~]=size(cm0);
    gmax = cm0(cmax,1);

    group = gmax;
    cmti=LinesIntersection(a0,x0,y0,cm0,group,ndeg); 
    
    cmo = [];
    n0 = minz + nLevel + 0.1;
    gmaxc = gmax;
    for n = 1:nc
        n1 = n0 +(n/nc) * maxz;        
        if n1 > maxz
            break;
        end        
        delta = (n1 - n0)/10;
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
    disp('Calculating Hysterons Position');
    cmtc=LinesIntersection(a0,x0,y0,cmo,group,ndeg);         
    
    result = [cmti;cmtc];
    iter = iter + 1;
end
