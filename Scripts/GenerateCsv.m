function GenerateCsv(folder, extension)
    clc;
    format long;
    
    list = "../" + folder + "/*." + extension;
    listing = dir(list);
    [n,~]=size(listing);
    csv = [];
    ncol = 1;
    ncol1 = 1;
    ncol2 = 2;
    header = "";
    headerTrain = "";
    headerLabels = "";
    maxSigma = 1.2;
    maxEta = 1.2;
    
    prog = 0;
    fprintf(1,'Reading Progress: %3d%%\n',prog);
    for i = 1:n
        prog = (100*(i/n));
        fprintf(1,'\b\b\b\b%3.0f%%',prog);
    
        fname = listing(i).name;
        fr = "../" + folder + "/" + fname;
        
        fid = fopen(fr,'rt');
        tline = fgetl(fid);
        
        delimiter = '=';
        sigmac = 0;
        sigma = 0;
        eta = 0;
        tmp = [];
        ctmp = [];
        j = 1;
        while ischar(tline)
            val = strsplit(tline,delimiter);
            if (val(1) == "sigmac")
                sigmac = str2double(val(2));
            elseif (val(1) == "sigma")
                sigma = str2double(val(2));
            elseif (val(1) == "eta")
                eta = str2double(val(2));
            elseif (val(1) ~= "x0" && val(1) ~= "y0" && val(1) ~= "sigmam" && val(1) ~= "nSpline" && val(1) ~= "nc" && val(1) ~= "nHysterons")
                cval = strsplit(tline,",");
                ctmp(j) = str2double(cval(2));
                j = j + 1;
            end
            tline = fgetl(fid);
        end
        for k = 1:j-1
            tmp(1,k) = ctmp(k);
            if (i == 1)
                if (header == "")
                    header = header + "E" + k;
                    headerTrain = headerTrain + "E" + k;
                else
                    header = header + ",E" + k;
                    headerTrain = headerTrain + ",E" + k;
                end
            end
        end
        
        if (folder == "gc" || folder == "cc")
            tmp(1,j) = sigmac;
            csv = [csv; tmp];
            ncol = j;

            if (i == 1)
                header = header + ",sigmac";
                headerLabels = "sigmac";
            end
        else
            tmp(1,j) = sigma/maxSigma;
            tmp(1,j+1) = eta/maxEta;
            csv = [csv; tmp];
            ncol1 = j;
            ncol2 = j+1;
            
            if (i == 1)
                header = header + ",sigma,eta";
                headerLabels = "sigma,eta";
            end
        end
        fclose(fid);
    end
    fprintf('\n'); 
    
    if (folder == "gc" || folder == "cc")
        csv = sortrows(csv,ncol);
    else
        csv = sortrows(csv,[ncol1 ncol2]);
    end
    
    [n,~] =size(csv);
    r = randperm(n);
    output = [];
    for i = 1:n
        tmp = csv(r(i),:);
        output = [output; tmp];
    end
    
    %output = csv;    
    outputFileName = folder + ".csv";
    disp("Writing Output File = " + outputFileName);
    fid = fopen(outputFileName,'w');
    fprintf( fid, '%s\n', header);
    fclose(fid);
    dlmwrite(outputFileName,output,'-append','precision', 8);
    
    trainFileName = folder + "_train.csv";
    disp("Writing Training File = " + trainFileName);
    fid = fopen(trainFileName,'w');
    fprintf( fid, '%s\n', headerTrain);
    fclose(fid);
    if (folder == "gc" || folder == "cc")
        train = output(:,1:ncol-1);
        dlmwrite(trainFileName,train,'-append','precision', 8);
    else
        train = output(:,1:ncol1-1);
        dlmwrite(trainFileName,train,'-append','precision', 8);
    end
    
    labelsFileName = folder + "_labels.csv";
    disp("Writing Labels File = " + labelsFileName);
    fid = fopen(labelsFileName,'w');
    fprintf( fid, '%s\n', headerLabels);
    fclose(fid);
    if (folder == "gc" || folder == "cc")
        labels = output(:,ncol);
        dlmwrite(labelsFileName,labels,'-append','precision', 8);
    else
        labels = output(:,ncol1:ncol2);
        dlmwrite(labelsFileName,labels,'-append','precision', 8);
    end
end