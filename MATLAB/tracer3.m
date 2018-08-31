function fig = tracer3(X,Y,Z,Colour,taille,save,idx,options)
%TRACER3 Plots 3D scatterplot
%   

fig = figure('pos',[0 0 1920 1080]);

Xa = X('Array');
Ya = Y('Array');
Za = Z('Array');

Colourscheme = ['r.' 'g.' 'b.' 'y.' 'm.' 'c.' 'rx' 'gx' 'bx' 'yx' 'mx' 'cx'];

if max(idx) > 1
    
    hold on
    
    for i=1:max(idx)

        scatter3(Xa(idx==i),Ya(idx==i),Za(idx==i),Colourscheme(i));
        
    end
    
    hold off
    
else
    scatter3(Xa,Ya,Za,taille,Colour('Array'),options);
end

xlabel(X('Description'));
ylabel(Y('Description'));
zlabel(Z('Description'));

hcb = colorbar;
title(hcb,Colour('Description'))

F = "%s%s%s_%s";
filename = sprintf(F,X('Name'),Y('Name'),Z('Name'),Colour('Name'));

if save
    
    Fpng = "CR/images/%s.png";
    Feps = "CR/images/%s.eps";
    saveas(fig,sprintf(Fpng,filename));
    saveas(fig,sprintf(Feps,filename));

end

