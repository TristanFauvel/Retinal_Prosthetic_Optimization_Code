T = load(data_table_file).T;
id = 1:size(T,1);
acquisition= 'maxvar_challenge';
id = id(T.Acquisition==acquisition & T.Misspecification == 0);
% id = id(T(id,:).Subject == 'BF');
N = numel(id);
for i = 1:N
    index = id(i);
%     subject_analysis(index,T);
    subject_analysis_to_delete(index,T); %%%%%%%%%%%%%%%%%%%%%%%%%

end

