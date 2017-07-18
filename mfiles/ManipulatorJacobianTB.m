function JacobianMatrix=ManipulatorJacobianTB(TfromBase,T_last_point)

NumberofJoints=size(TfromBase,3)+1;
TfromBase(:,:,NumberofJoints)=TfromBase(:,:,NumberofJoints-1)*T_last_point;
JacobianMatrix=sym(false(6,NumberofJoints));
for joint=1:( NumberofJoints)
    JacobianMatrix (:,joint) = [ cross( TfromBase(1:3,3,joint) , - TfromBase(1:3,4,joint) ) ; TfromBase(1:3,3,joint) ];
end
JacobianMatrix(:,NumberofJoints - 1 ) = [];