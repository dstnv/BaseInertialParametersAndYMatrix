% Accepts all the data of the manipulator and computes the dynamics
function tau_i=symsmiPciCompute_i_i(s_dq,s_ddq,miPci,iIi,joint_type,m,N,T,TfromBase,g)  
    % Joint 0 is the base frame, non-moving, In all matrices, the first parameter corresponds to the base frame
    omega_i_i=sym(false(3,N+1)); % Angular velocity of origin of link i respective to link i
    domega_i_i=sym(false(3,N+1)); % Derivative of angular velocity of origin of link i respective to link i
    dvelocities_i_i=sym(false(3,N+1)); % Derivative of Cartesian velocity of origin of link i respective to link i
    dvelocities_i_i(:,1)=[false;false;g];
    F_i_i=sym(false(3,N+1)); % Forward calculations, force applied to center of mass of link i respective to link i
    f_i_i=sym(false(3,N+2)); % force applied to center of mass of link i respective to link i
    n_i_i=sym(false(3,N+2)); % The moment applied to center of mass of link i respective to link i
    tau_i=sym(false(N,1)); % Dynamics torque/force
    T(:,:,N+1)=sym(logical(eye(4)));
    RT= T(1:3,1:3,:);
    fprintf('\n Forward Calculations Joint ');
    for i=1:N 
        fprintf([repmat('\b',1,ceil(log10(i))) num2str(i)]);
        omega_i_i(:,i+1)=RT(:,:,i).'*omega_i_i(:,i)+s_dq(i)*[false;false;true]*(joint_type(i+1)); % calculates the angular velocity of link i relative to itself
        domega_i_i(:,i+1)=RT(:,:,i).'*domega_i_i(:,i)+(cross(RT(:,:,i).'*omega_i_i(:,i),s_dq(i)*[false;false;true]*(joint_type(i+1)))+s_ddq(i)*[false;false;true])*(joint_type(i+1)); % calculates the derivative of the angular velocity of link i relative to itself
        dvelocities_i_i(:,i+1)=RT(:,:,i).'*(  cross(domega_i_i(:,i),T(1:3,4,i))+   cross(omega_i_i(:,i),cross(omega_i_i(:,i),T(1:3,4,i)))  +dvelocities_i_i(:,i)  ) +(  2*cross(omega_i_i(:,i+1),s_dq(i)*[false;false;true])    +s_ddq(i)*[false;false;true]  )*(1-joint_type(i+1)); % calculates the derivative of Cartesian velocity of link i relative to itself
        F_i_i(:,i+1)=cross(domega_i_i(:,i+1),miPci(:,i+1))+   cross(omega_i_i(:,i+1),cross(omega_i_i(:,i+1),miPci(:,i+1)))  +m(i+1).*dvelocities_i_i(:,i+1);  % calculates the force applied to center of mass of link i respective to link i
    end
    fprintf(['\n Back Calculations Joint ' num2str(N)]);
    for i=N:-1:1
        fprintf([repmat('\b',1,ceil(log10(i+2))) num2str(i)]);
        f_i_i(:,i+1)=RT(:,:,i+1)*f_i_i(:,i+2)+F_i_i(:,i+1);
        n_i_i(:,i+1)= iIi(:,:,i+1)*domega_i_i(:,i+1)+  cross(omega_i_i(:,i+1),iIi(:,:,i+1)*omega_i_i(:,i+1)) + cross(miPci(:,i+1),dvelocities_i_i(:,i+1)) + RT(:,:,i+1)*n_i_i(:,i+2)  +  cross(T(1:3,4,i+1),RT(:,:,i+1)*f_i_i(:,i+2));
       
        if isequal(joint_type(i+1),1)
            tau_i(i)=n_i_i(:,i+1).'*[false;false;true];
        elseif isequal(joint_type(i+1),0)
            tau_i(i)=f_i_i(:,i+1).'*[false;false;true];
        end
    end
    fprintf('\n');
end