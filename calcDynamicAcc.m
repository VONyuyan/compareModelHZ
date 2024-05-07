function [Aout] = calcDynamicAcc(controlIndex,Vmpss, positionCM, currentGrade)
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

% HZ7S0
a = 97.871*1e-05; b = 504.206*1e-05; c = 2123.193*1e-03; 
V1 = 15.004; afix = 1.08; A = 9*1e-08; B = -3.007*1e-05; C = 4.735*1e-03; D = -3.332*1e-01; E = 9.069;
V2 = 15; afix2 = 1.1; A2 = 8.97*1e-08; B2 = -3.707*1e-05; C2 = 4.976*1e-03; D2 = -3.117*1e-01; E2 = 9.179;
R = 1.11;
% HZ7S1
% a = 51.648*1e-05; b = 1033.035*1e-05; c = 3000*1e-03; 
% V1 = 15.014; afix = 1.08; A = 8.549*1e-08; B = -3.069*1e-05; C = 4.875*1e-03; D = -3.407*1e-01; E = 9.298;
% V2 = 15.999; afix2 = 1.1; A2 = 8.126*1e-08; B2 = -3.367*1e-05; C2 = 4.506*1e-03; D2 = -3.036*1e-01; E2 = 9.604;
% R = 1.08;
% HZ7S2
% a = 42.468*1e-05; b = 1515.085*1e-05; c = 1796.07*1e-03; 
% V1 = 15.001; afix = 1.08; A = 8.964*1e-08; B = -3.164*1e-05; C = 4.444*1e-03; D = -3.142*1e-01; E = 9.198;
% V2 = 15; afix2 = 1.081; A2 = 8.779*1e-08; B2 = -3.197*1e-05; C2 = 4.575*1e-03; D2 = -3.158*1e-01; E2 = 9.318;
% R = 1.08;
% HZ7S3
% a = 0*1e-05; b = 696.492*1e-05; c = 256.666*1e-03; 
% V1 = 15.967; afix = 1.08; A = 8.328*1e-08; B = -3.403*1e-05; C = 4.441*1e-03; D = -3*1e-01; E = 9.376;
% V2 = 15.35; afix2 = 1.08; A2 = 8.242*1e-08; B2 = -3.169*1e-05; C2 = 4.39*1e-03; D2 = -3.042*1e-01; E2 = 9.762;
% R = 1.11;
% HZ7S4
% a = 15.895*1e-05; b = 832.119*1e-05; c = 2413.676*1e-03; 
% V1 = 15.381; afix = 1.08; A = 8.653*1e-08; B = -3.8*1e-05; C = 4.978*1e-03; D = -3.186*1e-01; E = 9.096;
% V2 = 15; afix2 = 1.1; A2 = 8.255*1e-08; B2 = -3.25*1e-05; C2 = 4.606*1e-03; D2 = -3.12*1e-01; E2 = 9.221;
% R = 1.103;
% HZ7S5
% a = 47.405*1e-05; b = 847.162*1e-05; c = 1271.672*1e-03; 
% V1 = 16; afix = 1.08; A = 8.038*1e-08; B = -3.007*1e-05; C = 4.951*1e-03; D = -3.461*1e-01; E = 9.6;
% V2 = 15.002; afix2 = 1.08; A2 = 9*1e-08; B2 = -3.99*1e-05; C2 = 4.856*1e-03; D2 = -3.011*1e-01; E2 = 9.678;
% R = 1.11;
% HZ7S6
% a = 160.251*1e-05; b = 1304.145*1e-05; c = 2801.008*1e-03; 
% V1 = 15.004; afix = 1.08; A = 8.81*1e-08; B = -3.888*1e-05; C = 4.682*1e-03; D = -3.048*1e-01; E = 9.998;
% V2 = 15.011; afix2 = 1.08; A2 = 9*1e-08; B2 = -3.01*1e-05; C2 = 4.994*1e-03; D2 = -3.621*1e-01; E2 = 9.832;
% R = 1.11;
% HZ7S7
% a = 182.943*1e-05; b = 1271.786*1e-05; c = 2894.141*1e-03; 
% V1 = 15.998; afix = 1.08; A = 8.891*1e-08; B = -3.006*1e-05; C = 4.391*1e-03; D = -3.164*1e-01; E = 9.561;
% V2 = 16; afix2 = 1.08; A2 = 8.832*1e-08; B2 = -3.73*1e-05; C2 = 4.818*1e-03; D2 = -3.198*1e-01; E2 = 9.976;
% R = 1.11;

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
% resistGrade = (fi(1)*CABW(1) + fi(2)*CABW(2) + fi(3)*CABW(3) + fi(4)*CABW(4) + fi(5)*CABW(5) + fi(6)*CABW(6)) * 9.8 /1000;

%根据控制量计算机车输出的力
% p1 = [0.0001   -0.0128    1.4587]
% p2 = [-4.589664032387263e-06,0.00143934515869,-0.145116171769403,5.905805916486559];
% p2 = [-4.63e-06,0.001435,-0.1462,5.91];
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
