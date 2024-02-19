clc; close all; clear all;

% Параметры задачи
lambda = 0.532e-6; % длина волны в метрах
NA = 0.9; % числовая апертура
n = 1; % показатель преломления среды (воздух)
k = 2*pi/lambda; % волновое число
f = 1; % фокусное расстояние в условных единицах
alpha_min = 0.9 * NA; % минимальный угол кольцевой апертуры
theta_max = asin(NA / n); % максимальный угол

% Сетка по x и y в микрометрах
x = linspace(-1, 1, 100) * 1e-6;
y = linspace(-1, 1, 100) * 1e-6;
[X, Y] = meshgrid(x, y);
r = sqrt(X.^2 + Y.^2); % радиальное расстояние от центра в метрах
phi = atan2(Y, X); % азимутальный угол в радианах

% Расчет интенсивности без кольцевой апертуры
I_no_aperture = zeros(size(X));
for i = 1:numel(X)
    integrand = @(theta) sin(theta).^2 .* besselj(0, k * r(i) * sin(theta)) .* exp(-1i * k * f * cos(theta));
    I_no_aperture(i) = abs(integral(integrand, 0, theta_max))^2;
end

% Расчет интенсивности с кольцевой апертурой
I_with_aperture = zeros(size(X));
theta_min = asin(alpha_min / n);
for i = 1:numel(X)
    integrand = @(theta) sin(theta).^2 .* besselj(0, k * r(i) * sin(theta)) .* exp(-1i * k * f * cos(theta));
    I_with_aperture(i) = abs(integral(integrand, theta_min, theta_max))^2;
end

% Нормализация интенсивности
I_no_aperture = I_no_aperture / max(I_no_aperture(:));
I_with_aperture = I_with_aperture / max(I_with_aperture(:));

% Визуализация без кольцевой апертуры
figure;
imagesc(x * 1e6, y * 1e6, I_no_aperture);
axis square;
xlabel('x (мкм)');
ylabel('y (мкм)');
title('Распределение интенсивности без кольцевой апертуры');
colorbar;

% Визуализация с кольцевой апертурой
figure;
imagesc(x * 1e6, y * 1e6, I_with_aperture);
axis square;
xlabel('x (мкм)');
ylabel('y (мкм)');
title('Распределение интенсивности с кольцевой апертурой');
colorbar;
