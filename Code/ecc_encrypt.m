function [Enc_img,Enc_img_col,temp1]=ecc_encrypt(img,G,K,Nb,a,b,p,maping_table)

[row1 col1 dim]=size(img);

Pb= EllipticCurveFastScalMult(G, Nb, a, b, p);%public key

index_points=zeros(size(maping_table));
roll_over=zeros(size(maping_table,1),1);
col_value=1;

temp1= EllipticCurveFastScalMult(G, K, a, b, p);
temp2=EllipticCurveFastScalMult(Pb, K, a, b, p);
for i=1:row1

    for j= 1:col1
      
        pixel_value=img(i,j);
        
                
        
        row_pixel=index_points(pixel_value+1,:);
        
%         if(sum(row_pixel)==0)
%              Pm =  maping_table(pixel_value+1,1);
%              index_points(pixel_value+1,1)=1;    
%         else
            col_value=sum(row_pixel)+1;  
            if(col_value>=3)
              index_points(pixel_value+1,:)=0; 
              roll_over(pixel_value+1,1)=roll_over(pixel_value+1,1)+1;
              col_value=1;
            end
         
            Pm =  maping_table{pixel_value+1,col_value};
            index_points(pixel_value+1,col_value)=1; 
           
%         end

    %disp(Pm);

  

    temp3= EllipticCurvePointAdditionModp(Pm, temp2, a, b, p);

    Pc=[temp1,temp3];
    Encrypt_table{i,j}=temp3;
  
    end
end
%%
[row_Enc,col_Enc]=size(Encrypt_table);
Enc_img=zeros(size(Encrypt_table));
Enc_img_col=zeros(size(Encrypt_table));
flag=0;
for i=1:row_Enc

    for j= 1:col_Enc
        
        data=Encrypt_table{i,j};
        
        for u=1:size(maping_table,1)
            
           for v=1:size(maping_table,2) 
               
               res=data==maping_table{u,v};
               
               if(res(1)&&res(2))
                 
                   Enc_img(i,j)=u;
                   Enc_img_col(i,j)=v;
                   flag=1;
                   break;
                   
               end
                              
           end
           
           if(flag==1)
               flag=0;
               break;
           end
           
        end 
    
    end
end