%% Organise folders for partial MTL T2 (Ece, 2020)

clear all; clc;
mrdir='/mridata/cbu_ntad/';
megdir='/megdata/cbu/ntad/';
imgdir='/imaging/projects/cbu/ntad/MTL_partial_T2/';
mrmap='/imaging/projects/cbu/ntad/mr_list.txt'; % To be updated manually

addpath /imaging/projects/cbu/ntad/scripts/functions/

%% Create folder structure

cd(imgdir)
[mrsubs mrids mrses ]=textread(mrmap,'%s %s %s');

mkdir([imgdir '/BL/'])
mkdir([imgdir '/AF/'])

for s=1:length(mrsubs)
    ind=find(strcmp(mrsubs,mrsubs{s}));
    subses=mrses(ind);
    
    for ss=1:length(subses)
       if ~exist([imgdir subses{ss} '/' mrsubs{s} '/']) 
            mkdir([imgdir subses{ss} '/' mrsubs{s} '/']); % create subject folder
       end
    end  

end

%% Convert MPRAGE dicoms

cd(mrdir)
for s=1:length(mrsubs)
    ind=find(strcmp(mrsubs,mrsubs{s}));
    subses=mrses(ind);
    
    for ss=1:length(subses)
        
        disp(['Checking MR data: ' mrsubs{s} ' ---------------'])
        t1fol=[imgdir subses{ss} '/' mrsubs{s}];
        
        l=dir([mrdir mrids{s} '*']);folname=[mrdir l.name]; cd(folname)
        l=dir([folname '/20*']); folname=[l.folder '/' l.name '/']; cd(folname)
        l=dir([folname '*MPRAGE*_iso']);
        if length(l)>1
            folname=[l(end).folder '/' l(end).name '/'];
        else
            folname=[l.folder '/' l.name '/'];
        end
        cd(folname);l=dir(folname);
        filenames=[]; flen=[];
        for f=1:length(l); flen=[flen, length([l(f).folder '/' l(f).name])]; end
        ns=(ones(1,length(l)).*max(flen))-flen;
        for f=3:length(l)
            filenames=[filenames; [l(f).folder '/' l(f).name blanks(ns(f))]];
        end; clear f
        hdr=spm_dicom_headers(filenames,0);
        spm_dicom_convert(hdr,'all','flat','nii',t1fol); clear hdr filenames l folname
        disp(['Converted the MR'])
        cd(t1fol); l=dir([t1fol '/sMR*']); fname=l.name;
        nii=load_untouch_nii(fname);
        save_untouch_nii(nii,[t1fol '/T1.nii']);
        delete(fname)
    end
end

%% Convert MCI T2 dicoms

cd(mrdir)
for s=1:length(mrsubs)
    ind=find(strcmp(mrsubs,mrsubs{s}));
    subses=mrses(ind);
    
    for ss=1:length(subses)
        
        disp(['Checking MCI T2 data: ' mrsubs{s} ' ---------------'])
        t1fol=[imgdir subses{ss} '/' mrsubs{s}];
        
        l=dir([mrdir mrids{s} '*']);folname=[mrdir l.name]; cd(folname)
        l=dir([folname '/20*']); folname=[l.folder '/' l.name '/']; cd(folname)
        l=dir([folname '*cor_MCI*']);
        if ~isempty(l)
            folname=[l(end).folder '/' l(end).name '/'];
            cd(folname);l=dir(folname);
            filenames=[]; flen=[];
            for f=1:length(l); flen=[flen, length([l(f).folder '/' l(f).name])]; end
            ns=(ones(1,length(l)).*max(flen))-flen;
            for f=3:length(l)
                filenames=[filenames; [l(f).folder '/' l(f).name blanks(ns(f))]];
            end; clear f
            hdr=spm_dicom_headers(filenames,0);
            spm_dicom_convert(hdr,'all','flat','nii',t1fol); clear hdr filenames l folname
            disp(['Converted the MR'])
            cd(t1fol); l=dir([t1fol '/sMR*']); fname=l.name;
            nii=load_untouch_nii(fname);
            save_untouch_nii(nii,[t1fol '/T2_MTL.nii']);
            delete(fname)
        end    
    end
end
