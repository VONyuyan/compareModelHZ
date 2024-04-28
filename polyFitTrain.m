x = performance(:, 1);
y = performance(:, 2);

% 转置
x1 = x';
y1 = y';

P = polyfit(x1, y1, 4);   %三阶多项式拟合

xi=57:.2:100;  

yi= polyval(P, xi);  %求对应y值

plot(xi,yi,x,y,'r*');