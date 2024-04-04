clc; close all; clear all;

% Параметры
lambda = 0.532e-6; % длина волны
n = 1; % показатель преломления
NA = 0.9; % числовая апертура
alpha_min = 0.9 * NA; % минимальный угол для кольцевой апертуры
z = linspace(-10e-6, 10e-6, 1000); % диапазон значений z

% Функции для интегрирования
E_field = @(rho, z) (2 * pi / lambda) .* rho .* exp(-1i .* (2 * pi / lambda) .* n .* z .* sqrt(1 - (rho / NA).^2));
E_field_ring = @(rho, z) (2 * pi / lambda) .* rho .* exp(-1i .* (2 * pi / lambda) .* n .* z .* sqrt(1 - (rho / NA).^2)) .* (rho >= alpha_min);

% Расчет интенсивности для полной и кольцевой апертуры
I_full = arrayfun(@(z) abs(integral(@(rho) E_field(rho, z), 0, NA))^2, z);
I_ring = arrayfun(@(z) abs(integral(@(rho) E_field_ring(rho, z), 0, NA))^2, z);

% Нормализация интенсивности
I_full_norm = I_full / max(I_full);
I_ring_norm = I_ring / max(I_ring);

% Визуализация
subplot(2, 1, 1);
plot(z, I_full_norm);
title('Продольное распределение интенсивности без кольцевой апертуры');
xlabel('z (м)');
ylabel('Нормализованная интенсивность');

subplot(2, 1, 2);
plot(z, I_ring_norm);
title('Продольное распределение интенсивности с кольцевой апертурой');
xlabel('z (м)');
ylabel('Нормализованная интенсивность');
