clc; close all; clear all;

% Параметры
lambda = 532e-9; % длина волны в метрах
k = 2*pi / lambda; % волновое число
R = 15 * lambda / 2; % радиус апертуры
U0 = 1; % амплитуда волны на апертуре
z_values = [50 * lambda, 100 * lambda]; % расстояния от экрана
x_values = linspace(-10*lambda, 10*lambda, 500); % значения x для расчета

% Функция для расчета U
function U = calc_U(x, z, k, R, U0, lambda)
    r = linspace(0, R, 100); % Радиальные координаты
    theta = linspace(0, 2*pi, 100); % Угловые координаты

    [R_mesh, Theta_mesh] = meshgrid(r, theta); % Создаем сетку координат
    X_mesh = R_mesh .* cos(Theta_mesh); % Преобразование в декартовы координаты
    Y_mesh = R_mesh .* sin(Theta_mesh);

    % Расчет расстояния до каждой точки апертуры
    S_mesh = sqrt((x - X_mesh).^2 + Y_mesh.^2 + z^2);

    % Интегрирование с использованием векторизации
    dA = R_mesh .* lambda^2; % Элемент площади в полярных координатах
    U_integral = exp(i*k*S_mesh) ./ S_mesh .* (1 + i*k./S_mesh) .* dA;
    U = sum(U_integral(:)) * U0 / (i * lambda);
end

% Расчет и визуализация
for z = z_values
    U_x = arrayfun(@(x) calc_U(x, z, k, R, U0, lambda), x_values);
    I_x = abs(U_x).^2;

    % Нормализация интенсивности
    I_x = I_x / max(I_x);

    figure;
    plot(x_values / lambda, I_x);
    xlabel('x / lambda');
    ylabel('Normalized Intensity');
    title(['Normalized intensity distribution at z = ', num2str(z/lambda), ' lambda']);
end

