function timer_callback(obj, ~, n, weight)
    value = (2*pi*obj.UserData.('freq')*(obj.UserData.('time')/(2*obj.UserData.('freq')*obj.UserData.('iter'))))-(pi/2);
    volt = obj.UserData.('volt') * sin(value);
            
    obj.UserData.('count') = obj.UserData.('count') + 1;
    count = obj.UserData.('count');
    uNew = obj.UserData.('uNew');
    uNew(count) = volt;
    
    out = obj.UserData.('out');
    mu = obj.UserData.('mu');
    
    [f(count),mu] = DiscretePreisach(count, uNew, mu, n, weight, false);
    data = [uNew(count) f(count)];
    out = [out; data];
    
    obj.UserData.('out') = out; 
    obj.UserData.('mu') = mu;
    obj.UserData.('uNew') = uNew;
    obj.UserData.('time') = obj.UserData.('time') + 1;
end