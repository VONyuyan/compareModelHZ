% 使用遗传算法工具箱的适应度函数
function result = steadyfitness(a)
    load SteadyData.mat;
    u = (up+abs(un))/2/4;
    Fi =u';                % 均匀实验测得摩擦力的实测值
    w = vd';               % 速度输入值
    N = size(w,1);
    for i = 1:1:N
       F_GA(i) =  (a(1)+a(2)*exp(-(w(i)/a(3))^2))*sign(w(i)) + a(4)*w(i);
       Ji(i) = Fi(i) - F_GA(i);
       J(i) = 0.5*Ji(i)*Ji(i);
    end
    result = sum(J);
end