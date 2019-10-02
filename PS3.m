% PROGRAM NAME: ps4huggett.m
clear, clc

% PARAMETERS
beta = .9932; % discount factor 
sigma = 1.5; % coefficient of risk aversion
b = 0.5; % replacement ratio (unemployment benefits)
y_s = [1, b]; % endowment in employment states
PI = [.97 .03; .5 .5]; % transition matrix


% ASSET VECTOR
a_lo = -2; %lower bound of grid points
a_hi = 5;%upper bound of grid points
num_a = 10;

a = linspace(a_lo, a_hi, num_a); % asset (row) vector
% e.g: y = linspace(x1,x2,n) generates n points evenly b/w x1 and x2

a_mat = repmat(a', [1 num_a]);

% INITIAL GUESS FOR q
q_min = 0.98;
q_max = 1;
q_guess = (q_min + q_max) / 2;



% ITERATE OVER ASSET PRICES
aggsav = 1 ;
while abs(aggsav) >= 0.01 ;
    
    % CURRENT RETURN (UTILITY) FUNCTION
    cons = bsxfun(@minus, a', q_guess * a); % a'-q_guess*a
    cons = bsxfun(@plus, cons, permute(y_s, [1 3 2])); %y_s+cons
    ret = (cons .^ (1-sigma)) ./ (1 - sigma); % current period utility
    
    % INITIAL VALUE FUNCTION GUESS
    v_guess = zeros(2, num_a);
    
    % VALUE FUNCTION ITERATION
    v_tol = 1;
    while v_tol >.0001;
      % CONSTRUCT RETURN + EXPECTED CONTINUATION VALUE
      % CHOOSE HIGHEST VALUE (ASSOCIATED WITH a' CHOICE)
        
      % compute the utility value for all possible combinations of a and a'
      value_mat = ret + beta * repmat(PI(1,:)*v_guess, [num_a 1]);
      
      % find the optimal k' for every k:
      [vfn, pol_indx] = max(value_mat, [], 2);
      
      vfn=[vfn(:,:,1)';vfn(:,:,2)'];
      
      % what is the distance between current guess and value function
      v_tol = max(abs(vfn - v_guess));
      
      % if distance is larger than tolerance, update current guess and
      % continue, otherwise exit the loop
      v_guess = vfn;
      
      
        
  
    end;
    
    % KEEP DECSISION RULE
    pol_fn = a(pol_indx);
    
    % SET UP INITITAL DISTRIBUTION

    
    % ITERATE OVER DISTRIBUTIONS
    [emp_ind, a_ind, mass] = find(Mu > 0); % find non-zero indices
    
    MuNew = zeros(size(Mu));
    for ii = 1:length(emp_ind)
        apr_ind = pol_indx(emp_ind(ii), a_ind(ii)); % which a prime does the policy fn prescribe?
        MuNew(:, apr_ind) = MuNew(:, apr_ind) + ... % which mass of households goes to which exogenous state?
            (PI(emp_ind(ii), :) * mass)';
    end
 
        
end