clear; clc; close all;
format long
% ================= 1. Parameters and Initialization =================
p = 9;            
q = 100/7;        
a = -8/7;         
b = -5/7;        
x2 = [0.125; 0.625; 0.941; 0.321; 0.487; 0.965; zeros(6,1)];
tspan = [0, 10];   
opts = odeset('RelTol',1e-8,'AbsTol',1e-9);
gamma_list = 10:10:50;
num_gamma = length(gamma_list);

% Preallocate space
t_data = cell(num_gamma, 1);
err_data = cell(num_gamma, 1);
ASSRE_list = zeros(num_gamma, 1);
MSSRE_list = zeros(num_gamma, 1);

% ================= 2. Core Calculation =================
fprintf('Starting data calculation, please wait...\n');
for k = 1:num_gamma
    gamma_current = gamma_list(k);
    
    [t3, X3] = ode45(@(t,x) P_DINTGND(t,x,gamma_current), tspan, x2, opts);
    
    nerr3 = zeros(length(t3), 1); 
    for i = 1:length(t3)
        err3 = [X3(i, 4) - X3(i, 1); X3(i, 5) - X3(i, 2); X3(i, 6) - X3(i, 3)];  
        nerr3(i) = norm(err3); 
    end
    
    % Store the computed data into cell arrays
    t_data{k} = t3;
    err_data{k} = nerr3;
    
    % --- Extract and calculate steady-state error ---
    idx = find(t3 >= 5, 1); 
    if isempty(idx), idx = max(1, length(t3)-100); end
    
    T = t3(idx:end);
    ef = nerr3(idx:end);
    
    if length(T) > 1
        ASSRE_list(k) = trapz(T, ef) / max(T(end) - T(1), eps);
    else
        ASSRE_list(k) = ef(end);
    end
    MSSRE_list(k) = max(ef);
end
fprintf('Data calculation complete! Plotting...\n');

% ================= 3. Color scheme =================
my_colors = [
    220, 227, 236;  % Line 1
    245, 221, 157;  % Line 2
    128, 190, 179;  % Line 3
    177, 217, 243;  % Line 4
    226, 166, 201;  % Line 5
] / 255;

% ================= Figure 3 (a): Error curve + ASSRE legend =================
figure('Color','w', 'Position', [100, 200, 650, 500]); 
colororder(my_colors);
hold on; box on; grid on;
legend_ASSRE = cell(num_gamma, 1);
for k = 1:num_gamma
    plot(t_data{k}, err_data{k} + 1e-18, 'LineWidth', 2);
    legend_ASSRE{k} = sprintf('$$\\gamma = %d$$, ASSRE = %.2e', gamma_list(k), ASSRE_list(k));
end
set(gca, 'YScale', 'log'); 
xlabel('$t$ (s)', 'Interpreter', 'latex', 'FontSize', 20);
ylabel('$\|\mathcal{S}$(t)-$\mathcal{M}$(t)$\|_{2}$', 'Interpreter', 'latex', 'FontSize', 20);
legend(legend_ASSRE, 'Interpreter', 'latex', 'FontSize', 18, 'NumColumns', 1); 
hold off;

% ================= Figure 3(b): Error curve + MSSRE legend =================
figure('Color','w', 'Position', [780, 200, 650, 500]); 
colororder(my_colors);
hold on; box on; grid on;
legend_MSSRE = cell(num_gamma, 1);
for k = 1:num_gamma
    plot(t_data{k}, err_data{k} + 1e-18, 'LineWidth', 2);
    legend_MSSRE{k} = sprintf('$$\\gamma = %d$$, MSSRE = %.2e', gamma_list(k), MSSRE_list(k));
end
set(gca, 'YScale', 'log'); 
xlabel('$t$ (s)', 'Interpreter', 'latex', 'FontSize', 20);
ylabel('$\|\mathcal{S}$(t)-$\mathcal{M}$(t)$\|_{2}$', 'Interpreter', 'latex', 'FontSize', 20);
legend(legend_MSSRE, 'Interpreter', 'latex', 'FontSize', 18, 'NumColumns', 1); 
hold off;