function q=UR5numIK(P,int_Q)
p=P;
int_q=int_Q;
iteration=0;
while true
     J=UR5Jocb(int_q);
     int_T=UR5Ftrans(int_q,6);
     int_pos=int_T*[0;0;0;1];
     int_pos=int_pos(1:3,1);
%     int_phi=SolveEulerAngle(int_T(1:3,1:3));
%     int_p=[int_pos;int_phi'];
    int_p=int_pos;
    e=p-int_p;
%     norm(e)
    if norm(e)<0.001
        break;
%     end
%     if norm(e)>0.1
%         dq=0.01*pinv(J)*e;
%         int_q=int_q+dq;
    else
%         dq=0.0001*pinv(J)*e;
        dq=0.0001*pinv(J(1:3,:))*e;

        int_q=int_q+dq;
    end
    iteration=iteration+1;
end
q=int_q;

end