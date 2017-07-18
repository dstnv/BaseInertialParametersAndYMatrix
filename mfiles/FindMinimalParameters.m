% FindMinimalParameters finds the minimal inertial parameters of the manipulator
% Note: function is not extended for robots with translational joints.
function [mMIP,miPciMIP,iIiMIP]=FindMinimalParameters(m,miPci,iIi,alpha,a,d,N)
    mMIP=m;
    miPciMIP=miPci;
    iIiMIP=iIi;
     for i=N:-1:2
        Salpha=sin(alpha(i+1));
        Calpha=cos(alpha(i+1));

        iIiMIP(1,1,i)=iIiMIP(1,1,i)+iIiMIP(2,2,i+1)+2*d(i+1)*miPciMIP(3,i+1)+d(i+1)^2*mMIP(i+1,1);
        iIiMIP(1,2,i)=iIiMIP(1,2,i)+a(i+1)*Salpha*miPciMIP(3,i+1)+a(i+1)*d(i+1)*Salpha*mMIP(i+1,1);
        iIiMIP(2,1,i)=iIiMIP(1,2,i);
        iIiMIP(1,3,i)=iIiMIP(1,3,i)-a(i+1)*Calpha*miPciMIP(3,i+1)-a(i+1)*d(i+1)*Calpha*mMIP(i+1,1);
        iIiMIP(3,1,i)=iIiMIP(1,3,i);
        iIiMIP(2,2,i)=iIiMIP(2,2,i)+Calpha^2*iIiMIP(2,2,i+1)+2*d(i+1)*Calpha^2*miPciMIP(3,i+1)+(a(i+1)^2+d(i+1)^2*Calpha^2)*mMIP(i+1,1);
        iIiMIP(2,3,i)=iIiMIP(2,3,i)+Calpha*Salpha*iIiMIP(2,2,i+1)+2*d(i+1)*Calpha*Salpha*miPciMIP(3,i+1)+d(i+1)^2*Calpha*Salpha*mMIP(i+1,1);
        iIiMIP(3,2,i)=iIiMIP(2,3,i);
        iIiMIP(3,3,i)=iIiMIP(3,3,i)+Salpha^2*iIiMIP(2,2,i+1)+2*d(i+1)*Salpha^2*miPciMIP(3,i+1)+(a(i+1)^2+d(i+1)^2*Salpha^2)*mMIP(i+1,1);
        miPciMIP(1,i)=miPciMIP(1,i)+a(i+1)*mMIP(i+1,1);
        miPciMIP(2,i)=miPciMIP(2,i)-Salpha*miPciMIP(3,i+1)-d(i+1)*Salpha*mMIP(i+1,1);
        miPciMIP(3,i)=miPciMIP(3,i)+Calpha*miPciMIP(3,i+1)+d(i+1)*Calpha*mMIP(i+1,1);
        mMIP(i,1)=mMIP(i,1)+mMIP(i+1,1);
        
        iIiMIP(1,1,i+1)=iIiMIP(1,1,i+1)-iIiMIP(2,2,i+1);
        iIiMIP(2,2,i+1)=0;
        
        miPciMIP(3,i+1)=0;
        
        mMIP(i+1,1)=0;
    end
end