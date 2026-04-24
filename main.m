clear; clc; close all;
format long
p = 9;            
q = 100/7;        
a = -8/7;         
b = -5/7;        
x0 = [0.125; 0.625; 0.941; 0.321; 0.487; 0.965];
x1 = [0.125; 0.625; 0.941; 0.321; 0.487; 0.965; zeros(3,1)];
x2 = [0.125; 0.625; 0.941; 0.321; 0.487; 0.965; zeros(6,1)];
x3 = [0.125; 0.625; 0.941; 0.321; 0.487; 0.965; zeros(9,1)];
  
tspan = [0, 50]; 
opts = odeset('RelTol',1e-8,'AbsTol',1e-9);
[t, X]   = ode45(@(t,x) Chua_NTGND(t,x), tspan, x1, opts);
[t1, X1] = ode45(@(t,x) Chua_NNRZND(t,x), tspan, x1, opts);
[t2, X2] = ode45(@(t,x) Chua_RACZND(t,x), tspan, x1, opts); 
[t3, X3] = ode45(@(t,x) Chua_DINTGND(t,x), tspan, x2, opts);
[t4, X4] = ode45(@(t,x) Chua_ANFOZND(t,x), tspan, x0, opts);
[t5, X5] = ode45(@(t,x) Chua_GND(t,x), tspan, x1, opts);

%==================================3D Plot=================================
my_colors1 = [
    177, 217, 243;  % Master system
    179, 171, 212   % Slave system
] / 255;
figure; 
colororder(my_colors1);
plot3(X3(:,1), X3(:,2), X3(:,3), 'LineWidth', 2.5);
hold on;
plot3(X3(:,4), X3(:,5), X3(:,6), '-.','LineWidth', 2.5);
legend('Slave System','interpreter','latex','FontName','Times New Roman','FontSize',22);
xlabel('$\mathcal{X}$(t)','Interpreter','latex','FontSize',22);
ylabel('$\mathcal{Y}$(t)','Interpreter','latex','FontSize', 22);
zlabel('$\mathcal{Z}$(t)','Interpreter','latex','FontSize', 22);
grid on;
box on; 

%==========================Residual Norm Plot========================================
% ===============NTGND model=========================
nerr = zeros(length(t), 1); 
for i = 1:length(t)
    err = [X(i, 4) - X(i, 1); X(i, 5) - X(i, 2); X(i, 6) - X(i, 3)];    
    nerr(i) = norm(err); 
end
hold on;
% ===============NNRZND model==========================
nerr1 = zeros(length(t1), 1); 
for i = 1:length(t1)
    err1 = [X1(i, 4) - X1(i, 1); X1(i, 5) - X1(i, 2); X1(i, 6) - X1(i, 3)];  
    nerr1(i) = norm(err1); 
end
hold on;
% ==================RACZND model=========================
nerr2 = zeros(length(t2), 1); 
for i = 1:length(t2)
    err2 = [X2(i, 4) - X2(i, 1); X2(i, 5) - X2(i, 2); X2(i, 6) - X2(i, 3)];  
    nerr2(i) = norm(err2); 
end
hold on;
% ===================DINTGND model=======================
nerr3 = zeros(length(t3), 1); 
for i = 1:length(t3)
    err3 = [X3(i, 4) - X3(i, 1); X3(i, 5) - X3(i, 2); X3(i, 6) - X3(i, 3)];  
    nerr3(i) = norm(err3); 
end
hold on;
% ====================ANFOZND model=======================
nerr4 = zeros(length(t4), 1); 
for i = 1:length(t4)
    err4 = [X4(i, 4) - X4(i, 1); X4(i, 5) - X4(i, 2); X4(i, 6) - X4(i, 3)];  
    nerr4(i) = norm(err4); 
end
hold on;
% =====================GND model==========================
 for i = 1:length(t5)
     err5 = [X5(i, 4) - X5(i, 1); X5(i, 5) - X5(i, 2); X5(i, 6) - X5(i, 3)];  
     nerr5(i) = norm(err5); 
 end
 
%=================================Logarithmic scale=====================================
my_colors = [
    220, 227, 236;  % #E97A6F 
    245, 221, 157;  % #EAB16E 
    128, 190, 179;  % #80BEB3 
    177, 217, 243;  % #72B0DE 
    226, 166, 201;  % #E2A6C9 
    179, 171, 212   % #B3ABD4 
] / 255;
figure;
colororder(my_colors);
semilogy(t5, nerr5+1e-18, t, nerr+1e-18, '-.', t1, nerr1+1e-18, t2, nerr2+1e-18, t4, nerr4+1e-18,':', t3, nerr3+1e-18, '-.', 'linewidth', 2);
xlabel('$t$(s)','Interpreter','latex','FontSize',20);
ylabel('$\|\mathcal{S}$(t)-$\mathcal{M}$(t)$\|_{2}$','Interpreter','latex','FontSize',20);
legend('GND','NTGND','NNRZND', 'RACZND','ANFOZND','DINTGND', 'Interpreter', 'latex', 'FontName', 'Times New Roman', 'FontSize', 20, 'NumColumns', 2);

%=================================Normal scale=====================================
figure;
colororder(my_colors);
plot(t5, nerr5,t,nerr,'-.',t1, nerr1,t2, nerr2,t4, nerr4, ':',t3, nerr3,'-.','linewidth',2.5);
xlabel('$t(s)$','Interpreter','latex','FontSize',20);
ylabel('$\|\mathcal{S}(t)-\mathcal{M}(t)\|_{2}$','Interpreter','latex','FontSize',20);
legend('GND','NTGND','NNRZND', 'RACZND','ANFOZND','DINTGND', 'interpreter','latex','FontName','Times New Roman','FontSize',22);
