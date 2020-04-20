% UR5 forward transformation based on DH parameters
function T_end= UR5Ftrans(q,i)
    d1 = 0.089159;d2 = 0;d3 = 0;d4 = 0.10915;d5 = 0.09465;d6 = 0.0823;
    a1 = 0;a2 = -0.425;a3 = -0.39225;a4 = 0;a5 = 0;a6 = 0;
    alpha1 = pi/2;alpha2 = 0;alpha3 = 0;alpha4 = pi/2;alpha5 = -pi/2;alpha6 = 0;
    T01 = DHtransform(a1, alpha1, d1, q(1));
    T12 = DHtransform(a2, alpha2, d2, q(2));
    T23 = DHtransform(a3, alpha3, d3, q(3));
    T34 = DHtransform(a4, alpha4, d4, q(4));
    T45 = DHtransform(a5, alpha5, d5, q(5));
    T56 = DHtransform(a6, alpha6, d6, q(6));
    if i==1
        T_end=T01;
    elseif i==2
        T_end=T01*T12;
    elseif i==3
        T_end=T01*T12*T23;
    elseif i==4
        T_end=T01*T12*T23*T34;
    elseif i==5
        T_end=T01*T12*T23*T34*T45;
    elseif i==6
        T_end=T01*T12*T23*T34*T45*T56;
    else
        T_end=eye(4);
    end
end