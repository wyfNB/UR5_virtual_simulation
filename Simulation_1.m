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
%% Construct the base frame
% [res, handles.base] = vrep.simxGetObjectHandle(id, ...
%     'Frame0', vrep.simx_opmode_oneshot_wait);
% vrchk(vrep, res);


%% Initiation
threshold = 0.01;
startingJoints = [pi/2, pi/2, 0, pi/2, 0, pi/2];
% startingJoints = [pi/2, pi/2, -pi/2, pi/2, 0, pi/2];
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
%% Move to a point
%The initial plane
nInit=[0;-1;0];
%Target point
nTar=[-1;0;0];
pos=[-0.1;-0.2;0.3];
Rot=eye(4,4);
Rot(1:3,1:3)=fRot(nInit,nTar);
trans=eye(4,4);
trans(1:3,4)=pos;
pause(1);
x=0; z=0;%set this point as origin
T=Rot*[1,0,0,0.1*x;0,0,-1,0;0,1,0,0.1*z;0,0,0,1]; % rotation
T=trans*T; %translation
theta = UR5IK(T);
targetJointss = wrapTo2Pi(theta(:,1)'+startingJoints);
for j = 1:6
    vrep.simxSetJointTargetPosition(id, handles.ur5Joints(j),...
        targetJointss(j), ...
        vrep.simx_opmode_oneshot);
    vrchk(vrep, res);
end
%% User input control
scatter(x,z,'b*');
axis([-1 1 -1 1]);
hold on
for i=1:1:50
    [x, z, key] = ginput(1);
    scatter(x,z,'b*');
    if (key == 's') % To end the drawing
        disp('End of cycle.')
        break;
    else
        Tdes=Rot*[1,0,0,0.1*x;0,0,-1,0;0,1,0,0.1*z;0,0,0,1]; % Rotation
        Tdes=trans*Tdes;   %Translation
        theta = UR5IK(Tdes);
        targetJointss = wrapTo2Pi(theta(:,1)'+startingJoints);
        for j = 1:6
            vrep.simxSetJointTargetPosition(id, handles.ur5Joints(j),...
                targetJointss(j), ...
                vrep.simx_opmode_oneshot);
            vrchk(vrep, res);
        end
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


