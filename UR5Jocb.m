function J=UR5Jocb(q)
    d1 = 0.089159;d2 = 0;d3 = 0;d4 = 0.10915;d5 = 0.09465;d6 = 0.0823;
    a1 = 0;a2 = -0.425;a3 = -0.39225;a4 = 0;a5 = 0;a6 = 0;
    alpha1 = pi/2;alpha2 = 0;alpha3 = 0;alpha4 = pi/2;alpha5 = -pi/2;alpha6 = 0;
    T01 = DHtransform(a1, alpha1, d1, q(1));
    T12 = DHtransform(a2, alpha2, d2, q(2));
    T23 = DHtransform(a3, alpha3, d3, q(3));
    T34 = DHtransform(a4, alpha4, d4, q(4));
    T45 = DHtransform(a5, alpha5, d5, q(5));
    T56 = DHtransform(a6, alpha6, d6, q(6));
    T02 = T01*T12; T03 = T02*T23; T04 = T03*T34; T05 = T04*T45; T06=T05*T56;
    %calculate b
    b0=[0;0;1];
    b1=T01(1:3,3);
    b2=T02(1:3,3);
    b3=T03(1:3,3);
    b4=T04(1:3,3);
    b5=T05(1:3,3);
    %calculate argumented r and r
    X0A=T06*[0;0;0;1];
    X1A=X0A-T01*[0;0;0;1];
    X2A=X0A-T02*[0;0;0;1];
    X3A=X0A-T03*[0;0;0;1];
    X4A=X0A-T04*[0;0;0;1];
    X5A=X0A-T05*[0;0;0;1];
    r0A=X0A(1:3);
    r1A=X1A(1:3);
    r2A=X2A(1:3);
    r3A=X3A(1:3);
    r4A=X5A(1:3);
    r5A=X5A(1:3);
    J=[cross(b0,r0A) cross(b1,r1A) cross(b2,r2A) cross(b3,r3A) cross(b4,r4A) cross(b5,r5A);
    b0 b1 b2 b3 b4 b5];
    
end