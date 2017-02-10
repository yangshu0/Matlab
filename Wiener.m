clear;  
C=imread('rice.jpg'); 
I=rgb2gray(C);
figure;  
subplot(2,2,1);
imshow(I);
title('original'); 
[m,n]=size(I); 
F=fftshift(fft2(I)); 
k=0.00025; 
H = zeros(m,n);

for u=1:m      
    for  v=1:n          
        H(u,v)=exp((-k)*(((u-m/2)^2+(v-n/2)^2)^(5/6)));     
    end
end
G=F.*H;  
I0=real(ifft2(fftshift(G)));  
I1=imnoise(uint8(I0),'gaussian',0,0.001);  
subplot(2,2,2);
imshow(uint8(I1));title('gausian noise and blur');   
F0=fftshift(fft2(I1)); 
F1=F0./H;  
I2=ifft2(fftshift(F1));  
subplot(2,2,3);imshow(uint8(I2));
title('inverse filter');   
K=0.1;                    

for u=1:m      
    for  v=1:n          
        H(u,v)=exp(-k*(((u-m/2)^2+(v-n/2)^2)^(5/6)));         
        H0(u,v)=(abs(H(u,v)))^2;          
        H1(u,v)=H0(u,v)/(H(u,v)*(H0(u,v)+K));     
    end
end
F2=H1.*F0;  
I3=ifft2(fftshift(F2));  
subplot(2,2,4);

imshow(uint8(I3));title('Wiener filter');