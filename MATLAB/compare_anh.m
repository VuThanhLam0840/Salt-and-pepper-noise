function [psnr_value, ssim_value] = evaluate_image(original_img, reconstructed_img)
    % Đánh giá ảnh tái tạo với ảnh gốc qua PSNR và SSIM
    % original_img: ảnh gốc (path hoặc matrix)
    % reconstructed_img: ảnh tái tạo (path hoặc matrix)
    
    % Đọc ảnh nếu là đường dẫn
    if ischar(original_img)
        img1 = imread(original_img);
    else
        img1 = original_img;
    end
    
    if ischar(reconstructed_img)
        img2 = imread(reconstructed_img);
    else
        img2 = reconstructed_img;
    end
    
    % Chuyển sang grayscale nếu là ảnh màu
    if size(img1, 3) == 3
        img1 = rgb2gray(img1);
    end
    if size(img2, 3) == 3
        img2 = rgb2gray(img2);
    end
    
    % Đảm bảo cùng kích thước
    if ~isequal(size(img1), size(img2))
        error('Hai ảnh phải có cùng kích thước!');
    end
    
    % Chuyển sang double
    img1 = double(img1);
    img2 = double(img2);
    
    % Tính PSNR
    mse = mean((img1(:) - img2(:)).^2);
    if mse == 0
        psnr_value = Inf;
    else
        max_pixel = 255.0;
        psnr_value = 20 * log10(max_pixel / sqrt(mse));
    end
    
    % Tính SSIM
    ssim_value = ssim(uint8(img1), uint8(img2));
    
    % Hiển thị kết quả
    fprintf('=== ĐÁNH GIÁ CHẤT LƯỢNG ẢNH ===\n');
    fprintf('PSNR: %.4f dB\n', psnr_value);
    fprintf('SSIM: %.4f\n', ssim_value);
    fprintf('\n');
    
    % Phân loại chất lượng
    fprintf('Đánh giá PSNR:\n');
    if psnr_value >= 40
        fprintf('  → Xuất sắc (≥40 dB)\n');
    elseif psnr_value >= 30
        fprintf('  → Tốt (30-40 dB)\n');
    elseif psnr_value >= 20
        fprintf('  → Trung bình (20-30 dB)\n');
    else
        fprintf('  → Kém (<20 dB)\n');
    end
    
    fprintf('\nĐánh giá SSIM:\n');
    if ssim_value >= 0.95
        fprintf('  → Xuất sắc (≥0.95)\n');
    elseif ssim_value >= 0.85
        fprintf('  → Tốt (0.85-0.95)\n');
    elseif ssim_value >= 0.70
        fprintf('  → Trung bình (0.70-0.85)\n');
    else
        fprintf('  → Kém (<0.70)\n');
    end
    
    % Hiển thị ảnh so sánh
    figure('Position', [100, 100, 1200, 400]);
    
    subplot(1, 3, 1);
    imshow(uint8(img1));
    title('Ảnh gốc');
    
    subplot(1, 3, 2);
    imshow(uint8(img2));
    title('Ảnh tái tạo');
    
    subplot(1, 3, 3);
    diff_img = abs(img1 - img2);
    imshow(diff_img, []);
    title(sprintf('Sai số\nPSNR: %.2f dB, SSIM: %.4f', psnr_value, ssim_value));
    colormap('jet');
    colorbar;
    
    % Histogram so sánh
    figure('Position', [100, 600, 1200, 300]);
    
    subplot(1, 2, 1);
    hold on;
    histogram(img1(:), 50, 'FaceColor', 'b', 'FaceAlpha', 0.5);
    histogram(img2(:), 50, 'FaceColor', 'r', 'FaceAlpha', 0.5);
    legend('Ảnh gốc', 'Ảnh tái tạo');
    title('Histogram so sánh');
    xlabel('Giá trị pixel');
    ylabel('Số lượng');
    hold off;
    
    subplot(1, 2, 2);
    histogram(diff_img(:), 50, 'FaceColor', 'g');
    title('Histogram sai số');
    xlabel('Sai số pixel');
    ylabel('Số lượng');
end

% Sử dụng
[psnr, ssim_val] = evaluate_image('baitap1_anhgoc.jpg', 'output.jpg');