 % Function to compute the transformation matrix between link frames k and k-1 for k=2:(N+1); k=1 is the base frame
function T=symsComputeTransformation(alpha,a,d,theta,N)
    T=sym(false(4,4,N)); % Initializes the transformation array T, for any j as third dimension, T(:,:,j) give the transformation between frames j and j-1
    for k=2:(N+1) % Iterates to compute the consecutive transformations
        Cthetak=cos(theta(k));
        Calphakp=cos(alpha(k));
        Salphakp=sin(alpha(k));
        Sthetak=sin(theta(k));
        T(:,:,k-1)=[Cthetak , -Sthetak , false , a(k)
                  Sthetak*Calphakp, Cthetak*Calphakp, -Salphakp , -Salphakp*d(k)
                  Sthetak*Salphakp, Cthetak*Salphakp, Calphakp , Calphakp*d(k)
                  false , false , false, 1]; % Computes the Transformation matrix between k and k-1 using Denavit-Hartenberg parameters      
    end
end