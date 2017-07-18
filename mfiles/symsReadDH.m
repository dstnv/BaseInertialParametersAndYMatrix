% Reads a Set of Denavit-Hartenberg parameters
function symsReadDH(RobotData)

% -------
RobotName = 'Planar1D'; % Type: Character Array
alpha = 90*pi/180;
a = 0;
d = 0;
theta=0*pi/180;
joint_type=1; % type of joint, 1 (true) for revolute and 0 (false) for prismatic, -1 for end effector (or locked at zero/non-moving joints)
N = 1;
ValidateDH(RobotName,alpha,a,d,theta,joint_type,N,mfilename,RobotData);
RobotData(RobotName)=containers.Map({'alpha','a','d','theta','joint_type','N'},{alpha,a,d,theta,joint_type,N},'UniformValues',false);
clearvars -except RobotData;

% -------
RobotName = 'Planar2D'; % Type: Character Array
alpha = [0;0]*pi/180;
a = [0;sym('l1','real')];
d = [0;0];
theta=[0;0]*pi/180;
joint_type=[1;1]; % type of joint, 1 (true) for revolute and 0 (false) for prismatic, -1 for end effector (or locked at zero/non-moving joints)
N = 2;
ValidateDH(RobotName,alpha,a,d,theta,joint_type,N,mfilename,RobotData);
RobotData(RobotName)=containers.Map({'alpha','a','d','theta','joint_type','N'},{alpha,a,d,theta,joint_type,N},'UniformValues',false);
clearvars -except RobotData;

% -------
RobotName = 'PUMA560Symbolic'; % Type: Character Array
alpha=[0;-90;0;90;-90;90]*pi/180; 
a=[0;0;sym('a1','real');sym('a2','real');0;0]; 
theta=[0;0;0;0;0;0]*pi/180; 
d=[0;sym('d1','real');sym('d2','real');sym('d3','real');0;0];
joint_type=[1;1;1;1;1;1]; % type of joint, 1 means revolute and 0 means prismatic, -1 for end effector (or locked at zero/non-moving joints)
N=6; % the number of joints
ValidateDH(RobotName,alpha,a,d,theta,joint_type,N,mfilename,RobotData);
RobotData(RobotName)=containers.Map({'alpha','a','d','theta','joint_type','N'},{alpha,a,d,theta,joint_type,N},'UniformValues',false);
clearvars -except RobotData;

% -------
RobotName = 'PUMA560'; % Type: Character Array
alpha=[0;-90;0;90;-90;90]*pi/180; % add a zero at the end
a=[0;0;0.4318;-0.0203;0;0]; % add a zero at the end
theta=[0;0;0;0;0;0]*pi/180; % add a zero at the end
d=[0;0.2435;-0.0934;0.4331;0;0]; % add a zero at the end
joint_type=[1;1;1;1;1;1]; % type of joint, 1 means revolute and 0 means prismatic, -1 for end effector (or locked at zero/non-moving joints)
N=6; % the number of joints
ValidateDH(RobotName,alpha,a,d,theta,joint_type,N,mfilename,RobotData);
RobotData(RobotName)=containers.Map({'alpha','a','d','theta','joint_type','N'},{alpha,a,d,theta,joint_type,N},'UniformValues',false);
clearvars -except RobotData;

% -------
RobotName = 'KUKA4Symbolic';
alpha=  [0  ;90  ;-90    ;-90   ;90    ;90    ;-90]*pi/180; % add a zero at the end
a=      [0  ;0   ;0      ;0     ;0     ;0     ;0]; % add a zero at the end
theta=  [0  ;0   ;0      ;0     ;0     ;0     ;0]*pi/180; % add a zero at the end
d=      [0  ;0   ;sym('lp','real')    ;0     ;sym('lpp','real')  ;0     ;0]; % add a zero at the end
joint_type=[1;1;1;1;1;1;1]; % type of joint, 1 means revolute and 0 means prismatic, -1 for end effector (or locked at zero/non-moving joints)
N=7; % the number of joints
ValidateDH(RobotName,alpha,a,d,theta,joint_type,N,mfilename,RobotData);
RobotData(RobotName)=containers.Map({'alpha','a','d','theta','joint_type','N'},{alpha,a,d,theta,joint_type,N},'UniformValues',false);
clearvars -except RobotData;

% -------
RobotName = 'GeomagicTouch';
alpha=[-180;-90;0]*pi/180; % add a zero at the end
a=[0;sym('lp','real');sym('lpp','real')]; % add a zero at the end
d=[0;0;0]; % add a zero at the end
theta=[0;0;-90]*pi/180; % add a zero at the end
joint_type=[1;1;1]; % type of joint, 1 means revolute and 0 means prismatic, -1 for end effector (or locked at zero/non-moving joints)
N=3; % the number of joints
ValidateDH(RobotName,alpha,a,d,theta,joint_type,N,mfilename,RobotData);
RobotData(RobotName)=containers.Map({'alpha','a','d','theta','joint_type','N'},{alpha,a,d,theta,joint_type,N},'UniformValues',false);
clearvars -except RobotData;

end