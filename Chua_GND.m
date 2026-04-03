function output = Chua_GND(t,x)   
%===================GNN=========================
p = 9;            
q = 100/7;        
a = -8/7;         
b = -5/7; 

dx = zeros(6,1);
W = Noise(t,x);  
lambda = 5;


[y_m_xm] = chua_master(x(1:3), p, q, a, b);
[y_s_xs] = chua_slave(x(4:6), p, q, a, b);

E = x(4:6) - x(1:3);

dot_E_x = [1 0 0 -1 0 0; 0 1 0 0 -1 0; 0 0 1 0 0 -1]; 

dot_x = -lambda * dot_E_x*(dot_E_x)'* E;        

v = y_m_xm - y_s_xs + dot_x;       

dx(1:3) = y_m_xm; 
dx(4:6) = y_s_xs + W + v; 

output = [dx;v];

end