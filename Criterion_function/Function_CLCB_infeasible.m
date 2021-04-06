function obj=Function_CLCB_infeasible(x,kriging_con,sample_x,rho)
num_con=length(kriging_con);
a=1;
n=size(x,1);
g=zeros(n,num_con);
s2=zeros(n,num_con);
for i=1:num_con
    if n>1
        [g(:,i),s2(:,i)]=predictor(x,kriging_con{i});
    else
        [g(:,i),~,s2(:,i)]=predictor(x,kriging_con{i});
    end
end
G=max(g,0);
s=sqrt(max(s2,0));
glcb=sum(G-a*s,2);
% glcb=sum(G,2);
ind=min(pdist2(x,sample_x),[],2)<rho; % the distance costraint
obj=glcb+1e10*ind;
