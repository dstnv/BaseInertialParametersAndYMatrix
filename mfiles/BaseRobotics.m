% This Code finds the base/minimal inertial parameters (usually denoted \Theta) of a
% rational link manipulator and its Dynamic Matrix Y(q,dq,ddq)
% M(q)*ddq+C(q,dq)*dq+g(q)=Y(q,dq,ddq)*\Theta
% Y(q,dq,ddq)*\Theta=Y_M(q)*ddq+Y_B(q)*[dq.^2]+Y_C(q)*[dqdq]+Y_G(q)
% The method in Gautier, Khalil paper, on minimal inertial parameters, % 1990, is implemented.

% Note: Suppress displays of program outputs if you have too many joints to avoid possible slowdown.
% Note: Code was last tested on MATLAB 2015b
% Contact Sotoude, sotoude.dv@gmail.com

function BaseRobotics()

reset(symengine);
pi = sym('pi');

% Select Robot Identifier.
% For other robots, create a *.m file, to enter
% the DH and physical parameters. The format is found
% in RobotTemplate.m, KUKA4Symbolic.m
% (The file should be located in a matlab search path)
%
% Alternative:
% Enter the DH and physical parameters in symsReadDH.m and symsReadSpecs.m

% Robot Identifier.
RobotData = containers.Map('KeyType','char','ValueType','any');
symsReadDH(RobotData); % Robot Data Set, DH Parameters;
symsReadSpecs(RobotData); % Robot Data Set, Physical Parameters;
KeysNumOrder = RobotData.keys'; % Order of the key list

% Lists Robot Data
DisplayList(RobotData,KeysNumOrder);

% Prompt enter robot number or name
[FileIDInput,IDKey,IDNumber]=InputPrompt(RobotData,KeysNumOrder);

% Set robot variables
InputType = [~isempty(FileIDInput), ~isempty(IDKey), IDNumber~=0 && ~strcmp(KeysNumOrder{IDNumber},IDKey) ];
if nnz(InputType)~=1
    error('Incorrect file name, map container key, or input');
end
if InputType(1)
    run(FileIDInput); % read data from file 
    display(['Selected: ' FileIDInput]);
else
    if InputType(2) % robot name
        CurrentRobotData = RobotData(IDKey);
        display(['Selected: [' num2str(find(strcmp(IDKey,KeysNumOrder))) '] ' IDKey]); 
    elseif InputType(3) % robot number
        CurrentRobotData = RobotData(KeysNumOrder{IDNumber});
        display(['Selected: [' num2str(IDNumber) '] '    KeysNumOrder{IDNumber}]); 
    end
    
    % Set robot variables
    alpha = CurrentRobotData('alpha');
    d = CurrentRobotData('d');
    a = CurrentRobotData('a');
    theta = CurrentRobotData('theta');
    joint_type = CurrentRobotData('joint_type');
    N = CurrentRobotData('N');
    m = CurrentRobotData('m');
    iPci = CurrentRobotData('iPci');
    ciIi = CurrentRobotData('ciIi');
    g = CurrentRobotData('g');
end

% Add base frame
joint_type=sym([0;joint_type(:)]);
alpha=sym([0;alpha(:)]);
d=sym([0;d(:)]);
a=sym([0;a(:)]);
theta=sym([0;theta(:)]);

display('Finding Transformation Matrices');
NonStationaryJoints = logical( joint_type(2:N+1) ~= -1 );
s_q = sym('q',[N,1],'real').*NonStationaryJoints; % symbolic position vector
s_theta=theta+[false;s_q].*joint_type;  % Adds the angles to the theta vector
s_d=d+[false;s_q].*(sym(1)-joint_type); % Adds the offsets to the d vector
T=symsComputeTransformation(alpha,a,s_d,s_theta,N); % Computes the relative transformation matrix between frames k and k-1 where k=2:(N+1)
assignin('base', 'TransformationMatrix', T);

display('Finding Jacobian'); 
ContactTransformationT=sym([1,0,0,sym('ContactP_x','real');... % given in last joints frame, [Contact_x,Contact_y,Contact_z] is the point the jacobian is obtained for
             0,1,0,sym('ContactP_y','real');...
             0,0,1,sym('ContactP_z','real');...
             0,0,0,1]);
TfromBase=T;
for joint=2:N
    TfromBase(:,:,joint) = TfromBase(:,:,joint-1) *  T(:,:,joint); 
end
JacobianMatrix=ManipulatorJacobianTB(TfromBase,ContactTransformationT);
assignin('base', 'JacobianMatrix', JacobianMatrix);

% Convert To m*iPci, find moment of inertia iIi at distance iPci from ciIi
m=sym([0;m(:)]);
iPci=sym([zeros(3,1),iPci]);
ciIi=sym(cat(3,zeros(3,3,1),ciIi));
g = sym(g);
[miPci,iIi]=ConvertTomiPci(m,iPci,ciIi,N);

% Finding dynamic equations
s_dq = sym('dq',[N,1],'real').*NonStationaryJoints; % symbolic velocity vector
s_ddq = sym('ddq',[N,1],'real').*NonStationaryJoints; % symbolic acceleration vector
display('Finding base inertial parameters');
[mMIP,miPciMIP,iIiMIP]=FindMinimalParameters(m,miPci,iIi,alpha,a,d,N); % Obtains lumped parameters mMIP, miPciMIP, iIiMIP.
[mMIPLump,miPciMIPLump,iIiMIPLump]=GenericPhysicalData(N); % Generic Physical Specs. For seperations of base parameters.
% Finds lumped parameters: mMIPLump, miPciMIPLump, iIiMIPLump
mMIPlogical = ~equalsymMatrix2(mMIP,0);
mMIPLump = mMIPlogical.'.*[false,mMIPLump];
miPciMIPlogical = ~equalsymMatrix2(miPciMIP,0);
miPciMIPLump=miPciMIPlogical.*[false(3,1),miPciMIPLump];
iIiMIPlogical = ~equalsymMatrix3(iIiMIP,0);
iIiMIPLump = iIiMIPlogical.*cat(3,false(3,3,1),iIiMIPLump);
% Finds lumped base parameters and base parameters
iIiMIPlogical(2:3,1,:)=false;
iIiMIPlogical(3,2,:)=false;
MIPLump=[mMIPLump(mMIPlogical);miPciMIPLump(miPciMIPlogical);iIiMIPLump(iIiMIPlogical)]; % Lumped base parameters
MIP=[mMIP(mMIPlogical);miPciMIP(miPciMIPlogical);iIiMIP(iIiMIPlogical)];  % Base Inertial parameters

display('Finding dynamics in terms of lumped parameters');
NMIPLump = size(MIPLump,1);
tempchar = '';
for mip=1:NMIPLump
    tempchar = [tempchar '''' char(MIPLump(mip)) ''','];
end
TauDynamics=symsmiPciInverseDynamics(T,TfromBase,joint_type,N,mMIPLump,miPciMIPLump,iIiMIPLump,g,s_dq,s_ddq,'Normal',[]); % Returns dynamics
tempTau = cell(1,NMIPLump);
tempTau(:) = {false};
YMatrix=sym(false(N,NMIPLump)); % Dynamics Matrix Y
mipzero=false(NMIPLump,1);
fprintf('Finding YMatrix for Base Parameter ');
for mip=1:NMIPLump
    fprintf([repmat('\b',1,ceil(log10(mip))) num2str(mip)]);
    tempTau{mip} = true;
    eval(['tempYmip=subs(TauDynamics,{' tempchar(1:end-1) '},tempTau); ']);
    if nnz(tempYmip)~=0
        YMatrix(:,mip)=tempYmip; 
    else
        mipzero(mip)=true;
    end
    tempTau{mip} = false;
end
YMatrix(:,find(mipzero))=[]; % Dynamics of the robot: YMatrix*MIP
MIPLump(mipzero)=[];
MIP(mipzero)=[]; % Base Inertial parameters
NMIPLump = NMIPLump-nnz(mipzero); % Number of base inertial parameter

fprintf('\nLumped base inertial parameters:');
disp(MIPLump.');
display('Base inertial parameters:');
for mip=1:NMIPLump
    fprintf(['[' num2str(mip) ']\t' char(MIP(mip)) '\n']);
end
fprintf(['\nNumber of base inertial parameters: ' num2str(NMIPLump) '\n']);

assignin('base', 'BIP', MIP);
assignin('base', 'Y', YMatrix);
assignin('base', 'TauDynamics', YMatrix*MIP);

% Display
if N<5
    fprintf('\nOutputs:\n\n');
    fprintf('Dynamics Matrix:');
    display(YMatrix); 
    fprintf('Robot Dynamics:');    
    display(TauDynamics); % Dynamics of the robot: Dynamics=YMatrix*MIP
else
    fprintf('\nOutputs:\n\n');
    fprintf('Base Inertial Parameters :  BIP\n');
    fprintf('         Jacobian Matrix :  JacobianMatrix\n');
    fprintf('   Transformation Matrix :  TransformationMatrix\n');
    fprintf('         Dynamics Matrix :  Y\n');
    fprintf('          Robot Dynamics :  TauDynamics\n\n');    
end

end
