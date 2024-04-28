function [fin] = sloperessin(positionCM,slopenow)

%计算单个车厢的坡道阻力

%fin    当前车厢的单位坡道阻力（N/kN）
%positionCM 列车位置（cm）
%slopenow 当前车厢中心处坡度（i*10）



CABLEN = 1967;          %车厢长度（均值），cm

samplelength = length(slopenow);
j = 1;
while j <= samplelength
    %计算第一个车厢的坡度值
    k = 1;
    slopeflag = 0;  %车厢是否在坡道变化点上，0-否，1-坡道变化点在车厢中点之前，2-之后
    slop1 = slopenow(j);  %当前点坡度值
    
    if j+k >= samplelength      %当前点与前面k点的距离与前面k点的坡度值
        slop2 = slopenow(samplelength);
        disfront = positionCM(samplelength)-positionCM(j);
    else
        disfront = positionCM(j+k)-positionCM(j);
        slop2 = slopenow(j+k);    %前面k点的坡度值
    end
        
    if j-k <= 0         %后面k点的坡度值及当前点与后面k点的距离
        slop3 = slopenow(1);
        disbehind = positionCM(j)-positionCM(1);
    else
        slop3 = slopenow(j-k);
        disbehind = positionCM(j)-positionCM(j-k);
    end

    %搜索车厢覆盖范围内是否有坡度变化点
    while (disfront < CABLEN/2 || disbehind < CABLEN/2 )&& k < 40
        if slop1 ~= slop2 && disfront < CABLEN/2   %若前面有坡度变化点，则标记slopeflag后退出
            slopeflag = 1;
            break;
        elseif slop1 ~= slop3 && disbehind < CABLEN/2   %若后面有坡度变化点，则标记slopeflag后退出
            slopeflag = 2;
            break;
        end
        %扩大搜索范围，更新数据
        k = k+1;
        
        if j+k >= samplelength
            slop2 = slopenow(samplelength);
            disfront = positionCM(samplelength)-positionCM(j);
        else
            disfront = positionCM(j+k)-positionCM(j);
            slop2 = slopenow(j+k);    %前面k点的坡度值
        end
        
        if j-k <= 0         %后面k点的坡度值及当前点与后面k点的距离
            slop3 = slopenow(1);
            disbehind = 0;
        else
            slop3 = slopenow(j-k);
            disbehind = positionCM(j)-positionCM(j-k);
        end  
    end
    
    
    
    %根据slopeflag计算车厢的坡度阻力
    if slopeflag == 0       %没有经过坡度变化点时
        fin(j) = slopenow(j)/10;   %i;
        
    elseif slopeflag == 1     %坡度变化点在车厢前部时
        len2 = CABLEN/2 - disfront; 
            
        len1 = CABLEN - len2;
        fin(j) = (slopenow(j)*len1 + slopenow(j+k)*len2)/(10*CABLEN);
    elseif slopeflag == 2 %坡度变化点在车厢后部时
        len1 = CABLEN/2 - disbehind;
        len2 = CABLEN - len1;
        fin(j) = (slopenow(j-k)*len1 + slopenow(j)*len2)/(10*CABLEN);
    end
    
    j = j+1;
end
    
 
         
        
        
        
        
        
        
        
        
        
        
        
        
        
        