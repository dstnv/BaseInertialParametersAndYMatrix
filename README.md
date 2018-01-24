## BaseInertialParametersAndYMatrix

Finds Symbolic Base (Minimal) Intertial Parameters of Rotational Link Robots, and their Dynamic Y(q,dq,ddq) Matrix:

M(q)*ddq+C(q,dq)*dq+g(q)=Y(q,dq,ddq)*Theta


### Usage

```
>> BaseRobotics
```

### Example 1

`RobotTemplate.m` gives a generic symbolic template for entering robot parameters. The template is adjusted based on the DH parameters and physical parameters. Modified DH parameters are used. An example is KUKA4Symbolic.m file. It is the template modified for KUKA LWR IV+, by setting the DH-parameters. The zero terms of the link inertia matrix, due to symmetry, are also specified.

Calling `BaseRobotics`, the input prompt asks for selecting from a list of robots. By entering `KUKA4Symbolic.m` at the prompt, `BaseRobotics` reads the parameters for KUKA LWR IV+, and calculates the base parameters and the dynamic matrix.
```
>> BaseRobotics
.
.
>> Enter Robot # or Name: KUKA4Symbolic.m
.
.
Outputs:

Base Inertial Parameters :  BIP
         Jacobian Matrix :  JacobianMatrix
   Transformation Matrix :  TransformationMatrix
         Dynamics Matrix :  Y
          Robot Dynamics :  TauDynamics
```

The output lists the variables names for the symbolic model. For example `BIP`:

```
Base inertial parameters:
[1]	mG2*mYG2 + mG3*mZG3 + lp*(mG3 + mG4 + mG5 + mG6 + mG7)
[2]	mG3*mYG3 + mG4*mZG4
[3]	mG4*mYG4 - mG5*mZG5 - lpp*(mG5 + mG6 + mG7)
[4]	mG5*mYG5 - mG6*mZG6
[5]	mG6*mYG6 + mG7*mZG7
[6]	mG7*mYG7
[7]	YYG2 + ZZG1 + mG2*mZG2^2
[8]	XXG2 - YYG2 + YYG3 - mG2*mZG2^2 + mG3*mZG3^2 + lp^2*(mG3 + mG4 + mG5 + mG6 + mG7) + mG2*(mYG2^2 + mZG2^2) + 2*lp*mG3*mZG3
[9]	YZG2 - mG2*mYG2*mZG2
[10]	YYG3 + ZZG2 + mG2*mYG2^2 + mG3*mZG3^2 + lp^2*(mG3 + mG4 + mG5 + mG6 + mG7) + 2*lp*mG3*mZG3
[11]	XXG3 - YYG3 + YYG4 - mG3*mZG3^2 + mG4*mZG4^2 + mG3*(mYG3^2 + mZG3^2)
[12]	YZG3 - mG3*mYG3*mZG3
[13]	YYG4 + ZZG3 + mG3*mYG3^2 + mG4*mZG4^2
[14]	XXG4 - YYG4 + YYG5 - mG4*mZG4^2 + mG5*mZG5^2 + mG4*(mYG4^2 + mZG4^2) + lpp^2*(mG5 + mG6 + mG7) + 2*lpp*mG5*mZG5
[15]	YZG4 - mG4*mYG4*mZG4
[16]	YYG5 + ZZG4 + mG4*mYG4^2 + mG5*mZG5^2 + lpp^2*(mG5 + mG6 + mG7) + 2*lpp*mG5*mZG5
[17]	XXG5 - YYG5 + YYG6 - mG5*mZG5^2 + mG6*mZG6^2 + mG5*(mYG5^2 + mZG5^2)
[18]	YZG5 - mG5*mYG5*mZG5
[19]	YYG6 + ZZG5 + mG5*mYG5^2 + mG6*mZG6^2
[20]	XXG6 - YYG6 + YYG7 - mG6*mZG6^2 + mG7*mZG7^2 + mG6*(mYG6^2 + mZG6^2)
[21]	YZG6 - mG6*mYG6*mZG6
[22]	YYG7 + ZZG6 + mG6*mYG6^2 + mG7*mZG7^2
[23]	XXG7 - YYG7 - mG7*mZG7^2 + mG7*(mYG7^2 + mZG7^2)
[24]	-mG7*mYG7*mZG7
[25]	ZZG7 + mG7*mYG7^2
```

It is not efficient to print large symbolic variables such as `Y` or `TauDynamics` for robots with N>6.

`KUKA4Symbolic.m` defines the variables in `BIP`. `mGi` is mass of link `i`,  `mXGi`  is the x-coordinate of the center of mass of link `i` with respect to coordinate `i`. `XXGi` is the first element of the inertia matrix of link `i` with respect to center of mass of link `i`. The arrays containing the symbolic parameters are `m`, `iPci` for center of mass, `ciIi` for link inertia matrix. `alpha`,`a`,`d`,`theta` are the modified DH parameters.

`JacobianMatrix` gives the jacobian from last coordinate to the base. `Y` is the dynamic matrix, and `TauDynamics` is the robot dynamics. It is equal to `Y*BIP`.

### Example 2
-----

Calling `BaseRobotics` lists the robots described in `symsReadDH.m` and `symsReadSpecs.m`. The DH parameters are read from `symsReadDH.m`. The physical parameters are read from `symsReadSpecs.m`. The format for DH and physical parameters is consistent with `RobotTemplate.m`, and same as in example 1.


```
>> BaseRobotics
    [1]    'Planar1D'  
    .
    .
    [6]    'Planar2D'       

Enter Robot # or Name:
```

`symsReadDH.m` and `symsReadSpecs.m` contain the parameters of a few robots. `Planar2D` is given by:

```
% symsReadDH.m, Modified DH parameters:
RobotName = 'Planar2D'; % Type: Character Array
alpha = [0;0]*pi/180;
a = [0;sym('l1','real')];
d = [0;0];
theta=[0;0]*pi/180;
joint_type=[1;1]; 
N = 2;
```
```
% symsReadSpecs.m:
RobotName = 'Planar2D'; % Type: Character Array
m = [sym('m1','real'),sym('m2','real')];
iPci=[sym('lc1','real'),0,0;sym('lc2','real'),0,0].';
ciIi(:,:,1)=[0,0,0;0,0,0;0,0,sym('I1','real')];
ciIi(:,:,2)=[0,0,0;0,0,0;0,0,sym('I2','real')];
g=sym('g','real');

```

