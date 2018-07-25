load depths
load train

id = train.id;

Z = depths.z(id);
M = depths.Mean(id);
S = depths.Std(id);

M_m = depths.Mask_mean(id);
M_s = depths.Mask_std(id);

mlog = log(M_m+1);
slog = log(M_s+1);

Zstring = 'Depth';
Mstring = 'Mean pixel value';
Sstring = 'Standard deviation of pixel value';

M_m_string = 'Mean of mask pixels';
M_s_string = 'Std of mask pixels';
mlog_string = 'Log of mean of mask';
slog_string = 'Log of std of mask';


color_scale = slog;
color_string = slog_string;

close all;

tracer3(M,S,Z,color_scale,Mstring,Sstring,Zstring,color_string,20,"MSZ_Ms",'filled');
tracer(M,S,color_scale,Mstring,Sstring,color_string,20,"MS_Ms",'filled');
tracer(Z,M,color_scale,Zstring,Mstring,color_string,20,"ZM_Ms",'filled');
tracer(Z,S,color_scale,Zstring,Sstring,color_string,20,"ZS_Ms",'filled');