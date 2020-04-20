# UR5_virtual_simulation
Matlab-VREP co-simulation

Simple control of UR5 robot in Matlav and V-REP

##Re-Run the codes
1.Make sure that remote API documents in the folder: remoteApiProto.m remApi.m remoteApi.dll
2.Open the V-REP scene in the folder scene
3.Run simluation_1.m for the first simulation.
4.Run simulation_2.m for the second simulation.

##Main functions
DHtrans.m and Dhtransform.m : calculate transformation matrix of DH model
Dynamics_eq.m : calculate L-E dynamic equations
EulerRot.m and SolveEulerAngles.m : calculate Euler rotation matrix form Euler angles; calculate Euler angles form rotation matrix
UR5Ftrans: calculate forward kinematics
UR5IK: solve inverse kinematics in analytic method
UR5numIK: solve inverse kinematics in numerical method
UR5Jocb: calculate Jacobian matrix
vrchk: check V-REP return codes
