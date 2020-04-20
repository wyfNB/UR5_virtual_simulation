function R=fRot(pv1,pv2)
%rotation vector
pw=cross(pv1,pv2);
pw_norm=pw/norm(pw);
pw_skew=[0 -pw_norm(3) pw_norm(2);pw_norm(3) 0 -pw_norm(1);-pw_norm(2) pw_norm(1) 0];
%rotation angle
cos_t=pv1'*pv2/(norm(pv1)*norm(pv2));
t=acos(cos_t);
%rotation matrix
R=eye(3)+pw_skew*sin(t)+pw_skew^2*(1-cos(t));
