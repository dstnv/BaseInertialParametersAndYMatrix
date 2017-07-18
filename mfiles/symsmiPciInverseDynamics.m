% Finds inverse dynamics
function tau_i=symsmiPciInverseDynamics(T,TfromBase,joint_type,N,m,miPci,iIi,g,s_dq,s_ddq,TheFlag,JointNo)

if ~strcmp(TheFlag,'sFindYMYG')
    
    if  strcmp(TheFlag,'FindYM')
        g=false;
        s_dq=sym(false(N,1));
    elseif strcmp(TheFlag,'FindYC')
        g=false;
        s_ddq=sym(false(N,1));
    elseif strcmp(TheFlag,'FindYG')
        s_dq=sym(false(N,1));
        s_ddq=sym(false(N,1));
    elseif strcmp(TheFlag,'FindYMYG')
        s_dq=sym(false(N,1));
    elseif strcmp(TheFlag,'Normal')
    elseif strcmp(TheFlag,'YMSignleJoint')
        if nnz(JointNo==[1:N])~=1
            error('Use correct joint number');
        else
            g=false;
            s_dq=sym(false(N,1));
            s_ddq=sym(false(N,1));
            s_ddq(JointNo)=true;
        end
    elseif strcmp(TheFlag,'YBCDoubleJoint')
        if ( nnz(JointNo(1)==[1:N]) + nnz(JointNo(2)==[1:N]) )~=2
            error('Use correct joint numbers');
        else
            g=false;
            s_dq=sym(false(N,1));
            s_ddq=sym(false(N,1));
            s_dq(JointNo(1))=true;
            s_dq(JointNo(2))=true;
        end
    else
        error('Make sure you are using the correct flag for symsmiPciInverseDynamics');
    end
    tau_i=symsmiPciCompute_i_i(s_dq,s_ddq,miPci,iIi,joint_type,m,N,T,TfromBase,g); % Finds the dynamics
else
    tau_i=symsmiPciCompute_si(s_ddq,miPci,iIi,m,N,T,TfromBase,g); % Finds the dynamics
end

end