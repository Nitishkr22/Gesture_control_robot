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

[nam,path]=uigetfile('*','Select the Secret Image');
cv=[path nam];
%img=dicomread(cv);
img=imread(cv);

if(ndims(img)>2)
img=rgb2gray(img);
end
img=imresize(img,[80 80]);
figure(1),imshow(uint8(img));
title('Input Image');
img=uint8(img);

tic;
[Enc_img,Enc_img_col,temp1]=ecc_encrypt(img,G,K,Nb,a,b,p,maping_table);
enc_time=toc;
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
if(ndims(carrier_image)>2)
carrier_image=rgb2gray(carrier_image);
end
  % CONVERTING TO GRAY IMAGE   ; USE rgb2gray function
%carrier_image = carrier_image(1:end,1:end);
carrier_image=imresize(carrier_image,[2048 2048]);
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

i = 1;
k = 0;
stego_image=uint8(HH2);
reference=stego_image;

if((R2*C2*8)>(size(HH2,1)*size(HH2,2)))
  errordlg('Can not Hide the Data'); 
  error('Can not Hide the Data');
end

N = R_LL2*C_LL2;   
A = randperm(N);
key = unique(A, 'rows');

for len=1:1:length(key)
           if (i<=Length_msg)
             k = k + 1;
            if(Message_Image_Bits(i)>0)
              stego_image(key(len))= (stego_image(key(len))+1); 
            else
              stego_image(key(len))= (stego_image(key(len))); 
            end
              i = i + 1;              
           
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
imshow(uint8(final_stego));
title('Stego Image');
%%

[share1, share2] =  VisCrypt(final_stego);
figure(6),imshow((share1));
title('CA Share1');
figure(7),imshow((share2));
title('Customer Shere2');





%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

share12=bitor(share1, share2);
share12 = ~share12;
figure(8),imshow(share12);
title('Overlaped Two Share');

%%


size_carrier=size(final_stego);
[LL_stego,LH_stego,HL_stego,HH_stego]=dwt2(final_stego,'db1');
[LL1_stego,LH1_stego,HL1_stego,HH1_stego]=dwt2(LL_stego,'db1');
[LL2_stego,LH2_stego,HL2_stego,HH2_stego]=dwt2(LL1_stego,'db1');
% size_LL1=size(LL_stego);
% size_LL2=size(LL1_stego);
% [R_LL2,C_LL2]=size(LL2_stego);
% figure(6)
% subplot(2,2,1);imshow(uint8(LL1));title('LL band of image');
% subplot(2,2,2);imshow(uint8(LH1));title('LH band of image');
% subplot(2,2,3);imshow(uint8(HL1));title('HL band of image');
% subplot(2,2,4);imshow(uint8(HH1));title('HH band of image');

%%

[LL_carrier,LH_carrier,HL_carrier,HH_carrier]=dwt2(carrier_image,'db1');
[LL1_carrier,LH1_carrier,HL1_carrier,HH1_carrier]=dwt2(LL_carrier,'db1');
[LL2_carrier,LH2_carrier,HL2_carrier,HH2_carrier]=dwt2(LL1_carrier,'db1');
size_LL1=size(LL_carrier);
size_LL2=size(LL1_carrier);
[R_LL2,C_LL2]=size(LL2_carrier);
% figure(6)
% subplot(2,2,1);imshow(uint8(LL1));title('LL band of image');
% subplot(2,2,2);imshow(uint8(LH1));title('LH band of image');
% subplot(2,2,3);imshow(uint8(HL1));title('HL band of image');
% subplot(2,2,4);imshow(uint8(HH1));title('HH band of image');

%%
recovered_bits=zeros(1,R2*C2*8);
HH2_stego=(uint8(HH2_stego));
HH2_carrier=(uint8(HH2_carrier));
diff_stego=abs(HH2_stego-HH2_carrier);
bin_stego=diff_stego>0;
i=1;
for len=1:1:length(key)
           if (len<=k)
               
            if(bin_stego(key(len))>0)
              recovered_bits(i)=1;              
            else
               recovered_bits(i)=0;
            end
              i = i + 1;              
          end;
          
end;
%%

Recovered_Data(1:R2,1:C2)=0; 
Recovered_Data = uint8(Recovered_Data);

i = 1;
for k=1:R2
    for l=1:C2
      for bit =1:1:8
        Recovered_Data(k,l) = bitset(Recovered_Data(k,l),bit,recovered_bits(i));
        i = i + 1;
      end; 
    end
end

figure,imshow(Recovered_Data);
title('Recovered Encrypted Image');

%%
Recovered_Data=Recovered_Data+1;
tic;
[Dec_img]=ecc_decrypt(Recovered_Data,Enc_img_col,temp1,Nb,a,b,p,maping_table);
dec_time=toc;
figure,imshow(uint8(Dec_img));
title('Recovered Message Image');
 
%%

I=double(I1);

Q = max(max(I));

im1=double(final_stego);

[nRow,nColumn]=size(I);

MSE = sum(sum((im1-I).^2))/nRow / nColumn;

PSNR  = 10*log10(Q*Q/MSE);

fprintf('Encryption Time:=%f Sec\n',enc_time);

fprintf('Decryption Time:=%f Sec\n',dec_time);

fprintf('PSNR for Stego and Carrier Image:=%f\n',PSNR);

fprintf('MSE for Stego and Carrier Image:=%f\n',MSE);

fprintf('Embedding Capacity:=%f bits/pixels\n',(R2*C2*8)/(R1*C1));

fprintf('Entropy of the Carrier image:=%f \n',entropy(uint8(I)));

fprintf('Entropy of the Stego image:=%f \n',entropy(uint8(final_stego)));


%%
I_msg=double(img);

Q = max(max(I_msg));

im1_msg=double(Dec_img);

[nRow_msg,nColumn_msg]=size(I_msg);

MSE = sum(sum((im1_msg-I_msg).^2))/nRow_msg / nColumn_msg;

PSNR  = 10*log10(Q*Q/MSE);

fprintf('PSNR for Mesaage and Recover Image:=%f\n',PSNR);

fprintf('MSE for Mesaage and Recover Image:=%f\n',MSE);

fprintf('Entropy of the Secret image:=%d \n',entropy(uint8(I_msg)));
%%

Num=sum(sum(I.^2));
Den=sum(sum(im1.^2));
Structure_Content=Num/Den;
fprintf('Structure Content:=%f\n',Structure_Content);

%%

AD = sum(sum(abs(im1-I)))/nRow / nColumn;
fprintf('Average Difference:=%f\n',AD);

%%

MD = max(max(abs(im1-I)));
fprintf('Maximum Difference:=%f\n',MD);

%%

NAE = sum(sum(abs(im1-I)))/(sum(sum(I)));
fprintf('Normalized Absolute Error:=%f\n',NAE);

%%

UACI=((sum(sum(abs(double(img)-double(Enc_img)))))/(255*R2 * C2))*100;

D=double(img)~=double(Enc_img);

NPCR=(sum(sum(D))/(R2 * C2))*100;

fprintf('Unified  average changing intensity:=%f\n',UACI);
fprintf('Number of pixels change rate:=%f\n',NPCR);

%%
Correlation_val=corr2(I,im1);
fprintf('Correlation Value:=%f\n',Correlation_val);

%%

fprintf('Size of the Carrier in Bits:=%f\n',nRow*nColumn*8);
fprintf('Size of the Stego in Bits:=%f\n',nRow*nColumn*8);

fprintf('Size of the Message in Bits:=%f\n',nRow_msg*nColumn_msg*8);
fprintf('Size of the Recovered in Bits:=%f\n',nRow_msg*nColumn_msg*8);










