clc;
clear all;
close all;
warning 'off';
a=-1;%The value of the coffecient a 
b=188;%The Value of the coffecient b
p=751;%p=5711;
K=6;%K 

%%

PointIndex = 1;
for x = 0:p-1
    rightside = mod(x^3 + a*x + b, p);
    for y = 0:p-1
        if mod(y^2, p) == rightside
            Points(PointIndex, :) = [x y];
            PointIndex = PointIndex + 1;
        end
    end
end
%Points(PointIndex, :) = [Inf Inf];

%%

maping_table=cell(256,3);
for i=1:256
    for j=1:3
       maping_table{i,j}=0;
    end
end
u=1;
for j=1:3
    for i=1:256
        if(u<=PointIndex-1)
        maping_table{i,j}=Points(u,:);
        u=u+1;
        end
    end
end

%%

%G=[652,5576];%The value G generator point or the base point of the curve  y^2 = x^3 + ax + b 
G=[0,376];%The value G generator point or the base point of the curve  y^2 = x^3 + ax + b 
%G=[70,490];
%G=[11,20];
Nb=85; %round(1 + (40000 -1) * rand); %Nb for private key generation
%Na= round(1 + (50000 -1) * rand);%Na for key generation

%read the cover image 

[nam,path]=uigetfile('*','Select the Cover Image');
cv=[path nam];
%img=dicomread(cv);
img=imread(cv);

if(ndims(img)>2)
img=rgb2gray(img);
end
img=imresize(img,[50 50]);
figure(1),imshow(uint8(img));
title('Input Image');
img=uint8(img);

tic;
[Enc_img,Enc_img_col,temp1]=ecc_encrypt(img,G,K,Nb,a,b,p,maping_table);
toc;
Enc_img=uint8(Enc_img-1);
figure,imshow((Enc_img));

%%
[R2,C2,plane_msg] = size(Enc_img);
message_image=Enc_img;

%---------------------------------------- CONVERTING THE MESSAGE IMAGE PIXELS TO BITS -------------------------------------------------%  
 
Message_Image_Bits(R2*C2*plane_msg*8)=0; 
Message_Image_Bits = logical(Message_Image_Bits);

i = 1;
for p_lane=1:plane_msg
    for row = 1:1:R2
        for col = 1:1:C2
            for  bit = 1:1:8
                Message_Image_Bits(i) = bitget(message_image(row,col,p_lane),bit); 
                i = i + 1;
            end;
        end;
    end
end

Length_msg=length(Message_Image_Bits);
%%

[nam,path]=uigetfile('*','Select the Cover Image');
cv=[path nam];
%img=dicomread(cv);
carrier_image=imread(cv);
carrier_image = rgb2gray(carrier_image);   % CONVERTING TO GRAY IMAGE   ; USE rgb2gray function
%carrier_image = carrier_image(1:end,1:end);
carrier_image=imresize(carrier_image,[1024 1024]);
I1 = carrier_image;
[R1 C1] = size(carrier_image);         % Getting the Image Size (Rows and Columns)
figure(2);
imshow(carrier_image);
title('COVER IMAGE');

%%

size_carrier=size(carrier_image);
[LL,LH,HL,HH]=dwt2(carrier_image,'db1');
[LL1,LH1,HL1,HH1]=dwt2(LL,'db1');
[LL2,LH2,HL2,HH2]=dwt2(LL1,'db1');
size_LL1=size(LL);
size_LL2=size(LL1);
[R_LL2,C_LL2]=size(LL2);
figure(3)
subplot(2,2,1);imshow(uint8(LL1));title('LL band of image');
subplot(2,2,2);imshow(uint8(LH1));title('LH band of image');
subplot(2,2,3);imshow(uint8(HL1));title('HL band of image');
subplot(2,2,4);imshow(uint8(HH1));title('HH band of image');

%%

No_Of_Bits = 2; 
i = 1;
k = 0;
stego_image=uint8(HH1);
reference=stego_image;

N = R_LL2*C_LL2;   
A = randperm(N);
key = unique(A, 'rows');

for len=1:1:length(key)
           if (i<=Length_msg)
             k = k + 1;
            for ii=1:1:No_Of_Bits
              stego_image(row,col)=  bitset(stego_image(key(len)),ii,Message_Image_Bits(i)) ;              
              i = i + 1;              
            end;
          end;
end;

%%
X = idwt2(LL2,LH2,HL2,stego_image,'db1',size_LL2);
figure(4)
imshow(uint8(X));
Y = idwt2(X,LH1,HL1,HH1,'db1',size_LL1);
figure(4)
imshow(uint8(Y));
final_stego = idwt2(Y,LH,HL,HH,'db1',size_carrier);
figure(5)
imshow(uint8(final_stego ));

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%











