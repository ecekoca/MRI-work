%% Hippocampal subfield volumetry (Ece K, 2021)

clear all; clc;
indir='/imaging/projects/cbu/ntad/MTL_partial_T2/BL/';
subfol='final';
outdir='/imaging/ek01/ntad/hip_subfields/';
areas={'CA1','CA2','DG','CA3','misc','SUB','ERC','BA35','BA36','PHC','sulcus'};

exclude={'cc410392','cc420163','cc520407','cc520785','cc620434','cc720115','cc720319','P1009','P1012',...
    'P1029','P1030','P1036','P1037','P3002','P3005','pp113615','pp137551','pp141038','pp142409'}; % list of subjects to exclude based on motion artefacts
maybe_exclude={'C1002','C1006','cc610563','cc620266','cc620533','cc710345','cc720819','P1016','P1020',...
    'P1042','P1055','pp126264','pp128346','pp136072','pp175738'}; %more mild artefacts

cog_fname='/imaging/ek01/ntad/hip_subfields/cog_data.mat'; % remaining subject data, variables


%% Gather data

mkdir(outdir);
cd(indir);
l=dir(indir);

k=1;
for s=3:length(l)
    folname=[indir l(s).name '/' subfol '/'];
    cd(folname);
    
    if exist([l(s).name '_icv.txt'])
        
        fname=[l(s).name '_icv.txt'];
        [id, var]=textread([folname fname],'%s %d','emptyvalue', NaN); % Intracranial volume
        subs{k,1}=id{1,1}; %Study IDs
        ICV(k,1)=var;
        
        fname=[l(s).name '_left_corr_usegray_volumes.txt'];
        [id, var, var2, var3, var4]=textread([folname fname],'%s %s %s %d %f','emptyvalue', NaN); % Volumes on the left
        for ar=1:length(areas)
            z=find(ismember(var2,areas{ar}));
            if ~isempty(z)
                L_corr_vol(k,ar)=var4(z);
            else
                L_corr_vol(k,ar)=NaN;
            end
        end
        
        fname=[l(s).name '_left_heur_volumes.txt'];
        [id, var, var2, var3, var4]=textread([folname fname],'%s %s %s %d %f','emptyvalue', NaN);
        for ar=1:length(areas)
            z=find(ismember(var2,areas{ar}));
            if ~isempty(z)
                L_heur_vol(k,ar)=var4(z);
            else
                L_heur_vol(k,ar)=NaN;
            end
        end
        
        fname=[l(s).name '_left_raw_volumes.txt'];
        [id, var, var2, var3, var4]=textread([folname fname],'%s %s %s %d %f','emptyvalue', NaN);
        for ar=1:length(areas)
            z=find(ismember(var2,areas{ar}));
            if ~isempty(z)
                L_raw_vol(k,ar)=var4(z);
            else
                L_raw_vol(k,ar)=NaN;
            end
        end
        
        fname=[l(s).name '_right_corr_usegray_volumes.txt'];
        [id, var, var2, var3, var4]=textread([folname fname],'%s %s %s %d %f','emptyvalue', NaN); % Volumes on the right
        for ar=1:length(areas)
            z=find(ismember(var2,areas{ar}));
            if ~isempty(z)
                R_corr_vol(k,ar)=var4(z);
            else
                R_corr_vol(k,ar)=NaN;
            end
        end
        
        fname=[l(s).name '_right_heur_volumes.txt'];
        [id, var, var2, var3, var4]=textread([folname fname],'%s %s %s %d %f','emptyvalue', NaN);
        for ar=1:length(areas)
            z=find(ismember(var2,areas{ar}));
            if ~isempty(z)
                R_heur_vol(k,ar)=var4(z);
            else
                R_heur_vol(k,ar)=NaN;
            end
        end
        
        fname=[l(s).name '_right_raw_volumes.txt'];
        [id, var, var2, var3, var4]=textread([folname fname],'%s %s %s %d %f','emptyvalue', NaN);
        for ar=1:length(areas)
            z=find(ismember(var2,areas{ar}));
            if ~isempty(z)
                R_raw_vol(k,ar)=var4(z);
            else
                R_raw_vol(k,ar)=NaN;
            end
        end
        
        k=k+1;
    end
end

tbl=table(subs,L_corr_vol(:,1),L_corr_vol(:,2),L_corr_vol(:,3),L_corr_vol(:,4),L_corr_vol(:,5),...
    L_corr_vol(:,6),L_corr_vol(:,7),L_corr_vol(:,8),L_corr_vol(:,9),L_corr_vol(:,10),L_corr_vol(:,11),ICV,...
    'VariableNames',{'SUBS','CA1','CA2','DG','CA3','MISC','SUB','ERC','BA35','BA36','PHC','SULCUS','ICV'}); disp(tbl)
save([outdir '/L_corr_usegray_volumes_NTAD_CAMCAN_table.mat'],'tbl');

tbl=table(subs,R_corr_vol(:,1),R_corr_vol(:,2),R_corr_vol(:,3),R_corr_vol(:,4),R_corr_vol(:,5),...
    R_corr_vol(:,6),R_corr_vol(:,7),R_corr_vol(:,8),R_corr_vol(:,9),R_corr_vol(:,10),R_corr_vol(:,11),ICV,...
    'VariableNames',{'SUBS','CA1','CA2','DG','CA3','MISC','SUB','ERC','BA35','BA36','PHC','SULCUS','ICV'}); disp(tbl)
save([outdir '/R_corr_usegray_volumes_NTAD_CAMCAN_table.mat'],'tbl');

tbl=table(subs,L_heur_vol(:,1),L_heur_vol(:,2),L_heur_vol(:,3),L_heur_vol(:,4),L_heur_vol(:,5),...
    L_heur_vol(:,6),L_heur_vol(:,7),L_heur_vol(:,8),L_heur_vol(:,9),L_heur_vol(:,10),L_heur_vol(:,11),ICV,...
    'VariableNames',{'SUBS','CA1','CA2','DG','CA3','MISC','SUB','ERC','BA35','BA36','PHC','SULCUS','ICV'}); disp(tbl)
save([outdir '/L_heur_volumes_NTAD_CAMCAN_table.mat'],'tbl');

tbl=table(subs,R_heur_vol(:,1),R_heur_vol(:,2),R_heur_vol(:,3),R_heur_vol(:,4),R_heur_vol(:,5),...
    R_heur_vol(:,6),R_heur_vol(:,7),R_heur_vol(:,8),R_heur_vol(:,9),R_heur_vol(:,10),R_heur_vol(:,11),...
    'VariableNames',{'SUBS','CA1','CA2','DG','CA3','MISC','SUB','ERC','BA35','BA36','PHC','SULCUS'}); disp(tbl)
save([outdir '/R_heur_volumes_NTAD_CAMCAN_table.mat'],'tbl');

tbl=table(subs,L_raw_vol(:,1),L_raw_vol(:,2),L_raw_vol(:,3),L_raw_vol(:,4),L_raw_vol(:,5),...
    L_raw_vol(:,6),L_raw_vol(:,7),L_raw_vol(:,8),L_raw_vol(:,9),L_raw_vol(:,10),L_raw_vol(:,11),ICV,...
    'VariableNames',{'SUBS','CA1','CA2','DG','CA3','MISC','SUB','ERC','BA35','BA36','PHC','SULCUS','ICV'}); disp(tbl)
save([outdir '/L_raw_volumes_NTAD_CAMCAN_table.mat'],'tbl');

tbl=table(subs,R_raw_vol(:,1),R_raw_vol(:,2),R_raw_vol(:,3),R_raw_vol(:,4),R_raw_vol(:,5),...
    R_raw_vol(:,6),R_raw_vol(:,7),R_raw_vol(:,8),R_raw_vol(:,9),R_raw_vol(:,10),R_raw_vol(:,11),ICV,...
    'VariableNames',{'SUBS','CA1','CA2','DG','CA3','MISC','SUB','ERC','BA35','BA36','PHC','SULCUS','ICV'}); disp(tbl)
save([outdir '/R_raw_volumes_NTAD_CAMCAN_table.mat'],'tbl');

%% Tidy up & exclude

load(cog_fname); %T
cog_data=T; 

load([outdir '/L_corr_usegray_volumes_NTAD_CAMCAN_table.mat'])
l_hem_data=tbl;

load([outdir '/R_corr_usegray_volumes_NTAD_CAMCAN_table.mat'])
r_hem_data=tbl;

exclude=[exclude T.subs(intersect(find(strcmp(T.group,'C')),find(strcmp(T.biomarker,'positive'))))]; % exclude positive controls
exclude=[exclude T.subs(intersect(find(strcmp(T.group,'MCI')),find(strcmp(T.biomarker,'negative'))))']; % exclude negative MCI
exclude=[exclude T.subs(intersect(find(strcmp(T.group,'AD')),find(strcmp(T.biomarker,'negative'))))']; % exclude negative AD
exclude=[exclude T.subs(intersect(find(strcmp(T.group,'MCI')),find(strcmp(T.biomarker,'unknown'))))']; % exclude negative MCI
exclude=[exclude T.subs(intersect(find(strcmp(T.group,'AD')),find(strcmp(T.biomarker,'unknown'))))']; % exclude negative AD
exclude=unique(exclude);

l_hem_data(find(ismember(l_hem_data.SUBS,exclude)),:)=[];
r_hem_data(find(ismember(r_hem_data.SUBS,exclude)),:)=[];
cog_data=cog_data(find(ismember(cog_data.subs,r_hem_data.SUBS)),:); 
cog_data=sortrows(cog_data,1,'ascend');l_hem_data=sortrows(l_hem_data,1,'ascend');r_hem_data=sortrows(r_hem_data,1,'ascend');

%% Correct for covariates

k=1;
for f=2:12
    mdl = fitlm([cog_data.age, l_hem_data.ICV], l_hem_data{:,f});
    l_hem_res(:,k)=mat2gray(mdl.Residuals.Raw); 
    
    mdl = fitlm([cog_data.age, r_hem_data.ICV], r_hem_data{:,f});
    r_hem_res(:,k)=mat2gray(mdl.Residuals.Raw); k=k+1;
end

%% Boxplots

fields=l_hem_data.Properties.VariableNames(2:end);fields(end)=[];

c_ind=find(strcmp(cog_data.group,'C'));
f_ind=find(strcmp(cog_data.group,'F'));
mci_ind=find(strcmp(cog_data.group,'MCI'));
ad_ind=find(strcmp(cog_data.group,'AD'));

groups = [0.1*ones(size(c_ind)); 0.4*ones(size(f_ind));0.7*ones(size(mci_ind)); 1*ones(size(ad_ind))];

for f=1:size(l_hem_res,2)
    
    figure('color','w'); set(gca,'FontSize',14,'Color','w')
    H=notBoxPlot([l_hem_res(c_ind,f); l_hem_res(f_ind,f); l_hem_res(mci_ind,f); l_hem_res(ad_ind,f)],...
        groups,'jitter',0.2,'style','sdline') 
    set([H([1:4]).data],'MarkerSize',8,'markerFaceColor','none','markerEdgeColor', 'none')
    set([H(1).semPtch],'FaceColor',[63 14 137]./255,'EdgeColor',[63 14 137]./255,'LineWidth',3)
    set([H(2).semPtch],'FaceColor',[0 192 163]./255,'EdgeColor',[0 192 163]./255,'LineWidth',3)
    set([H(3).semPtch],'FaceColor',[243 255 0]./255,'EdgeColor',[243 255 0]./255,'LineWidth',3)
    set([H(4).semPtch],'FaceColor',[150 150 150]./255,'EdgeColor',[150 150 150]./255,'LineWidth',3)
    set([H(1:4).mu],'Color','w','LineWidth',3);
    set([H(1:4).sd],'Color',[150 150 150]./255,'LineWidth',3);
    set(gca, 'XtickLabel', {'C','F','MCI','AD'})
    title(fields{f}); ylim([0 1]); 
    print(gcf,[outdir 'LH_' fields{f} '_boxplots.bmp'],'-dbmp','-r300'); close(gcf)
    
    figure('color','w'); set(gca,'FontSize',14,'Color','w')
    H=notBoxPlot([r_hem_res(c_ind,f); r_hem_res(f_ind,f); r_hem_res(mci_ind,f); r_hem_res(ad_ind,f)],...
        groups,'jitter',0.2,'style','sdline') 
    set([H([1:4]).data],'MarkerSize',8,'markerFaceColor','none','markerEdgeColor', 'none')
    set([H(1).semPtch],'FaceColor',[63 14 137]./255,'EdgeColor',[63 14 137]./255,'LineWidth',3)
    set([H(2).semPtch],'FaceColor',[0 192 163]./255,'EdgeColor',[0 192 163]./255,'LineWidth',3)
    set([H(3).semPtch],'FaceColor',[243 255 0]./255,'EdgeColor',[243 255 0]./255,'LineWidth',3)
    set([H(4).semPtch],'FaceColor',[150 150 150]./255,'EdgeColor',[150 150 150]./255,'LineWidth',3)
    set([H(1:4).mu],'Color','w','LineWidth',3);
    set([H(1:4).sd],'Color',[150 150 150]./255,'LineWidth',3);
    set(gca, 'XtickLabel', {'C','F','MCI','AD'})
    title(fields{f}); ylim([0 1]); 
    print(gcf,[outdir 'RH_' fields{f} '_boxplots.bmp'],'-dbmp','-r300');close(gcf)
    
end

figure('color','w'); set(gca,'FontSize',14,'Color','w')
H=notBoxPlot([r_hem_data.ICV(c_ind); r_hem_data.ICV(f_ind); r_hem_data.ICV(mci_ind); r_hem_data.ICV(ad_ind)],...
    groups,'jitter',0.2,'style','sdline')
set([H([1:4]).data],'MarkerSize',8,'markerFaceColor','none','markerEdgeColor', 'none')
set([H(1).semPtch],'FaceColor',[63 14 137]./255,'EdgeColor',[63 14 137]./255,'LineWidth',3)
set([H(2).semPtch],'FaceColor',[0 192 163]./255,'EdgeColor',[0 192 163]./255,'LineWidth',3)
set([H(3).semPtch],'FaceColor',[243 255 0]./255,'EdgeColor',[243 255 0]./255,'LineWidth',3)
set([H(4).semPtch],'FaceColor',[150 150 150]./255,'EdgeColor',[150 150 150]./255,'LineWidth',3)
set([H(1:4).mu],'Color','w','LineWidth',3);
set([H(1:4).sd],'Color',[150 150 150]./255,'LineWidth',3);
set(gca, 'XtickLabel', {'C','F','MCI','AD'})
title('ICV'); %ylim([0 1]);
print(gcf,[outdir 'ICV_boxplots.bmp'],'-dbmp','-r300');close(gcf)

c_f_ind=intersect(find(strcmp(cog_data.group,'C')),find(cog_data.sex==1));
f_f_ind=intersect(find(strcmp(cog_data.group,'F')),find(cog_data.sex==1));
mci_f_ind=intersect(find(strcmp(cog_data.group,'MCI')),find(cog_data.sex==1));
ad_f_ind=intersect(find(strcmp(cog_data.group,'AD')),find(cog_data.sex==1));
groups_f = [0.1*ones(size(c_f_ind)); 0.4*ones(size(f_f_ind));0.7*ones(size(mci_f_ind)); 1*ones(size(ad_f_ind))];

figure('color','w'); set(gca,'FontSize',14,'Color','w')
H=notBoxPlot([r_hem_data.ICV(c_f_ind); r_hem_data.ICV(f_f_ind); r_hem_data.ICV(mci_f_ind); r_hem_data.ICV(ad_f_ind)],...
    groups_f,'jitter',0.2,'style','sdline')
set([H([1:4]).data],'MarkerSize',8,'markerFaceColor','none','markerEdgeColor', 'none')
set([H(1).semPtch],'FaceColor',[63 14 137]./255,'EdgeColor',[63 14 137]./255,'LineWidth',3)
set([H(2).semPtch],'FaceColor',[0 192 163]./255,'EdgeColor',[0 192 163]./255,'LineWidth',3)
set([H(3).semPtch],'FaceColor',[243 255 0]./255,'EdgeColor',[243 255 0]./255,'LineWidth',3)
set([H(4).semPtch],'FaceColor',[150 150 150]./255,'EdgeColor',[150 150 150]./255,'LineWidth',3)
set([H(1:4).mu],'Color','w','LineWidth',3);
set([H(1:4).sd],'Color',[150 150 150]./255,'LineWidth',3);
set(gca, 'XtickLabel', {'C','F','MCI','AD'})
title('ICV in women'); %ylim([0 1]);
print(gcf,[outdir 'ICV_women_boxplots.bmp'],'-dbmp','-r300');close(gcf)

c_m_ind=intersect(find(strcmp(cog_data.group,'C')),find(cog_data.sex==0));
f_m_ind=intersect(find(strcmp(cog_data.group,'F')),find(cog_data.sex==0));
mci_m_ind=intersect(find(strcmp(cog_data.group,'MCI')),find(cog_data.sex==0));
ad_m_ind=intersect(find(strcmp(cog_data.group,'AD')),find(cog_data.sex==0));
groups_m = [0.1*ones(size(c_m_ind)); 0.4*ones(size(f_m_ind));0.7*ones(size(mci_m_ind)); 1*ones(size(ad_m_ind))];

figure('color','w'); set(gca,'FontSize',14,'Color','w')
H=notBoxPlot([r_hem_data.ICV(c_m_ind); r_hem_data.ICV(f_m_ind); r_hem_data.ICV(mci_m_ind); r_hem_data.ICV(ad_m_ind)],...
    groups_m,'jitter',0.2,'style','sdline')
set([H([1:4]).data],'MarkerSize',8,'markerFaceColor','none','markerEdgeColor', 'none')
set([H(1).semPtch],'FaceColor',[63 14 137]./255,'EdgeColor',[63 14 137]./255,'LineWidth',3)
set([H(2).semPtch],'FaceColor',[0 192 163]./255,'EdgeColor',[0 192 163]./255,'LineWidth',3)
set([H(3).semPtch],'FaceColor',[243 255 0]./255,'EdgeColor',[243 255 0]./255,'LineWidth',3)
set([H(4).semPtch],'FaceColor',[150 150 150]./255,'EdgeColor',[150 150 150]./255,'LineWidth',3)
set([H(1:4).mu],'Color','w','LineWidth',3);
set([H(1:4).sd],'Color',[150 150 150]./255,'LineWidth',3);
set(gca, 'XtickLabel', {'C','F','MCI','AD'})
title('ICV in men'); %ylim([0 1]);
print(gcf,[outdir 'ICV_men_boxplots.bmp'],'-dbmp','-r300');close(gcf)

figure('color','w'); set(gca,'FontSize',14,'Color','w')
H=notBoxPlot([cog_data.age(c_ind); cog_data.age(f_ind); cog_data.age(mci_ind); cog_data.age(ad_ind)],...
    groups,'jitter',0.2,'style','sdline')
set([H([1:4]).data],'MarkerSize',8,'markerFaceColor','none','markerEdgeColor', 'none')
set([H(1).semPtch],'FaceColor',[63 14 137]./255,'EdgeColor',[63 14 137]./255,'LineWidth',3)
set([H(2).semPtch],'FaceColor',[0 192 163]./255,'EdgeColor',[0 192 163]./255,'LineWidth',3)
set([H(3).semPtch],'FaceColor',[243 255 0]./255,'EdgeColor',[243 255 0]./255,'LineWidth',3)
set([H(4).semPtch],'FaceColor',[150 150 150]./255,'EdgeColor',[150 150 150]./255,'LineWidth',3)
set([H(1:4).mu],'Color','w','LineWidth',3);
set([H(1:4).sd],'Color',[150 150 150]./255,'LineWidth',3);
set(gca, 'XtickLabel', {'C','F','MCI','AD'})
title('Age'); %ylim([0 1]);
print(gcf,[outdir 'Age_boxplots.bmp'],'-dbmp','-r300');close(gcf)

%% Test

load(cog_fname)

[p tbl stats]=anovan(ento,{group,tiv,age},'Continuous',[2 3],'varnames',{'Group','TIV','Age'}) % ANCOVA
multcompare(stats)
