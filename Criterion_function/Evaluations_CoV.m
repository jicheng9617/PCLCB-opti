function w = Evaluations_CoV (Kriging_model,x_rand)
[y_rand, y_rand_mse] = predictor(x_rand,Kriging_model);
y_rand_rmse=sqrt(max(0,y_rand_mse));
X=[y_rand y_rand_rmse];
[m,n]=size(X);  
a=0; 
A=zeros(1,n);
for j=1:n  
    for i=1:m  
        a=a+X(i,j)^2;  
    end  
    A(1,j)=sqrt(a);  
    a=0;  
end  
A=repmat(A,m,1);  
Y=X./A;
yy=Y(:,1);
ss=Y(:,2);
yy_mean=sum(yy)/size(yy,1);
yy_rmse=sqrt(sum((yy-yy_mean).^2)./size(yy,1));
a1=yy_rmse/yy_mean;
ss_mean=sum(ss)/size(ss,1);
ss_rmse=sqrt(sum((ss-ss_mean).^2)./size(ss,1));
a2=ss_rmse/ss_mean;
w1=abs(a1)/(abs(a1)+abs(a2));
w2=abs(a2)/(abs(a1)+abs(a2));
w=[w1,w2];