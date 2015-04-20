%reproject image analysis to corresponding SAR images
hhlist = dir('../images_gsl2014/hhv/*-HH-8by8-mat.tif');
reflist = dir('../images_gsl2014/*_8by8.tif');
%mkdir('ima');
%mkdir('hhv');
for i = 1:numel(hhlist)
    i = 19
    date = hhlist(i).name(1:8);
    date_time = hhlist(i).name(1:15);
    if date_time == '20140206_105657' % ima of this scene contains less than 10 points 
        continue
    end
    imalist = dir(['../gsl_ima/' date '*.dat']);
    hhfile = ['../images_gsl2014/hhv/' hhlist(i).name];
    hvfile = ['../images_gsl2014/hhv/' date_time '-HV-8by8-mat.tif'];
    reffile = ['../images_gsl2014/' date_time '_8by8.tif'];
    maskfile = ['mask/' date_time '-mask.tif'];
    out = ['ima/' date_time '_ima.txt'];
    infohh = imfinfo(hhfile);
    inforef = imfinfo(reffile);
    width = min([infohh.Width;inforef.Width]);
    height = min([infohh.Height;inforef.Height]);
    im = imread(hhfile);
    imwrite(im(1:height,1:width),['hhv/' hhlist(i).name]);
    im = imread(hvfile);
    imwrite(im(1:height,1:width),['hhv/' date_time '-HV-8by8-mat.tif']);
    im = imread(maskfile);
    imwrite(im(1:height,1:width),['mask/' date_time '-mask.tif']);
    ima = [];
    for j = 1:numel(imalist)
        datum = load(['../gsl_ima/' imalist(j).name]);
        ima = [ima;datum];
    end
    tmp = 'tmp.txt';
    dlmwrite(tmp,ima(:,1:2), ' '); % write the lat/lon of each pixel of amsre.  
    strprojcmd = ['gdaltransform -i ',reffile,' < "',tmp,'" >"',out,'"'];
    %use gdaltransform to calculate the image coordinate of each pixel of amsre, 
    %gdal should be installed and be in system search path to garenty successful invoke
    delete(out);
    system(strprojcmd); 
    if exist(out,'file') == 0
        disp('Error~');
        delete(tmp);
        return
    end
cood = load(out);
index = cood(:,1)>0 & cood(:,1)<width & cood(:,2)>0 & cood(:,2)<height;
cood = cood(index,:);
ima = ima(index,:);
dlmwrite(out,[cood(:,1) cood(:,2) ima(:,3)], ' ');
delete(tmp);
end