load depths
load train

id = train.id;

keyset = {'Array','Name','Description'};

% Zarray = depths.z(id);
% Marray = depths.Mean(id);
% Sarray = depths.Std(id);
% Lm_array = depths.Lap_mean(id);
% Ls_array = depths.Lap_std(id);
% Earray = depths.Entropy(id);

% M_m_array = depths.Mask_mean(id);
% M_s_array = depths.Mask_std(id);
% M_lm_array = depths.Mask_lmean(id);
% M_ls_array = depths.Mask_lstd(id);
% p00array = depths.p00(id);
% p11array = depths.p11(id);

% mlog_array = log(M_m_array+1);
% slog_array = log(M_s_array+1);
% lmlog_array = log(M_lm_array+1);
% lslog_array = log(M_ls_array+1);
logp00_array = log(p00array+1);
logp11_array = log(p11array+1);

% Zstring = 'Depth';
% Mstring = 'Mean pixel value';
% Sstring = 'Standard deviation of pixel value';
% Lm_string = 'Mean pixel value of laplacian';
% Ls_string = 'Std pixel value of laplacian';
% Estring = 'Entropy';

% M_m_string = 'Mean of mask pixels';
% M_s_string = 'Std of mask pixels';
% M_lm_string = 'Mean of laplacian of mask';
% M_ls_string = 'Std of laplacian of mask';
% p00string = 'Probability 00';
% p11string = 'Probability 11';

% mlog_string = 'Log of mean of mask';
% slog_string = 'Log of std of mask';
% lmlog_string = 'Log of mean of laplacian';
% lslog_string = 'Log of std of laplacian';
logp00_string = 'LogProbability 00';
logp11_string = 'LogProbability 11';


% Z = containers.Map(keyset,{Zarray,"Z",Zstring});
% M = containers.Map(keyset,{Marray,"M",Mstring});
% S = containers.Map(keyset,{Sarray,"S",Sstring});
% Lm = containers.Map(keyset,{Lm_array,"Lm",Lm_string});
% Ls = containers.Map(keyset,{Ls_array,"Ls",Ls_string});
% E = containers.Map(keyset,{Earray,'E',Estring});

% M_m = containers.Map(keyset,{M_m_array,"Mm",M_m_string});
% M_s = containers.Map(keyset,{M_s_array,"Ms",M_s_string});
% M_lm = containers.Map(keyset,{M_lm_array,"Mlm",M_lm_string});
% M_ls = containers.Map(keyset,{M_ls_array,"Mls",M_ls_string});
% P00 = containers.Map(keyset,{p00array,'P00',p00string});
% P11 = containers.Map(keyset,{p11array,'P11',p11string});

% mlog = containers.Map(keyset,{mlog_array,"mlog",mlog_string});
% slog = containers.Map(keyset,{slog_array,"slog",slog_string});
% lmlog = containers.Map(keyset,{lmlog_array,"lmlog",lmlog_string});
% lslog = containers.Map(keyset,{lslog_array,"lslog",lslog_string});
logP00 = containers.Map(keyset,{logp00_array,'logP00',logp00_string});
logP11 = containers.Map(keyset,{logp11_array,'logP11',logp11_string});

% save('Stats/Z.mat','Z');
% save('Stats/M.mat','M');
% save('Stats/S.mat','S');
% save('Stats/Lm.mat','Lm');
% save('Stats/Ls.mat','Ls');
% save('Stats\E.mat','E');

% save('Stats/M_m.mat','M_m');
% save('Stats/M_s.mat','M_s');
% save('Stats/M_lm.mat','M_lm');
% save('Stats/M_ls.mat','M_ls');
% save('Stats\P00.mat','P00');
% save('Stats\P11.mat','P11');

% save('Stats/mlog.mat','mlog');
% save('Stats/slog.mat','slog');
% save('Stats/lmlog.mat','lmlog');
% save('Stats/lslog.mat','lslog');
save('Stats\logP00.mat','logP00');
save('Stats\logP11.mat','logP11');


% H = cell(20,1);
% nameH = "Hb%d";
% descriptionH = "Hist bin %d";
% 
% for i=1:hist_bins
%    
%     H{i} = containers.Map(keyset,{depths.Hist(id,i),sprintf(nameH,i),sprintf(descriptionH,i)});
%     
% end

% save('Stats\H.mat','H');