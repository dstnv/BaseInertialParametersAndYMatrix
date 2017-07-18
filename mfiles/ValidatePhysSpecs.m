% Validate Physical parameters
function ValidatePhysSpecs(RobotName,m,iPci,ciIi,g,N,DataFileName)
    validateattributes(m,{'numeric','sym'},{'vector','numel', N},DataFileName,['m' ' in ' RobotName]);
    validateattributes(iPci,{'numeric','sym'},{'size', [3,N]},DataFileName,['iPci' ' in ' RobotName]);
    validateattributes(ciIi,{'numeric','sym'},{'size', [3,3,N]},DataFileName,['ciIi' ' in ' RobotName]);
    validateattributes(g,{'numeric','sym'},{'scalar'},DataFileName,['g' ' in ' RobotName]);
end

