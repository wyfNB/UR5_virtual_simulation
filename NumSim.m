%% Path planning
q0=[0;0;-pi/2;0;0;0];
T=UR5Ftrans(q0,6);
pos0=T*[0;0;0;1];
a=1:90;
p=zeros(3,size(a,2));
for i=1:size(a,2)
    pos=zeros(3,1);
    pos(1)=pos0(1);
    pos(2)=pos0(2)-0.1+0.1*cosd(a(i));
    pos(3)=pos0(3)+0.1*sind(a(i));
    p(:,i)=pos;
end

q=zeros(6,size(a,2));
q(:,1)=UR5numIK(p(:,1),q0);
for i=2:size(a,2)
    q(:,i)=UR5numIK(p(:,i),q(:,i-1));
    
end

%% Connect Vrep to Matlab
vrep=remApi('remoteApi');
vrep.simxFinish(-1);
id = vrep.simxStart('127.0.0.1', 19997, true, true, 2000, 5);
if id < 0
    disp('Failed connecting to remote API server. Exiting.');
    vrep.delete();
    return;
end
fprintf('Connection %d to remote API server open.\n', id);
%% Construct the joints frame for UR5
handles = struct('id', id);
jointNames={'UR5_joint1','UR5_joint2','UR5_joint3','UR5_joint4','UR5_joint5','UR5_joint6'};
ur5Joints = -ones(1,6);
for i = 1:6
    [res, ur5Joints(i)] = vrep.simxGetObjectHandle(id, ...
        jointNames{i}, vrep.simx_opmode_oneshot_wait);
    vrchk(vrep, res);
end
handles.ur5Joints = ur5Joints;
[res, ur5Ref] = vrep.simxGetObjectHandle(id, 'UR5', ...
    vrep.simx_opmode_oneshot_wait);
vrchk(vrep, res);
handles.ur5Ref = ur5Ref;


%% Initiation
threshold = 0.01;
startingJoints = [pi/2, pi/2, -pi/2, pi/2, 0, pi/2];
res = vrep.simxPauseCommunication(id, true);
vrchk(vrep, res);
for i = 1:6
    res = vrep.simxSetJointTargetPosition(id, handles.ur5Joints(i),...
        startingJoints(i),...
        vrep.simx_opmode_oneshot);
    vrchk(vrep, res, true);
end
res = vrep.simxPauseCommunication(id, false);
vrchk(vrep, res);
%% Follow the path
for i=1:size(q,2)
targetJointss = wrapTo2Pi(q(:,i)'+startingJoints);
for j = 1:6
    vrep.simxSetJointTargetPosition(id, handles.ur5Joints(j),...
        targetJointss(j), ...
        vrep.simx_opmode_oneshot);
    vrchk(vrep, res);
end
end

%% Go back to intial position
for i = 1:6
    res = vrep.simxSetJointTargetPosition(id, handles.ur5Joints(i),...
        startingJoints(i),...
        vrep.simx_opmode_oneshot);
    vrchk(vrep, res, true);
end
res = vrep.simxPauseCommunication(id, false);
vrchk(vrep, res);


