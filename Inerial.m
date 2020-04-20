function J= Inerial(Ixx,Iyy,Izz,Ixy,Ixz,Iyz,m,x,y,z)
J=zeros(4,4);
J(1,1)=(-Ixx+Iyy+Izz)/2;
J(1,2)=Ixy;J(2,1)=Ixy;
J(1,3)=Ixz;J(3,1)=Ixz;
J(1,4)=m*x;J(4,1)=m*x;
J(2,2)=(Ixx-Iyy+Izz)/2;
J(2,3)=Iyz;J(3,2)=Iyz;
J(2,4)=m*y;J(4,2)=m*y;
J(3,3)=(Ixx+Iyy-Izz)/2;
J(3,4)=m*z;J(4,3)=m*z;
J(4,4)=m;
end