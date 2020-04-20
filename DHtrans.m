function T=DHtrans(a,alpha,d,theta)
    Td=[1 0 0 0;
        0 1 0 0;
        0 0 1 d;
        0 0 0 1];
    Ta=[1 0 0 a;
        0 1 0 0;
        0 0 1 0;
        0 0 0 1];
    Rt=eye(4);
    Rt(1:3,1:3)=EulerRot([0,0,theta]);
    Ral = eye(4);
    Ral(1:3, 1:3) = EulerRot([alpha,0,0]);
    T=Td*Rt*Ta*Ral;
end
