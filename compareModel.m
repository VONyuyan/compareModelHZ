% 指定Excel文件名和工作表名称
% filename = 'XA63.xlsx';
% sheet = 'Sheet1';
% XA6 = xlsread(filename, sheet);
% colSpeed = 3;
% colControl = 4;
% colAcc = 6;
% colGrade = 7;
% colDistance = 2;
% startDistance = 16139; %15107; %16139;


% filename = 'HZ7.xlsx';
% sheet = '市民中心-观音塘下行';
% sheet = '观音塘-莫邪塘下行';
% sheet = '莫邪塘-江城路下行';
% sheet = '江城路-吴山广场下行';
% sheet = '吴山广场-江城路上行';
% sheet = '江城路-莫邪塘上行';
% sheet = '莫邪塘-观音塘上行';
% sheet = '观音塘-市民中心上行';
% HZ7 = xlsread(filename, sheet);
load('HZ7S5.mat');
startDistance = 19126; %18047 19126 20757 21941 -23250 -21920 -20719 -19121
colDistance = 2;
colSpeed = 3;
colControl = 4;
colAcc = 7;
colGrade = 6;


% 以HZ7中的控制力 施加仿真车辆，计算加速度曲线
Tsim = 0.05;
Vsim = 0;
Asim = 0;
Ssim = 0;
v1 = [];
a1 = [];
s1 = [];
a0 = [];
t0 = [];
v0 = [];
gradeHZ = [];

% 延时相关
% oldcontrol = 0;
% oldflag = 0;
% controldelay = 0;
% conflag = 0;  % 0 惰行 coast 1 牵引 CoastTotract 2 制动 CoastToBrake 3  TractToCoast 4 BrakeToCoast 5 BrakeToTract 6 TractToBrake
% countnum = 0;
% CoastToBrakeNum = 6;
% CoastTotractNum = 6;
% TractToCoastNum = 6;
% BrakeToCoastNum = 6;

for i = 1 : size(HZ7,1)
    if colGrade > 0
        gradenow = HZ7(i,colGrade);
    else
        gradenow = 0;
    end
%    oldflag = conflag;
    controlReal = HZ7(i,colControl);
    newcontrol = HZ7(i,colControl);
%     if oldcontrol == 0
%         if newcontrol > 0
%             conflag = 1;
%         elseif newcontrol < 0
%             conflag = 2;
%         end
%     elseif oldcontrol < 0
%         if newcontrol == 0
%             conflag = 3;
%         elseif newcontrol > 0
%             conflag = 5;
%         end 
%     else
%         if newcontrol == 0
%             conflag = 4;
%         elseif newcontrol < 0
%             conflag = 6;
%         end 
%     end
%     if countnum > 0
%         controlReal = controldelay;
%         countnum = countnum - 1;
%     end    
%     if oldflag ~= conflag
%         controldelay = oldcontrol;
%         switch(conflag)
%             case 1  
%                 countnum = countnum + CoastTotractNum;
%             case 2
%                 countnum = countnum + CoastToBrakeNum;
%             case 3
%                 countnum = countnum + BrakeToCoastNum;
%             case 4    
%                 countnum = countnum + TractToCoastNum;
%             case 5
%                 countnum = countnum + BrakeToCoastNum + CoastTotractNum;
%             case 6    
%                 countnum = countnum + TractToCoastNum + CoastToBrakeNum;
%             otherwise
%                 countnum = countnum;
%         end
%     end
    
    positionCM = Ssim / 10;  % 当前位置 (cm)
    [Asim] = calcDynamicAcc(controlReal/1000,Vsim, positionCM, gradenow / 10);  %合加速度计算
    oldcontrol = newcontrol;
    Vsim = Vsim + Asim * Tsim;                %预测下一周期速度，m/s 周期为0.05s
    if Vsim < 0 
        Vsim = 0;
    end
    if Vsim > 0
        x1 = Asim/2 * Tsim * Tsim * 100;
        Ssim = Ssim + Vsim * Tsim * 100 - x1;         %cm
    end
    a0 = [a0 , HZ7(i,colAcc)/1000];
    t0 = [t0 , i * Tsim];
    v0 = [v0 , HZ7(i,colSpeed)];
    v1 = [v1, Vsim];
    a1 = [a1, Asim];
    s1 = [s1 , Ssim];
    gradeHZ = [gradeHZ, gradenow];
end

% plot
sreal = HZ7(:,colDistance);



%plot(sreal ,g0 ,sreal ,v0 ,sreal ,f0 ,sreal ,a0);

% 加速度
% figure;
% plot(t0 , a0, t0,  a1);
% 速度
figure;
plot(t0, v0, t0,  v1*36, t0, HZ7(:,colControl), t0, gradeHZ);
% plot(t0 , v0, t0,  v*36, t0, gradeHZ, t0, HZ7(:,colControl));
grid;
% 位移
% figure;
% w = waitforbuttonpress;
% plot(t0 , (sreal - startDistance) * 100, t0,  s1);
% figure;
% plot(s,v,s,a);