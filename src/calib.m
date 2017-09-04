function [ projection_matrix ] = calib(image)

% Affichage de l'image
figure;
imshow(image); 

% Detection des points pertinents de la mire dans le repère image
[ image_points, board_size] = detectCheckerboardPoints(image);

% Affichage des points pertinents de la mire
hold on; 
plot( image_points(:,1), image_points(:,2), 'r.');

% Création des points dans le repère réel corespondant au points pertinents
% de la mire
x_length = board_size(1,2)-1;   % longeur la plus longue dans detectCheckerboardPoints()
y_length = board_size(1,1)-1;   % longeur la plus courte dans detectCheckerboardPoints()

real_points = [];

for i = 1:x_length
    for j = 1:y_length
        real_points = [ real_points ; i-1 j-1];  
    end
end

% Vecteur d'homogénisation à ajouter aux coordonées pour le calcul de la
% DLT.
homogenous_vect = ones( x_length*y_length, 1);

X = [real_points homogenous_vect];
Y = [image_points homogenous_vect];

% Calcul de la matrice de projection par la DLT + SVD
D = DLT(X,Y);

[U,S,V] = svd(D);

projection_matrix = V(:,end);

% On met la matrice de projection sous la forme correcte (3,3)
% et on la normalise
projection_matrix = reshape(projection_matrix,3,3)';
projection_matrix = projection_matrix/projection_matrix(3,3);

% On calcule l'erreur
Erreur = 0;

for i = 1:size(X,1)
    test_image = projection_matrix*(X(i,:)');
    test_image = test_image/test_image(3);
    Erreur = Erreur + norm(test_image'-Y(i,:));
end

Erreur = Erreur/size(X,1);

display(Erreur);

% Test avec 2 points et affichage
Ya = projection_matrix*([-1 -1 1]');
Ya=Ya/Ya(3);
plot(Ya(1),Ya(2),'ro');

Ya = projection_matrix*([-2 -1 1]');
Ya=Ya/Ya(3);
plot(Ya(1),Ya(2),'ro');