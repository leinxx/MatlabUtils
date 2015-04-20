%generate images for viewing


prefix = '/home/lein/Work/Sea_ice/gsl2014_hhv_ima/hhv/';
icdir = '~/Work/deeplearning/sar_dnn/src_gsl/0/';
ic_sfcrf_dir = '~/Work/deeplearning/sar_dnn/src_gsl/SFCRF/data/';
list = dir([icdir '*.tif']);
for i = 1:numel(list)
   close all
   date = list(i).name(1:15)
   ic = imread([icdir list(i).name]);
   mask = imread(['mask/' date '-mask.tif']);
   ic = ic.*(mask == 0);
   gray2color(ic,['view/' date '-ic-cnn.png'])
   
   load([ic_sfcrf_dir date '-x1.mat']);
   x = (2-x).*(mask == 0);
   gray2color(x,['view/' date '-ic-cnn-sfcrf.png'])
   %viewimagsl(date)
   continue
   hh = imread([prefix date '-HH-8by8-mat.tif']);
   imwrite(hh,[date '-HH-8by8-mat.png']);
   hv = imread([prefix date '-HV-8by8-mat.tif']);
   hv = imadjust(hv);
   imwrite(hv,[date '-HV-8by8-mat.png']);
   close all
    
end