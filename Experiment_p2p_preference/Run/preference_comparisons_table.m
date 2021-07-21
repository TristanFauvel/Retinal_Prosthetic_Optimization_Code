Codes = {'Naive', 'Control', 'Optimized', 'Random','E','Optimal', 'Optimal_misspecified', 'Optimized_misspecified'};
n= numel(Codes);
Naive= zeros(n,1);
Control= zeros(n,1);
Optimized= zeros(n,1);
Random= zeros(n,1);
E= zeros(n,1);
Optimal= zeros(n,1);
Optimal_misspecified = zeros(n,1);
Optimized_misspecified = zeros(n,1);
Ttraining = table(logical(Naive), logical(Control), logical(Optimized),  logical(Random), logical(E), logical(Optimal),logical(Optimal_misspecified),logical(Optimized_misspecified),...
          'VariableNames',Codes,...
          'RowNames',Codes);
Ttest = Ttraining;


Ttest('Optimized', :).Control = true;
Ttraining('Optimized', :).Control = true;

Ttest('Optimized', :).Naive = true;
Ttraining('Optimized', :).Naive = true;

Ttest('Random',:).Control = true;
Ttraining('Random',:).Control = true;

Ttest('Optimized',:).Random = true;
Ttraining('Optimized',:).Random = true;

Ttraining('E', :).Naive = true;
Ttraining('E', :).Control = true;

Ttest('Optimized',:).Optimal = true;
Ttraining('Optimized',:).Optimal = true;

Ttraining('Control',:).Naive = true;

Ttest('Optimized',:).E = true;
Ttraining('Optimized', :).E = true;

Ttraining('Optimized_misspecified', 'Optimal_misspecified') = true;
Ttraining('Optimized_misspecified', 'Control') = true;
Ttraining('Optimal_misspecified', 'Control') = true;
Ttraining('Optimized_misspecified', 'Optimized') = true;
