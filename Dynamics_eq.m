function L=Dynamics_eq(q,qv,qa)
    syms t1 t2 t3 t4 t5 t6 t1v t2v t3v t4v t5v t6v
    t=[t1 t2 t3 t4 t5 t6];
    tv=[t1v t2v t3v t4v t5v t6v];
    %DH parameters
    d1 = 0.089159;d2 = 0;d3 = 0;d4 = 0.10915;d5 = 0.09465;d6 = 0.0823;
    a1 = 0;a2 = -0.425;a3 = -0.39225;a4 = 0;a5 = 0;a6 = 0;
    alpha1 = pi/2;alpha2 = 0;alpha3 = 0;alpha4 = pi/2;alpha5 = -pi/2;alpha6 = 0;
    %DH transformation
    T01 = DHtransform(a1, alpha1, d1, t1);
    T12 = DHtransform(a2, alpha2, d2, t2);
    T23 = DHtransform(a3, alpha3, d3, t3);
    T34 = DHtransform(a4, alpha4, d4, t4);
    T45 = DHtransform(a5, alpha5, d5, t5);
    T56 = DHtransform(a6, alpha6, d6, t6);
    T02 = T01*T12; T03 = T02*T23; T04 = T03*T34; T05 = T04*T45; T06=T05*T56;
    % Inerial propertites
    Ixx=zeros(1,6);Iyy=zeros(1,6); Izz=zeros(1,6);Ixy=zeros(1,6);Ixz=zeros(1,6);Iyz=zeros(1,6);
    Ixx(1,1)=0.01027;Iyy(1,1)=0.01027;Izz(1,1)=0.00666;
    Ixx(1,2)=0.22689;Iyy(1,2)=0.22689;Izz(1,2)=0.015107;
    Ixx(1,3)=0.04944;Iyy(1,3)=0.04944;Izz(1,3)=0.004095;
    Ixx(1,4)=0.11117;Iyy(1,4)=0.11117;Izz(1,4)=0.21942;
    Ixx(1,5)=0.11117;Iyy(1,5)=0.11117;Izz(1,5)=0.21942;
    Ixx(1,6)=0.017136;Iyy(1,6)=0.017136;Izz(1,6)=0.033822;
    %Mass properties;
    m=[3.7 8.4 2.33 1.219 1.219 0.1879];
    xc=zeros(1,6);yc=zeros(1,6);zc=zeros(1,6);
    xc(1,1)=0;yc(1,1)=-0.02561;zc(1,1)=0.00193;
    xc(1,2)=0.2125;yc(1,2)=0;zc(1,2)=0.11336;
    xc(1,3)=0.15;yc(1,3)=0;zc(1,3)=0.0265;
    xc(1,4)=0;yc(1,4)=-0.0018;zc(1,4)=0.01634;
    xc(1,5)=0;yc(1,5)=0.0018;zc(1,5)=0.01634;
    xc(1,6)=0;yc(1,6)=0;zc(1,6)=-0.001159;
    J=zeros(4,4,6);
    for i=1:6
        J(:,:,i)=Inerial(Ixx(i),Iyy(i),Izz(i),Ixy(i),Ixz(i),Iyz(i),m(i),xc(i),yc(i),zc(i));
    end
    
    Q=[0 -1 0 0; 
       1 0 0 0;
       0 0 0 0;
       0 0 0 0];
    n=6;
    u=cell(n,n);
    for i=1:n
        for j=1:n
        u{i,j}=zeros(4,4);
    end
    end
    u{1,1}=Q*T01;u{2,1}=Q*T02;u{2,2}=T01*Q*T12;
    u{3,1}=Q*T03;u{3,2}=T01*Q*(T12*T23);u{3,3}=T02*Q*T23;
    u{4,1}=Q*T04;u{4,2}=T01*Q*(T12*T23*T34);u{4,3}=T02*Q*(T23*T34);u{4,4}=T03*Q*T34;
    u{5,1}=Q*T05;u{5,2}=T01*Q*(T12*T23*T34*T45);u{5,3}=T02*Q*(T23*T34*T45);u{5,4}=T03*Q*(T34*T45);u{5,5}=T04*Q*T45;
    u{6,1}=Q*T06;u{6,2}=T01*Q*(T12*T23*T34*T45*T56);u{6,3}=T02*Q*(T23*T34*T45*T56);u{6,4}=T03*Q*(T34*T45*T56);u{6,5}=T04*Q*(T45*T56);u{6,6}=T05*Q*T56;
    %Calculate D
    g2=[0;0;-0.980;0];
    d=cell(n,n);
     for j=1:n
        for k=1:n
            M=max(j,k); D=cell(n+1-M,1);
           for i=M:n
                D{i-M+1,1}=simplify(trace(u{i,j}*J(:,:,i)*transpose(u{i,k})));
           end
        temp= cellfun(@sum,D);
           d{j,k}=simplify(sum(temp(:))); 
        end
     end
     %Calculate G
     g=cell(n,1);
    for k=1:n
         G=cell(n-k+1,1);
         for j=k:n
             G{-k+j+1,1}=-m(j)*transpose(g2)*u{j,k}*[xc(j);yc(j);zc(j);1];
         end
        temp2 = simplify(cellfun(@sum,G));
        g{k,1}=sum(temp2);
    end
    %Calculate C
     c=cell(n,n);
     for k=1:n
        for j=1:n
            C=cell(n,1);
            for i=1:n
                C{i,1}=0.5*(diff(d{k,j},t(i))+diff(d{k,i},t(j))-diff(d{i,j},t(k)))*tv(i);
            end
             temp3 = simplify(cellfun(@sum,C));
         c{k,j}=sum(temp3);
        end
     end
     d=double(subs(d,{'t1','t2','t3','t4','t5','t6'},{q(1),q(2),q(3),q(4),q(5),q(6)}));
     g=double(subs(g,{'t1','t2','t3','t4','t5','t6'},{q(1),q(2),q(3),q(4),q(5),q(6)}));
     c=double(subs(c,{'t1','t2','t3','t4','t5','t6','t1v','t2v','t3v','t4v','t5v','t6v'},{q(1),q(2),q(3),q(4),q(5),q(6),qv(1),qv(2),qv(3),qv(4),qv(5),qv(6)}));
    L=[d,g,c] 
    
end