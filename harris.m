clear;
[filename, pathname, ~] = uigetfile('*.jpg', 'Select jpeg');
if ~ischar(filename)     
    return 
end
str=[pathname filename];    
pic=imread(str);  
if length(size(pic))==3     
    img=rgb2gray(pic); 
end

[m,n]=size(img);

tmp=zeros(m+2,n+2);  
tmp(2:m+1,2:n+1)=img;   %??????1???   
tmp(1,:) = tmp(2, :);
tmp(m+2, :) = tmp(m+2,:);
tmp(:, 1) = tmp(:, 2);
tmp(:, n+2) = tmp(:, n+1);
Ix=zeros(m+2,n+2); 
Iy=zeros(m+2,n+2);  
Ix(:,2:n+1)=tmp(:,3:n+2)-tmp(:,1:n);    % x??????  
Iy(2:m+1,:)=tmp(3:m+2,:)-tmp(1:m,:);    % y??????
Ix2=Ix(2:m+1,2:n+1).^2; 
Iy2=Iy(2:m+1,2:n+1).^2;  
Ixy=Ix(2:m+1,2:n+1).*Iy(2:m+1,2:n+1);    

h=fspecial('gaussian',[7 7],2);    %??????????????? 

Ix2=filter2(h,Ix2);     %?? 
Iy2=filter2(h,Iy2); 
Ixy=filter2(h,Ixy);    

R=zeros(m,n); 

for i=1:m     
    for j=1:n          
        M=[Ix2(i,j) Ixy(i,j); Ixy(i,j) Iy2(i,j)];    %??Hessian??         
        R(i,j)=det(M)-0.06*(trace(M))^2;    %??????     
    end
end

Rmax=max(max(R));    
loc=[];      %??????  
tmp(2:m+1,2:n+1)=R;     %??????1???
for i=2:m+1
    for j=2:n+1
        if tmp(i,j)>0.2*Rmax %????R?????????0.01?????             
            sq=tmp(i-1:i+1,j-1:j+1);
            sq=reshape(sq,1,9);
            sq=[sq(1:4),sq(6:9)];
            if tmp(i,j) > sq  %????????                 
                loc=[loc;[j-1,i-1]];
            end
        end
    end
end

%?????????Harris?? 
X=loc(:,1);
Y=loc(:,2);
subplot(1,2,1);imshow(pic);
subplot(1,2,2);imshow(pic);
hold on;
plot(X,Y,'*');
hold off;
