% Validate Denavit-Hartenberg parameters
function ValidateDH(RobotName,alpha,a,d,theta,joint_type,N,DataFileName,RobotData)
    validateattributes(RobotName,{'char'},{},DataFileName,['RobotName' ' in ' char(RobotName)]);
    if ( RobotName(1) == '''' || RobotName(end) == '''' )
        error(['In ' DataFileName ' RobotName first or last char must be other than ''']);
    end
    if isa(RobotData,'containers.Map') && isKey(RobotData,RobotName)
        error(['In ' DataFileName ', Robot Name ''' RobotName ''' is repeated']);
    end
    validateattributes(N,{'numeric'},{'scalar','integer','positive'},DataFileName,['N' ' in ' RobotName]);
    validateattributes(alpha,{'numeric','sym'},{'vector','numel', N},DataFileName,['alpha' ' in ' RobotName]);
    validateattributes(a,{'numeric','sym'},{'vector','numel', N},DataFileName,['a' ' in ' RobotName]);
    validateattributes(d,{'numeric','sym'},{'vector','numel', N},DataFileName,['d' ' in ' RobotName]);
    validateattributes(theta,{'numeric','sym'},{'vector','numel', N},DataFileName,['theta' ' in ' RobotName]);
    validateattributes(joint_type,{'numeric'},{'vector','numel', N},DataFileName,['joint_type' ' in ' RobotName]);
    if nnz( joint_type ~= 1 & joint_type ~= 0 & joint_type ~= -1 )
        error(['In ' DataFileName ' joint_type must be -1, 0, or 1']);
    end
end

