
flist = dir('~/Work/deeplearning/sar_dnn/dataset/gsl2014_40/*.pkl');
for i = 2:numel(flist)
    date = flist(i).name(1:15);
    des = ['mask/' date '-mask.tif'];
    ref = ['../images_gsl2014/' date '_8by8.tif'];
    project_landmask(des,ref);
end