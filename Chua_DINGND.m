function output = Chua_DINGND(t,x)
p = 9;            
q = 100/7;        
a = -8/7;         
b = -5/7; 

dx = zeros(6,1);
W = Noise(t,x);
gamma = 10;

[y_m_xm] = chua_master(x(1:3), p, q, a, b);
[y_s_xs] = chua_slave(x(4:6),p, q, a, b);

inte1 = x(7:9);
inte2 = x(10:12);

E = x(4:6) - x(1:3);

dot_E_x = [1 0 0 -1 0 0; 0 1 0 0 -1 0; 0 0 1 0 0 -1]; 

dot_E_x_dot = dot_E_x * (dot_E_x)';

dot_x = -3*gamma*dot_E_x_dot*E-3*(gamma*dot_E_x_dot).^2*inte1-(gamma*dot_E_x_dot).^3*inte2;

v = -y_s_xs + y_m_xm + dot_x;


dx(1:3) = y_m_xm ;
dx(4:6) = y_s_xs + W + v;

output = [dx;E;inte1];


end