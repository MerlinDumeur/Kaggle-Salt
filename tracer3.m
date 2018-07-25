function fig = tracer3(X,Y,Z,Colour,Xlabel,Ylabel,Zlabel,Colorlabel,taille,filename,options)
%TRACER3 Plots 3D scatterplot
%   

fig = figure('pos',[0 0 1920 1080]);

scatter3(X,Y,Z,taille,Colour,options);

xlabel(Xlabel);
ylabel(Ylabel);
zlabel(Zlabel);

hcb = colorbar;
title(hcb,Colorlabel)

if filename ~= ""
    
    Fpng = "CR/images/%s.png";
    Feps = "CR/images/%s.eps";
    saveas(fig,sprintf(Fpng,filename));
    saveas(fig,sprintf(Feps,filename));

end

