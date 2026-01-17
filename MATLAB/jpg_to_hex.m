% Đọc ảnh grayscale
img = imread('baitap1_anhgoc.jpg');

% Nếu ảnh màu thì chuyển sang grayscale
if size(img, 3) == 3
    img = rgb2gray(img);
end

% Lấy kích thước ảnh
[rows, cols] = size(img);

% Chuyển từng pixel sang hex
hex_array = cell(rows, cols);
for i = 1:rows
    for j = 1:cols
        pixel_value = img(i, j);
        hex_array{i, j} = dec2hex(pixel_value, 2); % 2 ký tự hex
    end
end

% Hiển thị một vài giá trị
disp('Pixel [1,1]:');
fprintf('Decimal: %d, Hex: %s\n', img(1,1), hex_array{1,1});

disp('Pixel [1,2]:');
fprintf('Decimal: %d, Hex: %s\n', img(1,2), hex_array{1,2});

% Nếu muốn lưu toàn bộ ma trận hex ra file
fid = fopen('anhgoc.txt', 'w');
for i = 1:rows
    for j = 1:cols
        fprintf(fid, '%s ', hex_array{i, j});
    end
    fprintf(fid, '\n');
end
fclose(fid);

disp('Done! Saved to anhgoc.txt');