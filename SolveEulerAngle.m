function t=SolveEulerAngle(Rot_Mat)
t=zeros(1,3);
    if abs(Rot_Mat(3,3))<eps && abs(Rot_Mat(2,3))<eps
        t(1)=0;
        t(2)=atan2(Rot_Mat(1,3), Rot_Mat(3,3));
        t(3)=atan2(Rot_Mat(2,1), Rot_Mat(2,2));
    else
        t(1)=atan2(-Rot_Mat(2,3), Rot_Mat(3,3));
        a=sin(t(1));
        b=cos(t(1));
        t(2)=atan2(Rot_Mat(1,3), b * Rot_Mat(3,3) - a * Rot_Mat(2,3));
        t(3)=atan2(-Rot_Mat(1,2), Rot_Mat(1,1));
    end
end