function [num_vari,design_space,optimum,num_con,optimum_to_reach,max_evaluation] = Test_Function_Constrained(name)
%--------------------------------------------------------------------------
% single-objective optimization problem
switch name

    case 'G24';     num_vari=2; design_space=[0,0;3,4]; optimum=-5.5080; num_con=2; optimum_to_reach=-5.5070;max_evaluation=50;
    case 'G2'; num_vari=10; design_space=repmat([0;10],1,10); optimum=-0.67; num_con=2; optimum_to_reach=-0.55;max_evaluation=100;
    case 'G4'; num_vari=5; design_space=[78,33,27,27,27;102,45,45,45,45]; optimum=-30665.639; num_con=6; optimum_to_reach=-30665; max_evaluation=50;
    case 'G5MOD'; num_vari=4; design_space=[0,0,-0.55,-0.55;1200,1200,0.55,0.55]; optimum=5126.50; num_con=5; optimum_to_reach=5130;max_evaluation=50;
    case 'G6';      num_vari=2; design_space=[13,0;100,100]; optimum=-6961.81388; num_con=2; optimum_to_reach=-6960;max_evaluation=50;
    case 'G7'; num_vari=10; design_space=repmat([-10;10],1,10); optimum=24.3062; num_con=8; optimum_to_reach=28;max_evaluation=100;
    case 'G8';      num_vari=2; design_space=[0.0001,0.0001;10,10]; optimum=-0.095825; num_con=2; optimum_to_reach=-0.0957;max_evaluation=100;
    case 'G9'; num_vari=7; design_space=repmat([-10;10],1,num_vari); optimum=680.6301; num_con=4; optimum_to_reach=1000;max_evaluation=150;
    case 'Hesse'; num_vari=6; design_space=[0,0,1,0,1,0;5,4,5,6,5,10]; optimum=-310.00; num_con=6; optimum_to_reach=-309.5;max_evaluation=50;
    case 'Frame';   num_vari=3; design_space=[2.5,2.5,0.1;10,10,1]; optimum=703.916; num_con=2; optimum_to_reach= 704;max_evaluation=50;
    case 'Pressure_Vessel'; num_vari=4; design_space=[1,0.625,25,25;1.375,1,150,240]; optimum=7.0069e+03; num_con=3; optimum_to_reach=7007;max_evaluation=50;
    case 'Reducer'; num_vari=7; design_space=[2.6,0.7,17,7.3,7.3,2.9,5;3.6,0.8,28,8.3,8.3,3.9,5.5]; optimum=2994.42; num_con=11; optimum_to_reach=2995;max_evaluation=50;
    case 'C7'; num_vari=30; design_space=repmat([-140;140],1,num_vari);optimum=0; num_con=1; optimum_to_reach=0;
    case 'C8'; num_vari=30; design_space=repmat([-140;140],1,num_vari);optimum=0; num_con=1; optimum_to_reach=0;
    case 'C14'; num_vari=30; design_space=repmat([-1000;1000],1,num_vari);optimum=0; num_con=3; optimum_to_reach=0;
    case 'C15'; num_vari=30; design_space=repmat([-1000;1000],1,num_vari);optimum=0; num_con=3; optimum_to_reach=0;

end
end




