function [y_s_xs] = chua_slave(y_s, p, q, a, b)
    %===========slave system=================
    if y_s(1) >= 1
        fx = b*y_s(1) + a - b;
    elseif y_s(1) <= -1
        fx = b*y_s(1) - a + b;
    else
        fx = a*y_s(1);
    end

    dx = zeros(3,1);
    dx(1) = p*( y_s(2) - y_s(1) - fx );
    dx(2) = y_s(1) - y_s(2) + y_s(3);
    dx(3) = -q * y_s(2);
    y_s_xs = dx;
end