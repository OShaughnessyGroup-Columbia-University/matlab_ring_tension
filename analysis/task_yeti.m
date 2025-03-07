% A small-sized ring for debugging purposes. Use old capture radii. Use Sathish�s get_a and get_m for comparison. 
function [] = task_yeti(itask)
% % make sure that the random function generator can give a different seed
% rng(itask)
% rng(randi(30000))
for i = 1:itask
    a = rand;
end
geometry = 'cyl'
if geometry == 'cyl'
    run_pos_z_cyl
elseif geometry == 'sph'
    run_pos_z_sph
elseif geometry == 'tes'
    test
    geometry = 'cyl';
end
parameters_v1
%% decide which file to load
a = dir;
% first part of the name of the file to load
prefix = 'test_';
suffix = 'min.mat';

for j = 0:1000
    for i = 1:size(a,1)
        if strcmp(a(i).name, strcat(prefix,num2str(itask),'_',num2str(j),suffix))
            found = true;
            break
        else
            found = false;
        end 
    end
    
    if ~found
        if j == 0
            save(strcat(prefix,num2str(itask),'_0',suffix))
        else
            loadj = j-1;
            break
        end
    end
end

clear j

%% run simulation
totaltime = 120; % ring radius divided by septation rate is 26 minutes  

for t = loadj:loadj + totaltime-1
    load(strcat(prefix,num2str(itask),'_',num2str(t),suffix))
    dt = .01;
    nstep = 100;      % one save per second
    equil_time_min = 10;
    real_t_min = t * dt * nstep / 60 - equil_time_min; % real time, in minutes
    real_t_min = 12;

    if real_t_min >=0
        [binding_rate_myo2, binding_rate_myp2, binding_rate_for, vpol, rsev] = modify_binding_rates(real_t_min, binding_rate_myo2_init, binding_rate_myp2_init, binding_rate_for_init, kofffor, r, r_ring, rhof, koffmyo);
        % septation rate (absolute value; defined as dr/dt; .07 micron / minute in Pelham and Chang)
        vs_abs = .07/60;
    end
    
    rk1_v2
    tsave = t+1;
    clear t
    save(strcat(prefix,num2str(itask),'_',num2str(tsave),suffix), 'real_t_min','rbead','rmyo','rmyp','ifor','ipt','bancf','bancm','xmat','fmmat','dbead_first','r','r_ring','fc','fanc','binding_rate_myo2','binding_rate_myp2','binding_rate_for','vpol','rsev')
    if r_ring < 0
        break
    end
end

% load('test_3_1min.mat')
% ringplot_pick
end