function [y_m_xm] = chua_master(y_m, p, q, a, b)
    %========master system============
    if y_m(1) >= 1
        fx = b*y_m(1) + a - b;
    elseif y_m(1) <= -1
        fx = b*y_m(1) - a + b;
    else
        fx = a*y_m(1);
    end

    dx = zeros(3,1);
    dx(1) = p*( y_m(2) - y_m(1) - fx );
    dx(2) = y_m(1) - y_m(2) + y_m(3);
    dx(3) = -q * y_m(2);
    
    y_m_xm =dx;
end
