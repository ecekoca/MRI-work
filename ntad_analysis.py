#NTAD analysis stats for MRI 

#Import necessary functions
#conda activate neuroconda_2_0
import os
from fsl.wrappers import fsl_anat, fslstats

# ?Read in files from text file
with open('/imaging/projects/cbu/ntad/analyses/FSL_output/all_files.txt','r') as f:
    T1s = f.readlines()

# Remove new-lines from file paths
T1s = [t1.strip('\n') for t1 in T1s]

# Define output directory
outputdir = '/imaging/projects/cbu/ntad/analyses/FSL_output/{runname}'
# save to home output dir if computer being slow
#%%
# Run fsl_anat
for ii in range(len(T1s)):
    if os.path.isfile(T1s[ii]) is False:
        print("filenotfound")
        continue
    runname = T1s[ii].split('/')[-1].split('.')[0]
    if os.path.isdir(outputdir.format(runname=runname)+".anat"):
         print("output exists")
         continue
    fsl_anat(T1s[ii], outputdir.format(runname=runname))
#%%
# Collate Stats

# Open output file
statsout = outputdir.format(runname='ntad_volstats.csv')
names = ('PPT_ID','TotalBrainVol','GreyMatterVol','GreyMatterVolNorm','WhiteMatterVol','WhiteMatterVolNorm','CSFVol','CSFVolNorm','HippoLVol','HippoLVolNorm','HippoRVol','HippoRVolNorm','HippoTotalVolNorm','AmygRVolNorm','AmygLVolNorm','ThalLVolNorm','ThalRVolNorm','CaudLVolNorm','CaudRVolNorm','PutaLVolNorm','PutaRVolNorm','PalliLVolNorm','PalliRVolNorm')
f = open(statsout,'w')
f.write(', '.join(names))
f.write('\n')

for ii in range(len(T1s)):

    runname = T1s[ii].split('/')[-1].split('.')[0]
    print(runname)
    fslanatdir = outputdir.format(runname=runname) + '.anat/{fname}'

    biascorr = 'T1_biascorr_brain.nii.gz'
    bc_out = fslstats(fslanatdir.format(fname=biascorr)).M.V.run()

    csf_file = 'T1_fast_pve_0.nii.gz'
    csf_out = fslstats(fslanatdir.format(fname=csf_file)).M.V.run()

    grey_file = 'T1_fast_pve_1.nii.gz'
    grey_out = fslstats(fslanatdir.format(fname=grey_file)).M.V.run()

    white_file = 'T1_fast_pve_2.nii.gz'
    white_out = fslstats(fslanatdir.format(fname=white_file)).M.V.run()

    first_file = 'first_results/T1_first_all_fast_firstseg.nii.gz'
    hippoL = fslstats(fslanatdir.format(fname=first_file)).l(16.5).u(17.5).M.V.run()
    hippoR = fslstats(fslanatdir.format(fname=first_file)).l(52.5).u(53.5).M.V.run()
    amygR = fslstats(fslanatdir.format(fname=first_file)).l(17.5).u(18.5).M.V.run()
    amygL = fslstats(fslanatdir.format(fname=first_file)).l(53.5).u(54.5).M.V.run()
    thalL = fslstats(fslanatdir.format(fname=first_file)).l(9.5).u(10.5).M.V.run()
    thalR = fslstats(fslanatdir.format(fname=first_file)).l(48.5).u(49.5).M.V.run()
    caudL = fslstats(fslanatdir.format(fname=first_file)).l(10.5).u(11.5).M.V.run()
    caudR = fslstats(fslanatdir.format(fname=first_file)).l(49.5).u(50.5).M.V.run()
    putaL = fslstats(fslanatdir.format(fname=first_file)).l(11.5).u(12.5).M.V.run()
    putaR = fslstats(fslanatdir.format(fname=first_file)).l(50.5).u(51.5).M.V.run()
    palliL = fslstats(fslanatdir.format(fname=first_file)).l(12.5).u(13.5).M.V.run()
    palliR = fslstats(fslanatdir.format(fname=first_file)).l(51.5).u(52.5).M.V.run()

    tot_vol = bc_out[2]

    csf_vol = csf_out[0] * csf_out[2]
    csf_vol_norm = csf_vol / bc_out[2] * 100

    grey_vol = grey_out[0] * grey_out[2]
    grey_vol_norm = grey_vol / bc_out[2] * 100

    white_vol = white_out[0] * white_out[2]
    white_vol_norm = white_vol / bc_out[2] * 100

    hippoL_norm = hippoL[2] / tot_vol * 100
    hippoR_norm = hippoR[2] / tot_vol * 100
    hippoA_norm = hippoL_norm + hippoR_norm
    amygR_norm = amygR[2] / tot_vol * 100
    amygL_norm = amygL[2] / tot_vol * 100
    thalL_norm = thalL[2] / tot_vol * 100
    thalR_norm = thalR[2] / tot_vol * 100
    caudL_norm = caudL[2] / tot_vol * 100
    caudR_norm = caudR[2] / tot_vol * 100
    putaL_norm = putaL[2] / tot_vol * 100
    putaR_norm = putaR[2] / tot_vol * 100
    palliL_norm = palliL[2] / tot_vol * 100
    palliR_norm = palliR[2] / tot_vol * 100

    outs = (runname, tot_vol, grey_vol, grey_vol_norm, white_vol, white_vol_norm, csf_vol, csf_vol_norm, hippoL[2], hippoL_norm, hippoR[2], hippoR_norm, hippoA_norm, amygR_norm, amygL_norm, thalL_norm, thalR_norm, caudL_norm, caudR_norm, putaL_norm, putaR_norm, palliL_norm, palliR_norm)
    
    f.write(', '.join(map(str, outs)))
    f.write('\n')

f.close()
