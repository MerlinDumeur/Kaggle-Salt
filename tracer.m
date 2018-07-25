function [fig] = tracer(X,Y,Colour,Xlabel,Ylabel,Colorlabel,taille,filename,options)
%TRACER Plots 
%   

fig = figure('pos',[0 0 1920 1080]);

scatter(X,Y,taille,Colour,options);

xlabel(Xlabel);
ylabel(Ylabel);

hcb = colorbar;
title(hcb,Colorlabel)

if filename ~= ""
    
    Fpng = "CR/images/%s.png";
    Feps = "CR/images/%s.eps";
    saveas(fig,sprintf(Fpng,filename));
    saveas(fig,sprintf(Feps,filename));

end

