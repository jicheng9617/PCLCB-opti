function obj=Function_CLCB_feasible(x,kriging_obj,kriging_con,sample_x,rho,w,c)
% initialize parameters
num_con=length(kriging_con);
n=size(x,1);
w1=w(:,1);
w2=w(:,2);
g=zeros(n,num_con);
sg2=zeros(n,num_con);
% get the Kriging prediction and variance
if n==1
    [y,~, sy2]=predictor(x,kriging_obj);
else
    [y, sy2]=predictor(x,kriging_obj);
end
sy=sqrt(max(0,sy2));
% calcuate the LCB value
lcb=w1*y-w2*sy;
% prediction of the constraints
for i=1:num_con
    if n>1
        [g(:,i),sg2(:,i)]=predictor(x,kriging_con{i});
    else
        [g(:,i),~,sg2(:,i)]=predictor(x,kriging_con{i});
    end
end
sg=sqrt(max(0,sg2));
% judge the constraint of the distances
ind_dis=min(pdist2(x,sample_x),[],2)<rho;
obj=lcb+1e10*ind_dis+1e10*max(max(g-c*sg,[],2),0);
