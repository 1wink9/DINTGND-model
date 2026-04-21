function output = Chua_RACZND(t,x)

p = 9;            
q = 100/7;        
a = -8/7;         
b = -5/7; 


dx = zeros(6,1);
W = Noise(t,x);

[y_m_xm] = chua_master(x(1:3), p, q, a, b);
[y_s_xs] = chua_slave(x(4:6),p, q, a, b);

E = x(4:6) - x(1:3);

inte = x(7:end);
co1 = norm(E, 'fro')^pi + exp(1);
k1 = norm(inte, 'fro')^1 + exp(1);
dot_x = -co1*E - k1*inte;

v = y_m_xm - y_s_xs + dot_x;

dx(1:3) = y_m_xm ;
dx(4:6) = y_s_xs + v+ W;

output = [dx;E];
persistent last_print
    if isempty(last_print) || toc(last_print) > 1  
        fprintf('RACZND model is computing... Current simulation time t = %.2f\n', t);
        last_print = tic;
    end
end
