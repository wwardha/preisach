function [x0,y0,maxa,A,B,C,nSpline,nc,nLevel,sf,nHysterons,mu,type] = ReadPolynomialFile(path, file, w)
    type = file(1);
    fid = fopen(fullfile(path,file),'rt');
    tline = fgetl(fid);
    i = 1;

    delimiter = '=';
    sf = 1;
    while ischar(tline)
        tmp = strsplit(tline,delimiter);
        if (tmp(1) == "x0")
            x0 = str2double(tmp(2));
        elseif (tmp(1) == "y0")
            y0 = str2double(tmp(2));
        elseif (tmp(1) == "maxa")
            maxa = str2double(tmp(2));
        elseif (tmp(1) == "A")
            A = str2double(tmp(2));
        elseif (tmp(1) == "B")
            B = str2double(tmp(2));
        elseif (tmp(1) == "C")
            C = str2double(tmp(2));
        elseif (tmp(1) == "nSpline")
            nSpline = str2double(tmp(2));
        elseif (tmp(1) == "nc")
            nc = str2double(tmp(2));
        elseif (tmp(1) == "nLevel")
            nLevel = str2double(tmp(2));
        elseif (tmp(1) == "sf")
            sf = str2double(tmp(2));
        elseif (tmp(1) == "nHysterons")
            nHysterons = str2double(tmp(2));
            delimiter = ',';
        else
            mu(1,i) = str2double(tmp(1));
            mu(2,i) = str2double(tmp(2));
            mu(3,i) = str2double(tmp(3));   
            
            s1 = 'Reading File...';
            s2 = num2str(floor((i/nHysterons)*100));
            s3 = '%';
            waitbar(i/nHysterons,w,[s1 s2 s3]);
                        
            i = i + 1;
        end

        tline = fgetl(fid);
    end
    fclose(fid);
    waitbar(1,w,'Finish Reading File');
    close(w); 
end
