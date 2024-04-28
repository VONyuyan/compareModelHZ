function fitness = calcFit(item)
    load('HZ7S6.mat');
    startDistance = 20757; %18047 19126 20757 21941 -23250 -21920 -20719 -19121
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
    for i = 1 : size(HZ7,1)
        if colGrade > 0
            gradenow = HZ7(i,colGrade);
        else
            gradenow = 0;
        end
        controlReal = HZ7(i,colControl);
    
        positionCM = Ssim / 10;  % 当前位置 (cm)
        [Asim] = calcDynamicAccNew(controlReal/1000,Vsim, positionCM, gradenow / 10, item);  %合加速度计算
        Vsim = Vsim + Asim * Tsim;                %预测下一周期速度，m/s 周期为0.05s
        if Vsim < 0 
            Vsim = 0;
        end
        if Vsim > 0
            x1 = Asim/2 * Tsim * Tsim * 100;
            Ssim = Ssim + Vsim * Tsim * 100 - x1;         %cm
        end
        v0 = [v0 , HZ7(i,colSpeed)];
        v1 = [v1, Vsim * 36];
    end

    fitness = sqrt(sum((v0-v1).^2));
end