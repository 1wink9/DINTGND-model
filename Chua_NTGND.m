function output = Chua_NTGND(t,x) 
p = 9;            
q = 100/7;        
a = -8/7;         
b = -5/7; 

dx = zeros(6,1);
W = Noise(t,x);  
lambda = 10;
gamma = 16;

[y_m_xm] = chua_master(x(1:3), p, q, a, b);
[y_s_xs] = chua_slave(x(4:6), p, q, a, b);

E = x(4:6) - x(1:3);

dot_E_x = [1 0 0 -1 0 0; 0 1 0 0 -1 0; 0 0 1 0 0 -1]; 

inte_E = E;
inte = x(7:end);

dot_x = -lambda *dot_E_x* (dot_E_x)'* E - gamma*(E+ lambda*dot_E_x*(dot_E_x)'*inte);        

v = y_m_xm - y_s_xs + dot_x;       
    
dx(1:3) = y_m_xm; 
dx(4:6) = y_s_xs + W + v; 

output = [dx; inte_E];
persistent last_print
    if isempty(last_print) || toc(last_print) > 1  
        fprintf('NTGND model is computing... Current simulation time t = %.2f\n', t);
        last_print = tic;
    end
end