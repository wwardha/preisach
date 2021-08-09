function [cmt] = LinesIntersection(a0, x0, y0, cm, group, ncircle)
    i=0;
    cmt=[];
    for g=1:group
        cmf=find(cm(:,1)==g);
        xc=cm(min(cmf):max(cmf),2);
        yc=cm(min(cmf):max(cmf),3);
        [nc,~]=size(cmf);
        
        circle = zeros(ncircle,2);
        for n = 1:ncircle
            circle(n,1) = x0 + 2*a0*cos(deg2rad((n/ncircle)*360));
            circle(n,2) = y0 + 2*a0*sin(deg2rad((n/ncircle)*360));        
        end
        xcircle=circle(:,1);
        ycircle=circle(:,2);
        [ncircle,~]=size(circle);
    
        for n=1:ncircle
            for m=1:nc-1                
                lines=[x0,y0;xcircle(n),ycircle(n);xc(m),yc(m);xc(m+1),yc(m+1)];
                p=linlinintersect(lines);
                if (~isnan(p))
                    if (p(1)>=x0&&p(1)<=xcircle(n)&&x0<xcircle(n)) && ...
                       (p(1)>=xc(m)&&p(1)<=xc(m+1)&&xc(m)<xc(m+1))
                        cmt(i+1,1)=p(1);
                        cmt(i+1,2)=p(2);
                        cmt(i+1,3)=g;
                        cmt(i+1,4)=n;
                        i=i+1;
                    elseif (p(1)>=xcircle(n)&&p(1)<=x0&&xcircle(n)<x0) && ...
                           (p(1)>=xc(m+1)&&p(1)<=xc(m)&&xc(m+1)<xc(m))
                        cmt(i+1,1)=p(1);
                        cmt(i+1,2)=p(2);
                        cmt(i+1,3)=g;
                        cmt(i+1,4)=n;
                        i=i+1;
                    elseif (p(1)>=x0&&p(1)<=xcircle(n)&&x0<xcircle(n)) && ...
                           (p(1)>=xc(m+1)&&p(1)<=xc(m)&&xc(m+1)<xc(m))
                        cmt(i+1,1)=p(1);
                        cmt(i+1,2)=p(2);
                        cmt(i+1,3)=g;
                        cmt(i+1,4)=n;
                        i=i+1;
                    elseif (p(1)>=xcircle(n)&&p(1)<=x0&&xcircle(n)<x0) && ...
                           (p(1)>=xc(m)&&p(1)<=xc(m+1)&&xc(m)<xc(m+1))
                        cmt(i+1,1)=p(1);
                        cmt(i+1,2)=p(2);
                        cmt(i+1,3)=g;
                        cmt(i+1,4)=n;
                        i=i+1;
                    end
                end
            end
        end        
    end
end