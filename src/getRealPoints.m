function [ real_points ] = getRealPoints( projection_matrix, image)
tic

disp('-- getRealPoints start --');

% On d�termine la taille des axes de l'image 
% Taille 1 --> axe Y ; taille 2 --> Axe X
size_X = size( image, 2);
size_Y = size( image, 1);

real_points = zeros( size_X*size_Y, 6);

% On utilise la matrice de projection pour obtenir les coordonn�es dans le
% rep�re monde � partir des coordon�es dans le rep�re image.

% A partir de chacun des points du rep�re image, on obtient 
% un vecteur r�el au format [ X Y 1 R G B ].

% On it�re sur le vecteur image(j,i,:) sur les j pour chaque i 

for i = 1:size_X
    
    offset = size_Y*(i-1);
    
    for j = 1:size_Y
    
    % a contient les coordonn�es dans le rep�re monde du point image courant
    a = projection_matrix\([i j 1]');
    a = a/a(3);
    a = a';
    
    real_points(offset+j,1) = a(1);
    real_points(offset+j,2) = a(2);
    real_points(offset+j,3) = a(3);
    
    % On inverse i et j pour �tre coh�rant avec les axes
    real_points(offset+j,4) = image(j,i,1);
    real_points(offset+j,5) = image(j,i,2);
    real_points(offset+j,6) = image(j,i,3);

    end
end

disp('-- getRealPoints end --');

toc
end

    
    
