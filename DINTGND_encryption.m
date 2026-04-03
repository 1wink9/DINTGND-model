clc; clear; close all;
%% 1. Single video path setting
videoPath = 'test01.avi'; 
if ~isfile(videoPath)
    error('Video file not found, please check if the path is correct: %s', videoPath);
end    
%% 2. Experimental parameter settings
CONFIG.MaxFrames = 200;
CONFIG.TargetSize = [256, 256];
% Chaotic initial conditions
%x0 = [0.125; 0.625; 0.941; 0.321; 0.487; 0.965; zeros(3,1)];   
%x0 = [0.125; 0.625; 0.941; 0.321; 0.487; 0.965];  
x0 = [0.125; 0.625; 0.941; 0.321; 0.487; 0.965; zeros(6,1)];
%% 3. Core processing: Solving ODE and frame-by-frame encryption/decryption
fprintf('>> Loading video: %s\n', videoPath);
v_reader = VideoReader(videoPath);
% Determine the number of frames to process
numFrames = min(v_reader.NumFrames, CONFIG.MaxFrames);
duration = numFrames / v_reader.FrameRate;
fprintf('   -> Specification: %dx%d, Intercept duration: %.2fs (%d frames)\n', ...
    CONFIG.TargetSize(1), CONFIG.TargetSize(2), duration, numFrames);   
% Solve ODE to generate chaotic sequence
tspan = linspace(0, duration, numFrames);
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-6);
fprintf('   -> Solving chaotic dynamics equations...\n');
%[T, X_raw] = ode45(@(t,x) Chua_GND(t,x), tspan, x0, opts); 
%[T, X_raw] = ode45(@(t,x) Chua_NTGND(t,x), tspan, x0, opts); 
%[T, X_raw] = ode45(@(t,x) Chua_NNRZND(t,x), tspan, x0, opts);
%[T, X_raw] = ode45(@(t,x) Chua_RACZND(t,x), tspan, x0, opts);
%[T, X_raw] = ode45(@(t,x) Chua_ANFOZND(t,x), tspan, x0, opts);
[T, X_raw] = ode45(@(t,x) Chua_DINGND(t,x), tspan, x0, opts); 
X_chaos = interp1(T, X_raw, tspan);
% Used to save the last frame data for visual display
FrameData = struct('Org', [], 'Enc', [], 'Dec', []);
v_reader.CurrentTime = 0;
hWait = waitbar(0, 'Verifying encryption and decryption frame by frame...');
for k = 1:numFrames
    if hasFrame(v_reader)
        frame_org = readFrame(v_reader);
        frame_resized = imresize(frame_org, CONFIG.TargetSize);
        
        % Extract master and slave system states
        master_state = X_chaos(k, 1:3);
        slave_state  = X_chaos(k, 4:6);
        
        % Generate chaotic mask
        mask_enc = generate_chaos_mask(CONFIG.TargetSize(1), CONFIG.TargetSize(2), master_state);
        mask_dec = generate_chaos_mask(CONFIG.TargetSize(1), CONFIG.TargetSize(2), slave_state);
        
        % XOR encryption and decryption
        frame_enc = bitxor(frame_resized, mask_enc);
        frame_dec = bitxor(frame_enc, mask_dec);
        
        % Record the results of the last frame for plotting
        if k == numFrames
            FrameData.Org = frame_resized;
            FrameData.Enc = frame_enc;
            FrameData.Dec = frame_dec;
        end
        
        if mod(k, 10) == 0
            waitbar(k/numFrames, hWait); 
        end
    end
end
close(hWait);
fprintf('   -> Generating visualization images...\n');
%% 4. Plotting
fontName = 'Times New Roman';
fontSize = 22;
titleSize = 22;   
% --- Figure 1: Intuitive image comparison ---
figure('Name', 'Image Comparison', 'Position', [100, 200, 1200, 400]);
subplot(1,3,1); imshow(FrameData.Org); title('Original Image', 'FontName', fontName, 'FontSize', fontSize);
subplot(1,3,2); imshow(FrameData.Enc); title('Encrypted Image', 'FontName', fontName, 'FontSize', fontSize);
subplot(1,3,3); imshow(FrameData.Dec); title('Decrypted Image', 'FontName', fontName, 'FontSize', fontSize);
% --- Figure 2: Histograms ---
figure('Name', 'Histograms', 'Position', [100, 150, 1500, 500]);
subplot(1,3,1); 
imhist(FrameData.Org); 
grid on; 
ylim([0.5, 10^5]); 
set(gca, 'YScale', 'log', 'FontSize', fontSize, 'FontName', fontName); 
title('Original Histogram', 'FontName', fontName, 'FontSize', titleSize); 
xlabel('Pixel Value', 'FontName', fontName, 'FontSize', titleSize);
ylabel('Frequency', 'FontName', fontName, 'FontSize', titleSize);
subplot(1,3,2); 
imhist(FrameData.Enc); 
grid on; 
ylim([0.5, 10^5]); 
set(gca, 'YScale', 'log', 'FontSize', fontSize, 'FontName', fontName); 
title('Encrypted Histogram', 'FontName', fontName, 'FontSize', titleSize);
xlabel('Pixel Value', 'FontName', fontName, 'FontSize', titleSize);
ylabel('Frequency', 'FontName', fontName, 'FontSize', titleSize);
subplot(1,3,3); 
imhist(FrameData.Dec); 
grid on; 
ylim([0.5, 10^5]); 
set(gca, 'YScale', 'log', 'FontSize', fontSize, 'FontName', fontName); 
title('Decrypted Histogram', 'FontName', fontName, 'FontSize', titleSize);
xlabel('Pixel Value', 'FontName', fontName, 'FontSize', titleSize);
ylabel('Frequency', 'FontName', fontName, 'FontSize', titleSize);
% --- Figure 3: 2D adjacent pixel correlation scatter plot ---
figure('Name', '2D Correlation', 'Position', [100, 150, 1500, 500]);
subplot(1,3,1);  correlation_2D(FrameData.Org); title('Original 2D Correlation', 'FontName', fontName);
subplot(1,3,2);  correlation_2D(FrameData.Enc); title('Encrypted 2D Correlation', 'FontName', fontName);
subplot(1,3,3);  correlation_2D(FrameData.Dec); title('Decrypted 2D Correlation', 'FontName', fontName);
% --- Figure 4: 3D adjacent pixel correlation surface plot ---
figure('Name', '3D Correlation', 'Position', [100, 150, 1500, 500]);
subplot(1,3,1); correlation_3d(FrameData.Org); title('Original 3D Correlation', 'FontName', fontName);
subplot(1,3,2); correlation_3d(FrameData.Enc); title('Encrypted 3D Correlation', 'FontName', fontName);
subplot(1,3,3); correlation_3d(FrameData.Dec); title('Decrypted 3D Correlation', 'FontName', fontName);
fprintf('>> Processing complete! Please check the pop-up visualization windows.\n');