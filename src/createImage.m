function [image] = createImage( real_points, pixel_total_size, start_x, end_x, start_y, end_y)
tic

% Construction de l'image super-r�solue, � partir de l'ensemble des points
% r�els [X Y 1 R G B] obtenus � partir des diff�rentes images. On r�alise
% une interpolation pour chacun des points de notre image super-r�solue.

disp('-- createImage start --');

% real_points est au format [X Y 1 R G B]
real_points = sortrows(real_points);

% On supprime du vecteur real_points les points � l'ext�rieur des limites
% de l'image que l'on veut construire.
to_delete = find(end_x < real_points(:,1) | real_points(:,1) < start_x);
real_points(to_delete,:) = []; 

to_delete = find(end_y < real_points(:,2) | real_points(:,2) < start_y);
real_points(to_delete,:) = []; 

% On calcule la longueur dans le monde r�el des cot�s de l'image
x_length = end_x - start_x;
y_length = end_y - start_y;

% On calcule le nombre de pixels en X et en Y
x_pixel_size = round(sqrt(pixel_total_size*x_length/y_length))+1
y_pixel_size = round(sqrt(pixel_total_size*y_length/x_length))+1

% Matrice de l'image
image = zeros(y_pixel_size,x_pixel_size,3);

x_factor = x_length/(x_pixel_size-1);
y_factor = y_length/(y_pixel_size-1);

for i = 1:x_pixel_size

    % On cherche � quels coordonn�es (x,y) dans le monde r�el corespond la
    % coordonn�e en pixel de l'image super-r�solue    
    pixel_x = (i-1)*x_factor + start_x;
    
    % On s�lectionne une tranche de points du vecteur real_points
    % centr�e autour de la coordonn�e x    
    [idx_min, idx_max] = findInSorted( real_points(:,1),[ pixel_x - x_factor , pixel_x + x_factor ]);
    
    % points au format [Y X 1 R G B]
    points = real_points(idx_min:idx_max,:);
    points = sortrows(points,2);
    
    for j = 1:y_pixel_size
        
        pixel_y = (j-1)*y_factor + start_y;

        % De m�me on r�duit la tranche de points du vecteur autour 
        % de la coordonn�es y                 
        [idx_min2, idx_max2] = findInSorted( points(:,2),[ pixel_y - y_factor , pixel_y + y_factor ]);

        RGB = interpolateRGB( points(idx_min2:idx_max2,:), pixel_x, pixel_y);
        
        image(j,i,1) = RGB(1);   % R
        image(j,i,2) = RGB(2);   % G
        image(j,i,3) = RGB(3);   % B

    end
end

image = uint8(image);

toc

disp('-- createImage end --');

end