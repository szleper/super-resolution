format long
warning('off','all')

% Vid�o � partir de laquelle on r�alise la superr�solution
video = VideoReader('video.mp4');

% Nombre d'images � extraire de la vid�o pour la SR
image_count = 5;

% Vecteur contenant les images pour la SR
images = zeros( video.height, video.width, 3, image_count);

% Remplissage du vecteur d'images � partir de la vid�o
for i = 1:image_count
    images(:,:,:,i) = readFrame(video);
end

images = uint8(images);
 
% Vecteur contenant tous les points r�els au format [ X Y 1 R G B ] 
real_points = [];

% Remplissage du vecteur 'real_points' � partir de chaque image
for i = 1:image_count
    % Calibrage pour l'image i
    projection_matrix = calib(images(:,:,:,i));
    % Obtention des points [ X Y 1 R G B ] pour l'image i 
    points = getRealPoints( projection_matrix, images(:,:,:,i));
    % Remplissage du vecteur 'real_points'
    real_points = [ real_points ; points ];
end

% On affiche la densit� r�partie sur 10*10 carr�s des points r�els
figure;
hist3( real_points(:,1:2));

% On construit une image superr�solue sur une zone particuli�re
image = createImage(real_points,8*40000,0,6,4,9);

% Affichage de l'image
figure;
imshow(image);



