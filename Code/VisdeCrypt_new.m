

function [rec_share1, rec_share2] = VisdeCrypt_new(share1, share2)
key = [240 169 196 235 83 85 157 102 12 43 55 79 93 108 188 55];
outputdata = [];
% determine size of watermarked image
Mw=size(share1,1); %Height
Nw=size(share1,2); %Width
w_im(1:Mw,1:Nw) = share1(1:Mw,1:Nw);
%decript
for r = 1:Mw
for c = 1:16:Nw
t = [w_im(r,c), w_im(r,c+1), w_im(r,c+2), w_im(r,c+3), w_im(r,c+4), w_im(r,c+5), w_im(r,c+6), w_im(r,c+7),w_im(r,c+8), w_im(r,c+9), w_im(r,c+10), w_im(r,c+11), w_im(r,c+12), w_im(r,c+13), w_im(r,c+14),w_im(r,c+15)];
outputdata = RC4IM2D(key, t);
[w_im(r,c), w_im(r,c+1), w_im(r,c+2), w_im(r,c+3), w_im(r,c+4), w_im(r,c+5),w_im(r,c+6), w_im(r,c+7),w_im(r,c+8), w_im(r,c+9), w_im(r,c+10), w_im(r,c+11), w_im(r,c+12), w_im(r,c+13), w_im(r,c+14), w_im(r,c+15)]= oneto16(outputdata);
end
end

rec_share1(1:Mw,1:Nw) = w_im(1:Mw,1:Nw);
key = [240 169 196 235 83 85 157 102 12 43 55 79 93 108 188 55];
outputdata = [];
% determine size of watermarked image
Mw2=size(share2,1); %Height
Nw2=size(share2,2); %Width
w_im(1:Mw2,1:Nw2) = share2(1:Mw2,1:Nw2);
%decript
for r = 1:Mw2
for c = 1:16:Nw2
t = [w_im(r,c), w_im(r,c+1), w_im(r,c+2), w_im(r,c+3), w_im(r,c+4), w_im(r,c+5), w_im(r,c+6), w_im(r,c+7),w_im(r,c+8), w_im(r,c+9), w_im(r,c+10), w_im(r,c+11), w_im(r,c+12), w_im(r,c+13), w_im(r,c+14),w_im(r,c+15)];
outputdata = RC4IM2D(key, t);
[w_im(r,c), w_im(r,c+1), w_im(r,c+2), w_im(r,c+3), w_im(r,c+4), w_im(r,c+5),w_im(r,c+6), w_im(r,c+7),w_im(r,c+8), w_im(r,c+9), w_im(r,c+10), w_im(r,c+11), w_im(r,c+12), w_im(r,c+13), w_im(r,c+14), w_im(r,c+15)]= oneto16(outputdata);
end
end
rec_share2(1:Mw2,1:Nw2) = w_im(1:Mw2,1:Nw2);