

img0=zeros(512,256,3);

for i=1:256
    
    img0(:,i,1)=i-1;
    
end

figure,imshow(img0);

img1=zeros(512,256,3);

for i=1:256
    
    img1(:,i,2)=i-1;
    
end

figure,imshow(img1);

img2=zeros(512,256,3);

for i=1:256
    
    img2(:,i,3)=i-1;
    
end

img=[img0 img1 img2];

figure,imshow(img);

figure,imshow(img2);