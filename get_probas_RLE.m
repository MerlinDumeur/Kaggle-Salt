function A = get_probas_RLE(RLE)
%GET_PROBAS_RLE Returns transition probas from RLE
%   

s1 = 0;
s0 = 0;

location = 1;

for i = 1:2:length(RLE)
   
    s1 = s1 + RLE(i+1);
    s0 = s0 + RLE(i)-location;
    location = RLE(i) + RLE(i+1);
    
end

if RLE(1) == 1
    
    s01 = (length(RLE)-2)/2;

else
    
    s01 = length(RLE)/2;
    
end

if RLE(end-1) + RLE(end) == 10201
     
     s10 = (length(RLE)-2)/2;
     
else

    s10 = length(RLE)/2;
    
p01 = s01/s0;
p10 = s10/s1;
    
A = [(1-p01) p01
     p10     (1-p10)];
    
end

% if RLE(1) == 1
%    
%     offset = 2;
%     s11 = RLE(2);
%     s00 = RLE(3)-RLE(2);
%     location = RLE(3);
%     
% end

