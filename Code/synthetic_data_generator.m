% EECS 545 - Final Project
% Training Data Synthesizer
%
% Created: 12.5.17
% 


%% Synthetic data synthesis (Support Class)
% Initialize simulation parameters
N = 90;                     % simulate a 3-month period
M = 4096;                   % number of synthetic stocks
support = rand();
synth_data_C1 = zeros(N,M);    % matrix of valid synthetic data
synth_cnt = 1;

price_mu = 0;
price_sigma = 1;
support_mu = 0;
support_sigma = 5;
    
while synth_cnt <= M
    price = zeros(1,N);         % single stock vector
    % Define Gauss parameters for choosing daily change and support value
    
    
    % generate initial price:
    price(1) = normrnd(price_mu,price_sigma);
    
    % Generate support value
    while price(1) < support
        support = normrnd(support_mu,support_sigma);
    end
    
    % Define the number of times it can hit the support
    support_hits = randi([3 8]);
    hit_cntr = 0;
    
    for n = 2:N
        % if the price is at the support, make it go back up
        if abs(price(n)-support) < 0.1
            price(n) = price(n-1) + abs(normrnd(price_mu,price_sigma));
            % if the price is above the support, let it do what it wants
        else
            price(n) = price(n-1) + normrnd(price_mu,price_sigma);
        end
        
        % check if new price went below the support, if so, set it to
        % approximately the support value. Also document how many times it hit
        % the support
        if price(n) < support && hit_cntr < support_hits
            price(n) = support;% + normrnd(0,0.001);
            hit_cntr = hit_cntr + 1;
        end
    end
%     fprintf('support hits: %.1d out of %.1d allowed\n',hit_cntr,support_hits)
%     plot(price)
    
    % save synthetic stock if it meets the desired parameters
    if hit_cntr >=2
        % Make stock prices all positive valued
        synth_data_C1(:,synth_cnt) = price+abs(min(price));
        synth_cnt = synth_cnt + 1;
        fprintf('%.1d synthetic stocks generated\n',synth_cnt-1)
    end
end
save(['synth_C1_',num2str(date()),'.mat'], 'synth_data_C1')
%% Show montage of the synthetic support class data
figure(1)
recurrence_data = zeros(N,N,1,M);
for i = 1:size(synth_data_C1,2)
    X = synth_data_C1(:,i)*synth_data_C1(:,i)';
    recurrence_data(:,:,1,i) = X;
end
q = quantile(recurrence_data(:),32);
montage(recurrence_data,...
    'Size',[sqrt(M) sqrt(M)],'DisplayRange',[0 q(end)])

%% Synthetic Data Generator (NO support class)

N = 90;                     % simulate a 3-month period
M = 4096;                   % number of synthetic stocks
synth_data_C2 = zeros(N,M);    % matrix of valid synthetic data
price_mu = 0;
price_sigma = 1;

for m = 1:M  
    price = zeros(1,N);         % single stock vector
    price(1) = normrnd(price_mu,price_sigma);

    for n = 2:N
        price(n) = price(n-1) + normrnd(price_mu,price_sigma);
    end
 
    % Make stock prices all positive valued
    synth_data_C2(:,m) = price+abs(min(price));
    fprintf('%.1d synthetic stocks generated\n',m)
end
save(['synth_C2_',num2str(date()),'.mat'], 'synth_data_C2')

%% Show montage of the synthetic non-support class data
figure(2)
recurrence_data = zeros(N,N,1,M);
for i = 1:size(synth_data_C2,2)
    X = synth_data_C2(:,i)*synth_data_C2(:,i)';
    recurrence_data(:,:,1,i) = X;
end
q = quantile(recurrence_data(:),32);
montage(recurrence_data,...
    'Size',[sqrt(M) sqrt(M)],'DisplayRange',[0 q(end)])























