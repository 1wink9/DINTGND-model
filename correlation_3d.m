function correlation_3d(img)
    if size(img, 3) == 3
        gray = double(img(:,:,1)); 
    else
        gray = double(img); 
    end
    x = gray(:, 1:end-1); 
    y = gray(:, 2:end);
    hist = accumarray([x(:)+1, y(:)+1], 1, [256, 256]);
    try 
        hist = imgaussfilt(double(hist), 1.0); 
    catch
        hist = double(hist); 
    end
    hist(hist == 0) = 0.5; 
    [X, Y] = meshgrid(0:255, 0:255);
    surf(X, Y, hist, 'EdgeColor', 'none'); 
    set(gca, 'ZScale', 'log'); 
    
    zlim([0.5, 10^4]); 
    fontName = 'Times New Roman';
    fontSize = 12;
    set(gca, 'FontSize', fontSize, 'FontName', fontName);
    colormap jet; 
    shading interp; 
    camlight left; 
    lighting gouraud; 
    view(-45, 30); 
    
    xlim([0, 255]); 
    ylim([0, 255]); 
    
    xlabel('Pixel Value (x,y)', 'FontName', fontName, 'FontSize', 14); 
    ylabel('Pixel Value (x,y+1)', 'FontName', fontName, 'FontSize', 14); 
    zlabel('Frequency', 'FontName', fontName, 'FontSize', 14);
    
    grid on; box on;
end