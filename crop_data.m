%crop data

date = '20140207_214938';
l = 950;
r = 1150;
t = 110;
b = 310;
hh = imread(['hhv/' date '-HH-8by8-mat.tif']);
hv = imread(['hhv/' date '-HV-8by8-mat.tif']);
ic_cnn = imread(['view/' date '-ic-cnn.png']);
ic_cnn_sfcrf = imread(['view/' date '-ic-cnn-sfcrf.png']);
ima = imread(['view/valid/' date '_ima_noribon.png']);
hh = hh(t:b,l:r);
ic_cnn = ic_cnn(t:b,l:r,:);
ic_cnn_sfcrf = ic_cnn_sfcrf(t:b,l:r,:);
%ima = ima(t:b,l:r,:);
figure;
subplot(141);imshow(hh);
subplot(142);imshow(ic_cnn);
subplot(143);imshow(ic_cnn_sfcrf);
%subplot(144);imshow(ima);
imwrite(hh,['~/Dropbox/WorkSVN/2015-03-CNN-SFCRF-ice-RSE/figures/fyi_hh_20140207_214938.png'])
imwrite(ic_cnn,['~/Dropbox/WorkSVN/2015-03-CNN-SFCRF-ice-RSE/figures/fyi_ic_cnn_20140207_214938.png'])
imwrite(ic_cnn_sfcrf,['~/Dropbox/WorkSVN/2015-03-CNN-SFCRF-ice-RSE/figures/fyi_cnn_sfcrf_20140207_214938.png'])