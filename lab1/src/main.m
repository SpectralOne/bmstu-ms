X = [
    -13.40,-12.63,-13.65,-14.23,-13.39,-12.36,-13.52,-13.44,-13.87,-11.82,...
    -12.01,-11.40,-13.02,-12.61,-13.06,-13.75,-13.55,-14.01,-11.75,-12.95,...
    -12.59,-13.60,-12.76,-11.05,-13.15,-13.61,-11.73,-13.00,-12.66,-12.67,...
    -12.60,-12.47,-13.52,-12.61,-11.93,-13.11,-13.22,-11.87,-13.44,-12.70,...
    -11.78,-12.30,-12.89,-13.29,-12.48,-10.44,-12.55,-12.64,-12.03,-14.60,...
    -14.56,-13.30,-11.32,-12.24,-11.17,-12.50,-13.25,-12.55,-12.85,-12.67,...
    -12.41,-12.58,-12.10,-13.54,-12.69,-12.87,-12.71,-12.77,-13.30,-12.74,...
    -12.73,-12.64,-12.18,-11.20,-12.40,-13.78,-13.71,-10.74,-11.89,-13.20,...
    -11.31,-14.26,-10.38,-12.88,-11.39,-11.35,-12.55,-12.84,-10.25,-12.40,...
    -14.01,-11.47,-13.14,-12.69,-11.92,-12.86,-13.06,-12.57,-13.63,-12.34,...
    -12.84,-14.03,-13.34,-11.64,-13.58,-10.44,-11.37,-11.01,-13.80,-13.27,...
    -12.32,-10.69,-12.92,-13.29,-12.58,-13.98,-11.46,-11.82,-12.33,-11.47
];
	
% а) вычисление Mmax и Mmin
% sort row
sort_row = sort(X);  % вариац. ряд
% size of vector
n = length(sort_row);

% calculate Mmax, Mmin, R, MX, DX
M_max = max(X);
M_min = min(X);
	
Mmax = sort_row(n);
Mmin = sort_row(1);

fprintf('а) (stand) M_max = %.2f, M_min = %.2f\n', M_max, M_min);
fprintf('а) Mmax = %.2f, Mmin = %.2f\n\n', Mmax, Mmin);
	
% б) размаха R выборки
R = M_max - M_min;
fprintf('б) R = %.2f\n\n', R);
	
% в) вычисление оценок µ, S^2 математического ожидания MX и дисперсии DX
MX = mean(X); % среднее значение
DX = var(X); % Дисперсия
	
MX1 = sum(X) / n;
S2 = sum((X - MX).^2) / (n - 1);
fprintf('в) (stand) mu = %.2f, S^2 = %.2f\n', MX, DX);
fprintf('в) mu = %.2f, S^2 = %.2f\n\n', MX1, S2);
    
% г) Группировка значений выборки в m = [log2 n] + 2 интервала;
% Построить интервальный ряд
[count, edges, m] = groupInterval(X);
	
% д) построение на одной координатной плоскости гистограммы и графика функции 
% плотности распределения вероятностей нормальной случайной величины с математическим
% ожиданием µ и дисперсией S

plotHistogram(X, count, edges, m);
% Построение на одной координатной плоскости
hold on; 
% График функции плотности распределения вероятностей нормальной
% случайной величины
fn = @(X, MX, S2) normpdf(X, MX, S2);
plotGraph(fn, MX, S2, Mmin, Mmax, 0.1);
	
% e) построение на другой координатной плоскости графика эмпирической функции 
% распределения и функции распределения нормальной случайной величины 
% с математическим ожиданием µ и дисперсией S
	
% Новая координатная плоскость
figure;
% график эмпирической функции распределения
plotEmpiricalF(X);
% Построение на одной координатной плоскости
hold on;
% График функции плотности распределения вероятностей нормальной случайной величины
Fn = @(X, MX, S2) normcdf(X, MX, S2);
plotGraph(Fn, MX, S2, Mmin, Mmax, 0.1);
	
 % Функция для группировки значений выборки
function [count, edges, m] = groupInterval(X)
    % Нахождение количества интервалов
    m = floor(log2(length(X))) + 2;
    % С помощью функции histcounts разбиваем выборку на m интервалов от
    % минимума до максимума . Возвращаем интервалы и количество элементов
    % в каждом из них
    [count, edges] = histcounts(X, m, 'BinLimits', [min(X), max(X)]);
	
    lenC = length(count);
    
    %  Вывод интервалов и количества элементов
    fprintf('\nИнтервальный ряд для m = %d \n', m);
    for i = 1 : (lenC - 1)
        fprintf('[%f,%f) - %d\n', edges(i), edges(i + 1), count(i));
    end
    fprintf('[%f,%f] - %d\n', edges(lenC), edges(lenC + 1), count(lenC));
end

% функция для отрисовки гистограммы
function plotHistogram(X, count, edges, m)
    % построение гистограммы
    h = histogram();
    % задаем интервалы
    h.BinEdges = edges;
    % задаем значения в каждом интервале (эмпирическую плотность)
    h.BinCounts = count / length(X) / ((max(X) - min(X)) / m);
    h.LineWidth = 2;
    h.DisplayStyle = 'stairs';
end

% Функция для отрисовки графиков func, c математическим ожиданием mu
% и дисперсией s2, от min до max с шагом step
function plotGraph(func, mu, s2, min, max, step)
    x = min : step : max;
	% нормальная ф-я плотности вероятности, возвращает PDF (Normal probability density function)
    % со средним µ, и стандартным отклонением s2.
	y = func(x, mu, s2);
    plot(x, y, 'LineWidth', 2);
end

% график эмпирической функции распределения
function plotEmpiricalF(X)
    % поиск уникальных элементов
    u = unique(X);
    % подсчет кол-ва каждого из уникальных эл-тов
    count = histcounts(X, u);
    % подсчет кол-ва эл-тов, меньших текущего уникального эл-та
    for i = 2 : (length(count))
        count(i) = count(i) + count(i - 1);
    end
    count = [0 count];
    % отрисовка графика
    stairs(u, count / length(X), 'LineWidth', 2);
end
	
