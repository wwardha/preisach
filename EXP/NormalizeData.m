function NormalizeData(filename)
clc;

XBOUND = 5;
YBOUND = 50000;

f = figure('Visible', 'on');

format long;
fid = fopen(filename,'rt');
tline = fgetl(fid);
data = [];
i = 1;
col1 = 0;
col2 = 0;
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
    
    if (i == 1)
        line = [str2double(tmp(1)) str2double(tmp(2))];
        data = [data; line];
        col1 = dcol1;
        col2 = dcol2;
    end
    if (dcol1 == col1 && dcol2 ~= col2 && i > 1)
        line = [str2double(tmp(1)) str2double(tmp(2))];
        data = [data; line];
        col1 = dcol1;
        col2 = dcol2;
    end
    if (dcol1 ~= col1 && dcol2 ~= col2 && i > 1)
        line = [str2double(tmp(1)) str2double(tmp(2))];
        data = [data; line];
        col1 = dcol1;
        col2 = dcol2;
    end
    tline = fgetl(fid);
    i = i + 1;
end
fclose(fid);

[n,~] = size(data);
c1 = data(1,1);
c2 = data(1,2);
raw = [];
for i=1:n
    dc1 = data(i, 1);
    dc2 = data(i, 2);
    if (i == 1)
        tmp = [dc1 dc2]; 
        raw = [raw; tmp];
    end
    if (i > 1 && dc1 ~= c1)
        if (i == 2 && data(i-1, 1) == c1 && data(i-1, 2) == c2)
            tmp = [data(i-1, 1) data(i-1, 2)];
            raw = [raw; tmp];
        end
        if (data(i-1, 1) == c1 && data(i-1, 2) ~= c2)
            tmp = [data(i-1, 1) data(i-1, 2)];
            raw = [raw; tmp];
        end
        tmp = [dc1 dc2]; 
        raw = [raw; tmp];
        c1 = dc1;
        c2 = dc2;
    end
    if (i == n)
        tmp = [dc1 dc2]; 
        raw = [raw; tmp];
    end
end

up = [];
down = [];

[n,~] = size(raw);
for i=1:n
    tmp = [raw(i, 1) raw(i, 2)];
    if (mod(i,2) == 1)
        up = [up; tmp];
    else
        down = [down; tmp];
    end
end

delta = (xmax-xmin)/100;
xi = xmin:delta:xmax;

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

minx = min(output(:,1), [], 'all');
maxx = max(output(:,1), [], 'all');
dx = (maxx-minx)/100;

miny = min(output(:,2), [], 'all');
maxy = max(output(:,2), [], 'all');
dy = (maxy-miny)/100;

xoutput = output(:,1);
youtput = output(:,2);

plot(xoutput,youtput,'k*');
xlabel('E (V/m)');
ylabel('P (C/m^2)');

%axis([minx-dx maxx+dx miny-dy maxy+dy]);
end
