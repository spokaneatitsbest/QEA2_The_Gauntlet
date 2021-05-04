function [x,y] = local2global(x_in,y_in,x_offset,y_offset,offset_angle,degree_mode)
    % local2global
    % Version 1.0, Written by Chris Sanchez on 26-April-2021
    % function for converting coordiantes in a local space into a global space
    % Inputs:
    %   x_in: series of x points to convert, can be one point or a n by 1 matrix
    %   y_in: series of y points to convert, can by one point or a n by 1 matrix
    %   x_offset: x offset of the local coordinate space
    %   y_offset: y offset of the local coordinate space
    %   offset_angle: angle offset of the local coordinate space (rotates clockwise)
    %   degree mode: what units was offset_angle? (must be "degrees" or "radians"), if not provided, program will assume input was in radians
    % Returns:
    %    x: converted x points, either as one point or an n by 1 matrix
    %    y: converted y points, either as one point or an n by 1 matrix
    
    %process input for degree_mode
    if nargin<6
        degree_mode = "radians";
    end
    if degree_mode == "degrees"
        offset_angle = deg2rad(offset_angle);
    end
    
    %check for incorrect x and y inputs
    warnings.x = 0; warnings.y = 0; %setup variables for error logging
    if (size(x_in,1) == 1) && (size(x_in,2) > 1)
        x_in = x_in';
        warnings.x = 1;
    end
    if (size(y_in,1) == 1) && (size(y_in,2) > 1)
        y_in = y_in';
        warnings.y = 1;
    end
    %display warnings
    if (warnings.x == 1) && (warnings.y == 1)
        warning("Incorrect Input Dimensions: x_in and y_in were 1 by n matrixes instead of n by 1. They have been transposed.")
    elseif (warnings.x == 1)
        warning("Incorrect Input Dimensions: x_in was a 1 by n matrix instead of n by 1. It has been transposed.")
    elseif (warnings.y == 1)
        warning("Incorrect Input Dimensions: y_in was a 1 by n matrix instead of n by 1. It has been transposed.")
    end
    %check for mismatched sizes
    if size(x_in,1)~=size(y_in,1)
        error("Dimension Mismatch: x_in and y_in are different sizes. Please check inputs and try again");
    end
    
    x = zeros(size(x_in,1),1); %setup output matrix
    y = x;
    
    Translation_Matrix = [1, 0, x_offset; 0, 1, y_offset; 0, 0, 1]; %setup translation matrix
    Rotation_Matrix = [cos(offset_angle),-sin(offset_angle),0; sin(offset_angle),cos(offset_angle), 0; 0,0,1]; %setup rotation matrix
    
    %do math
    for point = [1:size(x,1)]
        XY_Matrix = [x_in(point,1);y_in(point,1);1]; %put the X and Y points into a matrix
        R = Translation_Matrix*Rotation_Matrix*XY_Matrix; %do math
        x(point,1) = R(1); %store variables
        y(point,1) = R(2);
    end
end