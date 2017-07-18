function y=equalsymMatrix3(A,B)
    % this file does not work with empty matrices or matrices of higher
    % than three dimensions. 
    if isequal(size(A),size(B))
        y=false(size(A));
        for i=1:size(A,1)
            for j=1:size(A,2)
                for k=1:size(A,3)
                    y(i,j,k)= isequaln(A(i,j,k),B(i,j,k));
                end
            end
        end
    elseif (size(A,1)==1 && size(A,2)==1 && size(A,3)==1)
        y=false(size(B));
        for i=1:size(B,1)
            for j=1:size(B,2)
                for k=1:size(B,3)
                    y(i,j,k)= isequaln(A,B(i,j,k));
                end
            end
        end
    elseif (size(B,1)==1 && size(B,2)==1 && size(B,3)==1)
        y=false(size(A));
        for i=1:size(A,1)
            for j=1:size(A,2)
                for k=1:size(A,3)
                    y(i,j,k)= isequaln(A(i,j,k),B);
                end
            end
        end
    else
        display('tried to check the equality of matrices of different sizes');
    end
end   