function [miPci,iIi]=ConvertTomiPci(m,iPci,ciIi,N) % Convert To m*iPci, find moment of inertia iIi at distance iPci from ciIi
    miPci=iPci*0;
    for i=2:N+1
        miPci(:,i)=iPci(:,i).*m(i,1);
    end
    iIi=ciIi*0;
    for i=2:N+1
        iIi(:,:,i)=ciIi(:,:,i)+m(i,1)*((iPci(:,i)'*iPci(:,i)).*eye(3,3)-iPci(:,i)*(iPci(:,i)'));
    end
end