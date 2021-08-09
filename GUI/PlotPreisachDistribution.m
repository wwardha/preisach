clc;
clear;

a0 = 5;
A = 10;
B = 10;
C = 100;
x0 = -2;
deltay = 2;
nSpline = 500;
nc = 200;

[cm, h] = PolynomialPreisachDistribution(a0, A, B, C, x0, deltay, nSpline, nc); 
cp = zeros(3,2);
cp(1,:) = [-a0, a0];
cp(2,:) = [-a0, -a0];
cp(3,:) = [a0, a0];

xq = cm(:,1);
yq = cm(:,2);
xv = cp(:,1);
yv = cp(:,2);

[in,~] = inpolygon(xq,yq,xv,yv);

cr = [];
cr(:,1) = xq(in);
cr(:,2) = yq(in);

h(1) = figure; 
plot(cr(:,1),cr(:,2),'ko','MarkerSize',1,'LineStyle', 'none');
daspect([1 1 1]);
xticks(-a0:2*a0/5:a0); 
