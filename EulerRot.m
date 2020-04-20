function Rot_Mat=EulerRot(t)
Rx=[1 0 0; 0 cos(t(1)) -sin(t(1)); 0 sin(t(1)) cos(t(1))];
Ry=[cos(t(2)) 0 sin(t(2)); 0 1 0; -sin(t(2)) 0 cos(t(2))];
Rz=[cos(t(3)) -sin(t(3)) 0; sin(t(3)) cos(t(3)) 0; 0 0 1];
Rot_Mat=Rx*Ry*Rz;
end