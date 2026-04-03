function output = Chua_ANFOZND(t,x)
p = 9;            
q = 100/7;        
a = -8/7;         
b = -5/7; 

dx = zeros(6,1);
W = Noise(t,x); 
[y_m_xm] = chua_master(x(1:3), p, q, a, b);
[y_s_xs] = chua_slave(x(4:6), p, q, a, b);

E = x(4:6) - x(1:3); 
norm_E = norm(E, 2);

alpha = 0.8;   
gamma = 10;     
tc = 1.0;       
Delta = 1;      
zeta = 5*Delta;       

term_exp = -pi / (2 * sqrt(zeta * (zeta - Delta)));
tp = (1 - exp(term_exp)) * tc;

if t < 1e-6
    t_val = 1e-6;
else
    t_val = t;
end
t_pow_alpha_minus_1 = t_val^(alpha - 1);
t_pow_alpha_minus_1_tc = tc^(alpha - 1); % tc^(alpha-1)

Phi = zeros(3,1);
epsilon = 1e-6; 

if norm_E > 1e-8 
    sign_E = E / norm_E; 
    
    if t < tc
        denom_time = tc - t;
        if denom_time < epsilon, denom_time = epsilon; end
        
        term1 = E / denom_time;
        
        term2 = (gamma * norm_E^2 / (denom_time^2)) * sign_E;
        
        prefactor = 1 / (gamma * t_pow_alpha_minus_1_tc);
        
        Phi = prefactor * (term1 + term2);
        
    else
        
        denom_time = tp - t;
       
        if abs(denom_time) < epsilon, denom_time = -epsilon; end 
     
        term1 = E / denom_time;
        numerator_inner = gamma * t_pow_alpha_minus_1 * (norm_E^2);
        term2_scalar = zeta + numerator_inner / (denom_time^2);
        term2 = term2_scalar * sign_E;
        
        prefactor = 1 / (gamma * t_pow_alpha_minus_1);
        
        Phi = prefactor * (term1 + term2);
    end
else
    Phi = zeros(3,1);
end

dot_x_foznn = -gamma * t_pow_alpha_minus_1 * Phi;

v = y_m_xm - y_s_xs + dot_x_foznn;

dx(1:3) = y_m_xm;
dx(4:6) = y_s_xs + W + v;

output = [dx]; 

t 
end