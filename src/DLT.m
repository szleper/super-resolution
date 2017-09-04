function A=DLT(X,Y)

% Algorithme Direct Linear Transformation.
%
% Réécriture du système sous la forme AX = 0. On calcule la matrice A.

A = [];

for i = 1:size(X,1)
        
        C = zeros(2,9);
        
        C(1,1:3) = 0;
        
        C(1,4:6) = -X(i,:);
                
        C(1,7:9) = Y(i,2)*X(i,:);

        C(2,1:3) = -X(i,:);
        
        C(2,4:6) = 0;
        
        C(2,7:9) = Y(i,1)*X(i,:);

        A = [A ; C];
end