function [Aout] = calcDynamicAccNew(controlIndex,Vmpss, positionCM, currentGrade, item)
%根据比例计算机车合加速度大小的函数
%conper       机车输出力百分比
%maxTract     牵引最大力，kN
%maxBreak     制动最大力，kN
%v            当前速度，m/s
%
%f            机车输出力，kN
%gradenow     坡度

weight1 = 37;
CABW = [370,372,372,372,372,370]; %车厢重量，t*10 总重量 
weight6 = sum(CABW) ; % HZ7
maxTract = weight6 * 1.25; %最大牵引力
maxBreak = weight6 * 1.25; %最大制动力

a = item(1)*1e-05; b = item(2)*1e-05; c = item(3)*1e-03; 
V1 = item(4); afix = item(5); A = item(6)*1e-08; B = item(7)*1e-05; C = item(8)*1e-03; D = item(9)*1e-01; E = item(10);
V2 = item(11); afix2 = item(12); A2 = item(13)*1e-08; B2 = item(14)*1e-05; C2 = item(15)*1e-03; D2 = item(16)*1e-01; E2 = item(17);
R = item(18);

Vkmph = Vmpss*3.6;
% % 基本阻力计算
% basicResist = (6.4 * weight1 + 130 * 4 * 6 + 0.14 * weight1 * Vkmph + (0.046 + 0.0065 * 5) * 10.2 * Vkmph * Vkmph) / 1000;%N
% resistBasic = ((1.65+0.0247*Vmpss)*weight1+(0.78+0.0028*Vmpss)*weight1+(0.028+0.0078*5)*Vmpss*Vmpss)*9.80665 / 1000;
% resistBasic = (2.25 + 0.0190 * Vkmph + 0.00032 * Vkmph * Vkmph) * 9.8 / 1000 * weight6;  %kN
if Vkmph > 10
    resistBasic = (c + b * Vkmph + a * Vkmph.^2) * weight6 * 9.8 / 1000;  %kN
else
    resistBasic = (c + b * 10 + a * 100) * weight6 * 9.8 / 1000;  %kN
end

resistGrade = weight6 * currentGrade * 9.8 / 1000 / R;     %kN

% fi(1) = sloperessin(positionCM,currentGrade);
% fi(2) = sloperessin(positionCM,currentGrade);
% fi(3) = sloperessin(positionCM,currentGrade);
% fi(4) = sloperessin(positionCM,currentGrade);
% fi(5) = sloperessin(positionCM,currentGrade);
% fi(6) = sloperessin(positionCM,currentGrade);
% % resistGrade = sum(fi) / weight6;
% 
% % 坡道阻力
% resistGrade = (fi(1)*CABW(1) + fi(2)*CABW(2) + fi(3)*CABW(3) + fi(4)*CABW(4) + fi(5)*CABW(5) + fi(6)*CABW(6)) * 9.8/1000;

%根据控制量计算机车输出的力
% p1 = [0.0001   -0.0128    1.4587]
% p2 = [-4.589664032387263e-06,0.00143934515869,-0.145116171769403,5.905805916486559];
% p2 = [-4.63e-06,0.001435,-0.1462,5.91];
% p2 = [-5.3198e-06,0.0016,-0.1632,6.2682];
p2 = [A,B,C,D,E];
p3 = [A2,B2,C2,D2,E2];
if controlIndex > 0                        %牵引
    if (Vmpss < V1)
        Fmax = weight6 * afix;
    else % 根据车辆参数-加速度性能表, 拟合曲线
        Fmax = weight6 * polyval(p2, Vkmph) ;
    end
    if(Fmax < 0)
        Fmax = 0;
    end
elseif controlIndex == 0                    %惰行
    Fmax = 0;
else                                 %制动
    if (Vmpss < V2)
        Fmax = weight6 * afix2;
    else
        Fmax = weight6 * polyval(p3, Vkmph);
    end
    if(Fmax < 0)
        Fmax = 0;
    end
end
Fout = Fmax * controlIndex;                      %机车力,kN
Aout = Fout / weight6 - resistGrade / weight6- resistBasic/ weight6;                      %m/s^2

% if abs(currentGrade) > 200
%     disp(resistGrade)
% end
