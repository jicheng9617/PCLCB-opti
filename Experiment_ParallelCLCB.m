clc; clearvars;
addpath( 'dace','Criterion_function');
%------------------------ parameters ---------------------------
fun_name = 'G4';        % function name 
num_q = 1;              % number of parallel resources
max_iteration = 20;       % maximum iteration
%% main procedure
[num_vari, design_space, optimum, num_con, optimum_to_reach] = Test_Function_Constrained(fun_name); % get the information of the test problem
num_initial = 5 * num_vari; % number of initial sample
sample_x = lhsdesign(num_initial, num_vari, 'criterion', 'maximin', 'iteration', 1000); 
[sample_y, sample_g] = feval(fun_name, sample_x); % get objective and constraint values of the initial sample
nn = min(5000*num_vari,20000); % random points for calculation of CoV
x_rand = repmat(design_space(1,:),nn,1)+repmat((design_space(2,:)-design_space(1,:)),nn,1).*rand(nn,num_vari);
% initiate parameters
iteration = 0;
f_min = zeros(max_iteration+1,1);
evaluation = size(sample_x,1);
fea_index = sum(sample_g <= 0, 2) == num_con;
if sum(fea_index) == 0
    f_min(1) = inf;
    fprintf('iteration: %d, evaluation: %d, best solution: no feasiable solution, real optimum: %f\n', 0, evaluation, optimum);
else
    f_min(1) = min(sample_y(fea_index, :));
    fprintf('iteration: %d, evaluation: %d, best solution: %f, real optimum: %f\n', 0, evaluation, f_min(1), optimum);
end
% iterative process
while iteration < max_iteration && f_min(iteration+1,1) >  optimum_to_reach 
    % build the kriging model for each obj. and cons.
    kriging_con = cell(1, num_con);
    for ii = 1: num_con
        kriging_con{ii} = dacefit(sample_x, sample_g(:, ii), 'regpoly0', 'corrgauss', 1*randn(1,num_vari), 1E-5*ones(1,num_vari), 1000*ones(1,num_vari));
    end
    kriging_obj = dacefit(sample_x, sample_y, 'regpoly0', 'corrgauss', 1*randn(1,num_vari), 1E-5*ones(1,num_vari), 1000*ones(1,num_vari));
    w=Evaluations_CoV(kriging_obj,x_rand); % calculation of the weights
    % select candidates using PesudoLCB algorithm
    if f_min(iteration+1) == inf
            infill_x = Criterion_PCLCB_infeasible( kriging_con, design_space, num_q, num_con, num_vari, sample_x, sample_g, iteration, max_iteration);
    else
        infill_x = Criterion_PCLCB_feasible(kriging_obj, kriging_con, w, design_space, num_q, num_con, num_vari, sample_x, sample_y, sample_g, iteration, max_iteration);
    end
    infill_y = zeros(size(infill_x, 1), 1); infill_g = zeros(size(infill_x, 1), num_con);
    % parallel evaluating the candidate with the real function or simulation. 
    for i = 1:size(infill_x,1)
        [infill_y(i, :),infill_g(i, :)] = feval(fun_name, infill_x(i,:));
    end
    % add the new point to design set
    sample_x = [sample_x; infill_x];
    sample_y = [sample_y; infill_y];
    sample_g = [sample_g; infill_g];
    % updating some parameters
    iteration = iteration+1;
    evaluation = size(sample_x,1);
    fea_index = sum(sample_g <= 0, 2) == num_con;
    fea_sample = [sample_x(fea_index, :), sample_y(fea_index, :), sample_g(fea_index, :)];
    if sum(fea_index) == 0
        f_min(iteration + 1) = inf;
        fprintf('iteration: %d, evaluation: %d, best solution: no feasiable solution, real optimum: %f\n', iteration, evaluation, optimum);
    else
        [f_min(iteration + 1), best_index] = min(sample_y(fea_index, :));
        best_x = fea_sample(best_index, 1:num_vari);
        best_y = fea_sample(best_index, num_vari + 1);
        best_g = fea_sample(best_index, num_vari + 2:end);
        fprintf('iteration: %d, evaluation: %d, best solution: %f, real optimum: %f\n', iteration, evaluation, f_min(iteration+1), optimum);
    end
end