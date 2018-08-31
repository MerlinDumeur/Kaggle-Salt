load depths
load train

load Stats\Z
load Stats\M
load Stats\S
load Stats\E
load Stats\H

load Stats\Lm.mat
load Stats\Ls.mat

H_ids = 1:hist_bins;
s = size(H_ids);
X = [Z('Array') M('Array') S('Array') E('Array') Lm('Array') Ls('Array') zeros(4000,s(2))];

for i=1:s(2)
    
    X(:,i+6) = H{H_ids(i)}('Array');
    
end
