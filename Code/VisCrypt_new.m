

function [share1, share2] = VisCrypt_new(inImg)
[imr, imc] = size(inImg);
share1 = zeros(1:imr, 1:imc);
share2 = zeros(1:imr, 1:imc);
% Threshold for generation shares
delta = 45;
% Image classification into background and textured regions
i = 1;
while i < (imr + 1)
for j = 1 : imc
aa = inImg(i, j) > delta;
bb = inImg(i, j) < (255 - delta);
if (aa && bb)
bla(i,j) = inImg(i, j);
blb(i,j) = 0;
else
bla(i,j) = 0;
blb(i,j) = inImg(i, j);
end
end
i = i + 1;
end
key = [240 169 196 235 83 85 157 102 12 43 55 79 93 108 188 55];
outputdata = [];
% determine size of cover image
Mc=size(bla,1); %Height
Nc=size(bla,2); %Width
%encript
im(1:Mc, 1:Nc) = bla(1:Mc, 1:Nc);
for r = 1:Mc
for c = 1:16:Nc
t = [im(r,c), im(r,c+1), im(r,c+2), im(r,c+3), im(r,c+4), im(r,c+5), im(r,c+6), im(r,c+7),im(r,c+8), im(r,c+9), im(r,c+10), im(r,c+11), im(r,c+12), im(r,c+13), im(r,c+14),im(r,c+15)];
outputdata = RC4IM2(key, t);
[im(r,c), im(r,c+1), im(r,c+2), im(r,c+3), im(r,c+4), im(r,c+5), im(r,c+6), im(r,c+7),im(r,c+8), im(r,c+9), im(r,c+10), im(r,c+11), im(r,c+12), im(r,c+13), im(r,c+14), im(r,c+15)]= oneto16(outputdata);
end
end
share1(1:Mc, 1:Nc) = im(1:Mc, 1:Nc);

key = [240 169 196 235 83 85 157 102 12 43 55 79 93 108 188 55];
outputdata = [];
% determine size of cover image
Mc2=size(blb,1); %Height
Nc2=size(blb,2); %Width
%encript
im(1:Mc2, 1:Nc2) = blb(1:Mc2, 1:Nc2);
for r = 1:Mc2
for c = 1:16:Nc2
t = [im(r,c), im(r,c+1), im(r,c+2), im(r,c+3), im(r,c+4), im(r,c+5), im(r,c+6), im(r,c+7),im(r,c+8), im(r,c+9), im(r,c+10), im(r,c+11), im(r,c+12), im(r,c+13), im(r,c+14),im(r,c+15)];
outputdata = RC4IM2(key, t);
[im(r,c), im(r,c+1), im(r,c+2), im(r,c+3), im(r,c+4), im(r,c+5), im(r,c+6), im(r,c+7),im(r,c+8), im(r,c+9), im(r,c+10), im(r,c+11), im(r,c+12), im(r,c+13), im(r,c+14), im(r,c+15)]= oneto16(outputdata);
end
end
share2(1:Mc2, 1:Nc2) = im(1:Mc2, 1:Nc2);