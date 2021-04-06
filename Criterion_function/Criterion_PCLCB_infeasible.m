function best_x=Criterion_PCLCB_infeasible( kriging_con,design_space,num_q,num_con,num_vari,sample_x,sample_g,iteration,max_iteration)
options=optimoptions('particleswarm','SwarmSize',100,'MaxIterations',100,'MaxStallIterations',100,'Display','off', 'UseVectorized', true);
lb=design_space(1,:);
ub=design_space(2,:);
gamma=0;
rho=gamma*min(ub-lb);
original_x=sample_x;
best_x=zeros(num_q,num_vari);
for i=1:num_q
    infill_criterion = @(x)Function_CLCB_infeasible(x,kriging_con,sample_x,rho);
    % sub-optimization tool, the PSO is recommended
    %              optima_x=ga(infill_criterion,num_vari,[],[],[],[],lb,ub); % GA
    optima_x=particleswarm(infill_criterion,num_vari,lb,ub,options); % PSO
    % update the parameter for distance calculation
    gamma=1/(5*max_iteration*num_q)*sqrt(num_vari)*(max_iteration-iteration)/max_iteration;
    rho=gamma*min(ub-lb);
    % the prediction of the constraint models
    optima_g=zeros(1,num_con);
    for j=1:num_con
        optima_g(j)=predictor(optima_x,kriging_con{j});
    end
    best_x(i,:)=optima_x;
    % rebuild the temporary Kriging models of constraints
    sample_x=[sample_x;optima_x];
    sample_g=[sample_g;optima_g];
    for j=1:num_con
        kriging_con{j} = dacefit(sample_x, sample_g(:, j),'regpoly0','corrgauss',1*ones(1,num_vari),0.001*ones(1,num_vari),100*ones(1,num_vari));
    end
    % discard the repeated points
    ind=ismember(best_x,original_x,'rows');
    best_x(ind,:)=[];
end