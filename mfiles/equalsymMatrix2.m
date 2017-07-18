% equalsymMatrix2 checks equality of sym matrices    
% this file does not work with empty matrices or matrices of higher
% than two dimensions. you can later use size(size(.)) to expand this function for higher
% dimensions
function y=equalsymMatrix2(A,B)
    if isequal(size(A),size(B))
        y=false(size(A,1),size(A,2));
        for i=1:size(A,1)
            for j=1:size(A,2)
                y(i,j)= isequaln(A(i,j),B(i,j));
            end
        end
    elseif (size(A,1)==1 && size(A,2)==1)
        y=false(size(B,1),size(B,2));
        for i=1:size(B,1)
            for j=1:size(B,2)
                y(i,j)= isequaln(A,B(i,j));
            end
        end
    elseif (size(B,1)==1 && size(B,2)==1)
        y=false(size(A,1),size(A,2));
        for i=1:size(A,1)
            for j=1:size(A,2)
                y(i,j)= isequaln(A(i,j),B);
            end
        end
    else
        display('tried to check equality of matrices of different sizes.');
    end
end   