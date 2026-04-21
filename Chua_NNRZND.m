function output = Chua_NNRZND(t,x)

p_chua = 9;            
q_chua = 100/7;        
a_chua = -8/7;         
b_chua = -5/7; 

dx = zeros(6,1);
W = Noise(t,x); 

[y_m_xm] = chua_master(x(1:3), p_chua, q_chua, a_chua, b_chua);
[y_s_xs] = chua_slave(x(4:6), p_chua, q_chua, a_chua, b_chua);

E = x(4:6) - x(1:3);

inte_GE = x(7:9); 

w1 = 1.0;     
w2 = 1.0;     
k1 = 1.0;     
k2 = 1.0;     
p_npaf = 1.0; 
q_npaf = 0.5; 

exponent1 = 1 + q_npaf * sign(abs(E) - 1);

term1_E = k1 .* (abs(E).^exponent1) .* sign(E);
term2_E = k2 .* E .* exp(abs(E) + p_npaf);
GE = term1_E + term2_E;

inner_arg = E + w1 * inte_GE;
exponent2 = 1 + q_npaf * sign(abs(inner_arg) - 1);
term1_inner = k1 .* (abs(inner_arg).^exponent2) .* sign(inner_arg);
term2_inner = k2 .* inner_arg .* exp(abs(inner_arg) + p_npaf);
G_inner = term1_inner + term2_inner;

dot_x = -w1 * GE - w2 * G_inner;
v = -y_s_xs + y_m_xm + dot_x;

dx(1:3) = y_m_xm;
dx(4:6) = y_s_xs + W + v;

output = [dx; GE]; 
persistent last_print
    if isempty(last_print) || toc(last_print) > 1  
        fprintf('NNRZND model is computing... Current simulation time t = %.2f\n', t);
        last_print = tic;
    end
end