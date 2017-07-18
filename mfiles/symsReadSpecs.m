% Reads the physical parameters: center of mass, link inertia matrix, link mass
function symsReadSpecs(RobotData)


% -------
RobotName = 'Planar1D'; % Type: Character Array
m = sym('m1','real'); % Vector of size N, The first column corresponds to link/frame 1, Nth column corresponds to the last link/frame or end-effector
iPci=[sym('l1','real');0;0]; % A 3 by N Matrix, each column is the link mass, m, multiplied by Pci, The link's center of mass location with respect to its own coordinate
ciIi(:,:,1)=[0,0,0;0,0,0;0,0,0]; % ciIi: 3 by 3 by N array, each 3 by 3 matrix is a link inertia matrix
g=sym('g','real'); % Gravity
SpecsValidateSaveNext;


% -------
RobotName = 'Planar2D'; % Type: Character Array
m = [sym('m1','real'),sym('m2','real')];
iPci=[sym('lc1','real'),0,0;sym('lc2','real'),0,0].';
ciIi(:,:,1)=[0,0,0;0,0,0;0,0,sym('I1','real')];
ciIi(:,:,2)=[0,0,0;0,0,0;0,0,sym('I2','real')];
g=sym('g','real');
SpecsValidateSaveNext;


% -------
RobotName = 'PUMA560'; % Type: Character Array
m=[0,17.4,4.8,0.82,0.34,0.09];
iPci=[0,0,0;0.068,0.006,-0.016;0,-0.070,0.014;0,0,-0.019;0,0,0;0,0,0.032].';
ciIi(:,:,1)=[0,0,0;0,0,0;0,0,0.35+1.14];
ciIi(:,:,2)=[0.13,0,0;0,0.524,0;0,0,0.539+4.71];
ciIi(:,:,3)=[0.066,0,0;0,0.0125,0;0,0,0.086+0.83];
ciIi(:,:,4)=[0.0018,0,0;0,0.0018,0;0,0,0.0013+0.2];
ciIi(:,:,5)=[0.0003,0,0;0,0.0003,0;0,0,0.0004+0.179];
ciIi(:,:,6)=[0.00015,0,0;0,0.00015,0;0,0,0.00004+0.193];
g=9.78;
SpecsValidateSaveNext;


% -------
RobotName = 'PUMA560Symbolic'; % Type: Character Array
N = subsref(RobotData(RobotName),struct('type','()','subs',{'N'})  );
[m,iPci,ciIi] = GenericPhysicalData(N);
m(1)=false;
iPci(([0,0,0;0.068,0.006,-0.016;0,-0.070,0.014;0,0,-0.019;0,0,0;0,0,0.032].'==0))=false;
ciIi( cat(3,[0,0,0;0,0,0;0,0,0.35],...
    [0.13,0,0;0,0.524,0;0,0,0.539],...
    [0.066,0,0;0,0.0125,0;0,0,0.086],...
    [0.0018,0,0;0,0.0018,0;0,0,0.0013],...
    [0.0003,0,0;0,0.0003,0;0,0,0.0004],...
    [0.00015,0,0;0,0.00015,0;0,0,0.00004])==0 )=false;
g=sym('g','real');
SpecsValidateSaveNext;

% -------
RobotName = 'KUKA4Symbolic';
N = subsref(RobotData(RobotName),struct('type','()','subs',{'N'})  );
[m,iPci,ciIi] = GenericPhysicalData(N);
g=sym('g','real');
SpecsValidateSaveNext;

% -------
RobotName = 'GeomagicTouch';
N = subsref(RobotData(RobotName),struct('type','()','subs',{'N'})  );
[m,iPci,ciIi] = GenericPhysicalData(N);
g=sym('g','real');
SpecsValidateSaveNext;

    % Function, validating and storing variable values
    function SpecsValidateSaveNext
        N = subsref(RobotData(RobotName),struct('type','()','subs',{'N'})  );
        ValidatePhysSpecs(RobotName,m,iPci,ciIi,g,N,mfilename);
        RobotData(RobotName)=[RobotData(RobotName);containers.Map({'m','iPci','ciIi','g'},{m,iPci,ciIi,g},'UniformValues',false)];
        clearvars -except RobotData;
    end

end