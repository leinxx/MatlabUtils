%Lei Wang
%alphaleiw@gmail.com
%2013-05-21
%Reproject amsre sea ice data according to a reference image, the out come is
%aligned with the reference image pixel by pixel.
%First it reproject amsre into lat/lon by using polarstereo_inv, because
%the ellips information in asmre tiff file is actually not right, so this
%specific function has to be used, more details about the projection of
%amsre tiff file can be found at http://www.iup.uni-bremen.de/seaice/amsr/README_GEOTIFF.txt
%Then gdaltransform is used to project the generated lat/lon txt file from
%last step to image coordinates in the ref image, the coordinates are
%stored in tmp_amsre_ref.txt.
%After, interpolate the coordinates into grids and write result to image
%file. The scale of value is 20000, so pixelvalue/20000 is the actual
%concentration,20001 is no value mask
%Return: the iamge matrix of result.
%Notes: There is no geo information in the output image, but it has exactly
%the same geo-information and dimension as the ref image
function zi = project_landmask(des,ref)
    %src is the name of amsre file that to be projected
    %des is the name of output
    %ref is the name of reference file with the target projection and
    %resolution
    tic
load('landmaskna.mat');
disp('Reproject target file to reference file coordinate space...')

tmp_amsre_lon_lat = 'tmp_amsre_lon_lat.txt';
tmp_amsre_ref = 'tmp_amsre_ref.txt';
if ~existfile(tmp_amsre_lon_lat)
    lon = repmat(lonvalsna,size(landnafp,1),1);
    lat = repmat(latvalsna',1, size(landnafp,2));
    dlmwrite(tmp_amsre_lon_lat,[lon(:) lat(:)], ' '); % write the lat/lon of each pixel of amsre.  
end

strprojcmd = ['gdaltransform -i ',ref,' < "',tmp_amsre_lon_lat,'" >"',tmp_amsre_ref,'"'];
%use gdaltransform to calculate the image coordinate of each pixel of amsre, 
%gdal should be installed and be in system search path to garenty successful invoke
delete(tmp_amsre_ref);
system(strprojcmd); 
if exist(tmp_amsre_ref,'file') == 0
    disp('Error~');
    return
end
disp('Read reference file...')
iref = imread(ref);
xyinref = load(tmp_amsre_ref);
dim = size(iref);

disp('Interpolation...')
xindex = xyinref(:,1)>-2 & xyinref(:,1)<dim(2)+2; % keep pixels that lye out side of ref image but close to the boundaries to help the interpolation/gridrization after.
yindex = xyinref(:,2)>-2 & xyinref(:,2)<dim(1)+2;
index = xindex.*yindex;
index = find(index == 1);
xyinref = xyinref(index,:);
i = ~isnan(landnafp);
i = uint8(i);


i = i(index);

[ix,iy] = meshgrid(0:dim(2)-1,0:dim(1)-1);
F = TriScatteredInterp(xyinref(:,1),xyinref(:,2),double(i),'nearest');
zi = F(ix,iy); %interpolate the amsre to ref image grid using 'nature' interpolation method. 
%'Nature interpolation' seaches nearest k neighbors to do the interpolation.

disp('Write output image with pixel vaule scaled by 20000 times')
imwrite(zi,des,'tiff'); %scale as 20000
disp('Done.')
toc

end