function [RGB] = interpolateRGB( real_points, pixel_x, pixel_y)

% Nombre de points à partir desquels on réalise une inerpolation
nombre_de_points = size( real_points, 1);

closest_points = ones(nombre_de_points,2);    % Distance , Index

for i = 1:size(real_points,1)
    closest_points(i,1) = sqrt((real_points(i,1)-pixel_x)^2+(real_points(i,2)-pixel_y)^2);
    closest_points(i,2) = i;
end

meanRGB = zeros(1,3);
sum_distance = 0;

% On interpole les valeurs RGB du point (pixel_x,pixel_y) en pondérant avec
% un coefficiant 1/distance pour chaque point. Plus le point est proche
% plus il a d'importance.
for i = 1:nombre_de_points
    
    meanRGB(1,1) = meanRGB(1,1) + real_points(closest_points(i,2),4)/(closest_points(i,1));

    meanRGB(1,2) = meanRGB(1,2) + real_points(closest_points(i,2),5)/(closest_points(i,1));

    meanRGB(1,3) = meanRGB(1,3) + real_points(closest_points(i,2),6)/(closest_points(i,1));

    sum_distance = sum_distance+ 1/closest_points(i,1);
end

RGB =  meanRGB/sum_distance;

end

