h(1) = figure('Visible', 'on');
a0=4;
x0=-2;
y0=2;
ncircle = 360;
circle = zeros(ncircle,2);
for n = 1:ncircle
    circle(n,1) = x0 + 2*a0*cos(deg2rad((n/ncircle)*360));
    circle(n,2) = y0 + 2*a0*sin(deg2rad((n/ncircle)*360));        
end 
set(0, 'CurrentFigure', h(1));
plot(circle(:,1), circle(:,2));