% Параметры апертуры и волны
lambda = 1; % Взяли за единицу измерения, так как диаметр дан в λ
diameter = 15 * lambda; % Диаметр апертуры
radius = diameter / 2;
k = 2 * pi / lambda; % Волновое число

% Дискретизация пространства
x = linspace(-3*lambda, 3*lambda, 1000);
y = x;
[X, Y] = meshgrid(x, y);
r = sqrt(X.^2 + Y.^2);

% Расчет поля на разных расстояниях
z = [50*lambda, 100*lambda]; % Расстояния от апертуры

% Инициализация массива для интенсивности
I = zeros(length(x), length(y), length(z));

% Вычисление интенсивности с использованием интеграла Рэлея-Зоммерфельда первого рода
for idx = 1:length(z)
    U = (radius^2) * (besselj(1, k * radius * r ./ z(idx)) ./ (k * radius * r ./ z(idx))).^2;
    U(r >= radius) = 0; % Обнуляем значения вне апертуры
    I(:,:,idx) = U.^2; % Интенсивность пропорциональна квадрату амплитуды
end

% Построение графиков интенсивности
for idx = 1:length(z)
    figure;
    imagesc(x, y, I(:,:,idx));
    colorbar;
    title(sprintf('Intensity distribution at z = %dλ', z(idx)));
    xlabel('x, \mum');
    ylabel('y, \mum');
end

