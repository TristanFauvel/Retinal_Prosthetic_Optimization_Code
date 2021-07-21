
Name = [];
Seeds = [];
subject_table = table(Name, Seeds);


Name = {'TF', 'OM', 'MC', 'SF', 'SG', 'BL', 'FT', 'MS', 'FF'};

n_specific_seed = 3;
n_common_seed = 1;
common_seeds = 1:n_common_seed;
Seeds = (1+n_common_seed):(n_common_seed+numel(Name)*n_specific_seed);

Seeds = reshape(Seeds, n_specific_seed,numel(Name))';
Seeds = [Seeds,repmat(common_seeds,numel(Name),1)]; 

%%%%%%%%%%
Seeds = Seeds(:,1);
%%%%%%%%%%
for i =1:numel(Name)
    subject_table = [subject_table; Name(i), Seeds(i,:)];
end
save('subject_seeds_table.mat', 'subject_table')