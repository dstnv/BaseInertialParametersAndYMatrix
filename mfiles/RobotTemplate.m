% Modified Denavit-Hartenberg parameters
RobotName = 'RobotTemplate';
N=12; % Number of joints
alpha = sym('alpha', [N 1]); % In radians
a = sym('a', [N 1]); % In Meters
theta = sym('theta', [N 1]); % In radians
d = sym('d', [N 1]); % In Meters
joint_type=ones(N,1); % type of joint, 1 means revolute and 0 means prismatic % add a zero at the begining
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
g=sym('g','real'); % Gravity
ValidatePhysSpecs(RobotName,m,iPci,ciIi,g,N,mfilename);
