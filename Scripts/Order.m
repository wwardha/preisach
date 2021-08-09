function n = Order( val, base )
if nargin < 2
    base = 10;
end
n = floor(log(abs(val))./log(base));