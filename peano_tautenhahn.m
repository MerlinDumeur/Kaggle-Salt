
function path = peano_tautenhahn(dimension, orientation)
%PEANO- Modified peano curve to fit dimensions different to powers of 2
% Algorithm taken from http://lutanho.net/pic2html/draw_sfc.html
% Orientation 0 up 1 left 2 right 3 down right 4 up right

% disp(dimension);
% disp(orientation);


s = size(dimension);

ori1 = [3;0;0;1];
ori2 = [3;4;7;1];

p4 = [0 3 4; 1 2 5];

errormsg = "case not handled";

if s(1) > 1
    
    path = cell(9,1);
    for i=1:s(1)
        temp = peano_tautenhahn(dimension(i,:),orientation(i));
        path{i} = temp;
    end


elseif min(dimension) == 1
    
    if max(dimension) == 1
        
        path = 0;
    
    elseif dimension(1) == 1
       
        switch orientation
            
            case {0,4,7}
                path = 0:dimension(2)-1;
            case {2,5,6}
                path = dimension(2)-1:-1:0;
            
            
        end
        
    else
        
        switch orientation
            
            case {3,4,5}
                s = 0:dimension(1)-1;
                
            case {1,6,7}
                s = dimension(1)-1:-1:0;
        end
        
        path = s';
        
    end
    
elseif max(dimension) <= 3 && min(dimension) <=2
    
    switch dimension(1)
        
        case 2
            
            switch dimension(2)
                    
                case 2
                    
                    path = [0 3 ; 1 2];
            
                    switch orientation
                        
                        case 0
                        case 1
                            path = max(path(:))-rot90(path,3);
                        case 3
                            path = max(path(:))-rot90(path,1);
                        case 2
                            path = max(path(:))-rot90(path,2);
                        otherwise
                            error(errormsg);
                    end
                    
                case 3
                    switch orientation
                        case 1
                            path = [3 4 5; 2 1 0];
                        case 3
                            path = [0 1 2; 5 4 3];
                        case 4
                            path = p4;
                        case 5
                            path = rot90(p4,1)';
                        case 6
                            path = rot90(p4,2);
                        case 7
                            path = rot90(p4,3)';
                    end
            end

        case 3 
            
            switch dimension(2)
 
                case 2
                    switch orientation
                        case 0
                            path = [0 5 ; 1 4 ; 2 3];
                        case 2
                            path = [3 2 ; 4 1 ; 5 0];
                        case 4
                            path = p4';
                        case 5
                            path = rot90(p4,3);
                        case 6
                            path = rot90(p4,2)';
                        case 7
                            path = rot90(p4,1);
                    end
            end
            
    end
    
elseif dimension(2) > 3/2*dimension(1) && ismember(orientation,[0 4])
    
        path = zeros(dimension);
        dimensions = repmat(dimension,2,1) ./ [1 2 ; 1 2];
        
        dimensionA = [0; 0];

        if mod(dimension(1),2) == 0

            switch mod(dimension(2),4)

                case 0
                    ori = [0 ; 0];

                case 2
                    ori = [4 ; 7];

                case 1
                    dimensionA = [0 -1/2 ; 0 1/2];
                    ori = [0 ; 4];
                    
                case 3
                    dimensionA = [0 1/2 ; 0 -1/2];
                    ori = [0;4];

            end

        else
            
            if orientation == 0
                ori = [0;0];
                

            elseif orientation == 4
                ori = [0;4];

            else
                error(errormsg);

            end

            if mod(dimension(2),4) == 3
                dimensionA = [0 1/2 ; 0 -1/2];

            elseif mod(dimension(2),4) == 1
                dimensionA = [0 -1/2 ; 0 1/2];

            end

          dimensions = dimensions + dimensionA;
          dimensions = double(uint8(dimensions));
          
          paths = peano_tautenhahn(dimensions,ori);
          
          path(:,1:dimensions(1,2)) = paths{1};
          path(:,dimensions(1,2)+1:end) = paths{2}+max(path(:))+1;
          
        end
elseif dimension(2) > 3/2*dimension(1) && ismember(orientation,[0 4])
    
    switch orientation
        case 4
            temp = peano_tautenhahn(fliplr(dimension),orientation);
            path = fliplr(rot90(temp,3));        
        case 6
            
            temp = peano_tautenhahn(dimension,4);
            path = rot90(temp,2);
            
    end
    
    
else
    switch orientation

        case 0
            
            mod1 = mod(dimension(1),4);
            mod2 = mod(dimension(2),4);
            
            m1 = [1 0 ; 0 1 ; 0 1 ; 1 0];
            m2 = [1 0 ; 1 0 ; 0 1 ; 0 1];

            dimensionOF = [[0 0] ; [-1/2 1/2] ; [0 0] ; [1/2 -1/2]];
            
            d1 = dimensionOF(mod1+1,:);
            d2 = dimensionOF(mod2+1,:);
            
            oriS = [1 2 2 2 ; 1 2 1 2 ; 2 2 2 2 ; 1 2 1 2];
            oriM = [ori1 ori2];
            oris = oriS(mod1+1,mod2+1);            
            ori = oriM(:,oris);
            
            if ismember(mod1,[1 3]) && dimension(2) == 2
               
                d2 = [0 0];
                ori = ori2;
                
            end

            r1 = m1*d1';
            r2 = m2*d2';

            dimensions = repmat(dimension,4,1) / 2 + [r1 r2];

            path1 = peano_tautenhahn(dimensions(1,:),ori(1));
            path2 = peano_tautenhahn(dimensions(2,:),ori(2));
            path3 = peano_tautenhahn(dimensions(3,:),ori(3));
            path4 = peano_tautenhahn(dimensions(4,:),ori(4));
            
            
            path = zeros(dimension);

            d11 = dimensions(1,1);
            d12 = dimensions(1,2);
            
            path(1:d11,1:d12) = path1;
            path(d11+1:end,1:d12) = path2+max(path(:))+1;
            path(d11+1:end,d12+1:end) = path3+max(path(:))+1;
            path(1:d11,d12+1:end) = path4+max(path(:))+1;

        case {1,3}

                temp = peano_tautenhahn(fliplr(dimension),0);
                path = max(temp(:))-rot90(temp,orientation+2);
                
        case 4

            dimensions = repmat(dimension,9,1) / 3;
            ori = [4 7 4 5 6 5 4 7 4]';

            dimensionOF = [[-1 2 -1] ; [2/3 -4/3 2/3] ; [1/3 -2/3 1/3] ; [0 0 0] ; [-1/3 2/3 -1/3] ; [-2/3 4/3 -2/3]];

            d1 = dimensionOF(mod(dimension(1),6)+1,:);
            d2 = dimensionOF(mod(dimension(2),6)+1,:);
            
            r1 = repmat(d1',1,3)';
            r1 = r1(:);
            
            r2 = repmat(d2',3,1);
            
            dimensions = dimensions + [r1 r2];
            dimensions = double(uint8(dimensions));
            
            path = zeros(dimension);
            paths = peano_tautenhahn(dimensions,ori);
            
            a = dimensions(1,1);
            b = dimensions(4,1);
            
            alpha = dimensions(1,2);
            beta  = dimensions(2,2);
            
            if dimension(2) >= dimension(1)

                path(1:a,1:alpha) = paths {1};
                path(a+1:a+b,1:alpha) = paths{4}+max(path(:))+1;
                path(a+b+1:end,1:alpha) = paths{7} + max(path(:)) + 1;
                path(a+b+1:end,alpha+1:alpha+beta) = paths{8} + max(path(:)) + 1;
                path(a+1:a+b,alpha+1:alpha+beta) = paths{5} + max(path(:)) + 1;
                path(1:a,alpha+1:alpha+beta) = paths{2} + max(path(:)) + 1;
                path(1:a,alpha+beta+1:end) = paths{3} + max(path(:)) + 1;
                path(a+1:a+b,alpha+beta+1:end) = paths{6} + max(path(:)) + 1;
                path(a+b+1:end,alpha+beta+1:end) = paths{9} + max(path(:)) + 1;

            else

                path(1:a,1:alpha) = paths{1};
                path(1:a,alpha+1:alpha+beta) = paths{2} + max(path(:)) + 1;
                path(1:a,alpha+beta+1:end) = paths{3} + max(path(:)) + 1;
                path(a+1:a+b,alpha+beta+1:end) = paths{6} + max(path(:)) + 1;
                path(a+1:a+b,alpha+1:alpha+beta) = paths{5} + max(path(:)) + 1;
                path(a+1:a+b,1:alpha) = paths{4}+max(path(:))+1;
                path(a+b+1:end,1:alpha) = paths{7} + max(path(:)) + 1;
                path(a+b+1:end,alpha+1:alpha+beta) = paths{8} + max(path(:)) + 1;
                path(a+b+1:end,alpha+beta+1:end) = paths{9} + max(path(:)) + 1;
    
            end
            
        case {5,6,7}
            
              if mod(orientation,2) == 0
                  
                  path = turn(peano_tautenhahn(dimension,4),orientation-4);
                  
              else
                 
                  path = turn(peano_tautenhahn(fliplr(dimension),4),orientation-4);
                  
              end
    end
end

end

function newpath = turn(path,delta)

    switch mod(delta,4)
        
        case 0
            newpath = path;
            
        case 1
            newpath = rot90(path,3);
            
        case 2
            newpath = rot90(path,2);
            
        case 3
            newpath = rot90(path,1);
            
    end
end
