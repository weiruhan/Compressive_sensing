% IMPORT DATA

ideal=textread("sort_desired_r_c.txt"); % ideal spectrum 7 ideal spectrums
basis=textread("sort_loaded_basis.txt"); % 32 basis each with 951*1
ideal = ideal(:,2:8);
basis = basis(:,2:33);

% PEAK LOCATION
[~,location] = max(ideal); % [157,223,267,325,395,493,595]





  



    




