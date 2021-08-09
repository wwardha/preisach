function [norm, categ] = NormalizeOutputParameter(val)
    n = Order(val, 10);

    if (n >= 0)
        norm = val/(10^(n+1));
        categ = n + 1;
    else
        norm = val;
        categ = 0;
    end
end