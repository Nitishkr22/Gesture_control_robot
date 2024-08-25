function [Dec_img]=ecc_decrypt(Enc_img,Enc_img_col,temp1,Nb,a,b,p,maping_table)

[row_Enc,col_Enc]=size(Enc_img);

for i=1:row_Enc

    for j= 1:col_Enc

             row_ind=Enc_img(i,j);
             col_ind=Enc_img_col(i,j);
             
             Decrypt_table{i,j}=maping_table{row_ind,col_ind};             
             
    end
    
end

%%

temp_data= EllipticCurveFastScalMult(temp1, Nb, a, b, p);

temp_res(1)=temp_data(1);
temp_res(2)=-temp_data(2);

for i=1:row_Enc
    
    for j= 1:col_Enc

    Decode_table{i,j}= EllipticCurvePointAdditionModp(Decrypt_table{i,j}, temp_res, a, b, p);

    end
    
end
%%
Dec_img=zeros(row_Enc,col_Enc);
flag=0;
for i=1:row_Enc

    for j= 1:col_Enc
        
        data=Decode_table{i,j};
        
        for u=1:size(maping_table,1)
            
           for v=1:size(maping_table,2) 
               
               res=data==maping_table{u,v};
               
               if(res(1)&&res(2))
        
                Dec_img(i,j)=u-1;
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
% 
% Dec_img = imnoise(uint8(Dec_img),'salt & pepper',0.05);
end


