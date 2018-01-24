% Modified Denavit-Hartenberg parameters
RobotName = 'KUKA4Symbolic';
alpha=  [0  ;90  ;-90    ;-90   ;90    ;90    ;-90]*pi/180; % add a zero at the end
a=      [0  ;0   ;0      ;0     ;0     ;0     ;0]; % add a zero at the end
theta=  [0  ;0   ;0      ;0     ;0     ;0     ;0]*pi/180; % add a zero at the end
d=      [0  ;0   ;sym('lp','real')    ;0     ;sym('lpp','real')  ;0     ;0]; % add a zero at the end
joint_type=[1;1;1;1;1;1;1]; % type of joint, 1 means revolute and 0 means prismatic % add a zero at the begining
N=7; % Number of joints
ValidateDH(RobotName,alpha,a,d,theta,joint_type,N,mfilename,[]);

% Physical parameters: link mass, center of mass, link inertia matrix
m=sym(zeros(1,N));
iPci=sym(zeros(3,N)); % center of mass with respect to coordinate i
ciIi=sym(zeros(3,3,N)); % link inertia with respect to center of mass of link i
for i=1:N
    m(i)=sym(['mG' num2str(i)],'real');
    iPci(:,i)=[sym(['mXG' num2str(i)],'real');sym(['mYG' num2str(i)],'real');sym(['mZG' num2str(i)],'real')];
    ciIi(:,:,i)=[sym(['XXG' num2str(i)],'real'),sym(['XYG' num2str(i)],'real'),sym(['XZG' num2str(i)],'real');...
                                      0,sym(['YYG' num2str(i)],'real'),sym(['YZG' num2str(i)],'real');...
                                      0,                             0,sym(['ZZG' num2str(i)],'real')];
    ciIi(2,1,i)=ciIi(1,2,i); ciIi(3,1,i)=ciIi(1,3,i); ciIi(3,2,i)=ciIi(2,3,i);
end
% Robot Symmetry
iPci(:,1)=zeros(3,1); 
iPci(1,:)=zeros(1,N);
ciIi(1:2,:,1)=0;ciIi(:,1:2,1)=0;
ciIi(1,2:3,2:N)=0;ciIi(2:3,1,2:N)=0;
ciIi(2,3,N)=0;ciIi(3,2,N)=0;
g=sym('g','real'); % Gravity
ValidatePhysSpecs(RobotName,m,iPci,ciIi,g,N,mfilename);
