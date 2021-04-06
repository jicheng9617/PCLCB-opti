function best_x=Criterion_PCLCB_feasible(kriging_obj,kriging_con,w,design_space,num_q,num_con,num_vari,sample_x,sample_y,sample_g,iteration,max_iteration)
options=optimoptions('particleswarm','SwarmSize',100,'MaxIterations',100,'MaxStallIterations',100,'Display','off', 'UseVectorized', true);
lb=design_space(1,:);
ub=design_space(2,:);
gamma=0;
rho=gamma*min(ub-lb);
c=1*1/max_iteration*(max_iteration-iteration);
best_x=[];
for i=1:num_q
    pre_con=zeros(1,num_con); mse_con=zeros(1,num_con);
    infill_criterion=@(x)Function_CLCB_feasible(x,kriging_obj,kriging_con,sample_x,rho,w,c);
    % sub-optimization tool, the PSO is recommended
    %              optima_x=ga(infill_criterion,num_vari,[],[],[],[],lb,ub);
    optima_x=particleswarm(infill_criterion,num_vari,lb,ub,options);
    % update the parameter for distance calculation
    gamma=max(1/(5*max_iteration*num_q)*sqrt(num_vari)*(max_iteration-iteration)/max_iteration,0);
    rho=gamma*min(ub-lb);
    if min(pdist2(optima_x,sample_x))>=1e-10  % discard the repeated points
        best_x=[best_x;optima_x];
        pre_obj=predictor(optima_x,kriging_obj);
        for j=1:num_con
            [pre_con(j),~,mse_con(j)]=predictor(optima_x,kriging_con{j});
        end
        pseudo_obj=pre_obj;
        pseudo_con=pre_con;
        sample_y=[sample_y;pseudo_obj];
        sample_x=[sample_x;optima_x];
        sample_g=[sample_g;pseudo_con];
        for ii = 1: num_con
            kriging_con{ii} = dacefit(sample_x, sample_g(:, ii),'regpoly0','corrgauss',0.1*ones(1,num_vari),0.001*ones(1,num_vari),100*ones(1,num_vari));
        end
        kriging_obj = dacefit(sample_x,sample_y,'regpoly0','corrgauss',0.1*ones(1,num_vari),0.001*ones(1,num_vari),100*ones(1,num_vari));
    end
end
    