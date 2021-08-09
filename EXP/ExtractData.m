function ExtractData(filename)
clc;

format long;
fid = fopen(filename,'rt');
tline = fgetl(fid);
data = [];
i = 1;
col1 = 0;
col2 = 0;
xmin = 0;
xmax = 0;

expTitle = "";

if (filename == "ZnOLi0.dat")
    expTitle = "ZnO";
elseif(filename == "ZnOLi1.dat")
    expTitle = "ZnO:Li 1%";
elseif(filename == "ZnOLi3.dat")
    expTitle = "ZnO:Li 3%";
elseif(filename == "ZnOLi6.dat")
    expTitle = "ZnO:Li 6%";
elseif(filename == "ZnOLiAldrich.dat")
    expTitle = "ZnO Aldrich";
end

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

[n,~] = size(raw);
for i=1:n
    raw(i,1) = (raw(i,1)*10^-3)/(10^2); 
    raw(i,2) = (raw(i,2)*10^6)/(10^3); 
end

xoutput = raw(:,1);
youtput = raw(:,2);

f = figure('Visible', 'on');

plot(xoutput,youtput,'ks','MarkerSize',4);
xlabel('E (kV/cm)');
ylabel('P (\muC/cm^2)');
title(expTitle);

grid on;
set(gcf,'color','w');

ax = gca;
ax.GridLineStyle = '-';
ax.GridColor = 'k';
ax.GridAlpha = 0.5;

end
