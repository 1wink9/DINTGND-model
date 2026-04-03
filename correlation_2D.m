function correlation_2D(img)
    if size(img, 3) == 3
        gray = double(img(:,:,1)); 
    else
        gray = double(img); 
    end
    x = gray(:, 1:end-1); 
    y = gray(:, 2:end);
    idx = randperm(length(x(:)), min(3000, length(x(:))));
    scatter(x(idx), y(idx), 5, 'filled', 'MarkerFaceColor', [0 0.4470 0.7410]);
    xlim([0, 255]); 
    ylim([0, 255]); 
    set(gca, 'FontSize', 15, 'FontName', 'Times New Roman'); 
    xlabel('Pixel (x,y)', 'FontSize', 22, 'FontName', 'Times New Roman');
    ylabel('Pixel (x,y+1)', 'FontSize', 22, 'FontName', 'Times New Roman');
    grid on; box on;
end
