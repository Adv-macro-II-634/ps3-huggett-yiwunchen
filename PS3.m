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
num_a = 100;

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
      v_mat=ret+beta*repmat(permute(PI*v_guess, [3 2 1]),[num_a 1 1]);
      
      % CHOOSE HIGHEST VALUE (ASSOCIATED WITH a' CHOICE)
      % find the optimal a' for every a:
      [vfn, pol_indx] = max(v_mat, [], 2);
      
      vfn=permute(vfn,[3 1 2]);
      
      v_tol=abs(max(v_guess(:)-vfn(:)));
      
      v_guess = vfn;
      
    end;
    
    % KEEP DECSISION RULE
    pol_indx=permute(pol_indx, [3 1 2]);
    pol_fn = a(pol_indx);
    
    % SET UP INITITAL DISTRIBUTION
    Mu=zeros(2,num_a);
    Mu(1,4)=1;
     
    % ITERATE OVER DISTRIBUTIONS
    mu_tol=1;
    while mu_tol>1e-08
      [emp_ind, a_ind, mass] = find(Mu > 0); % find non-zero indices
    
      MuNew = zeros(size(Mu));
      for ii = 1:length(emp_ind)
        apr_ind = pol_indx(emp_ind(ii), a_ind(ii)); % which a prime does the policy fn prescribe?
        MuNew(:, apr_ind) = MuNew(:, apr_ind) + ... % which mass of households goes to which exogenous state?
            (PI(emp_ind(ii), :) *Mu(emp_ind(ii), a_ind(ii)))';
      end
    
      mu_tol=max(abs(MuNew(:)-Mu(:)));
    
      Mu=MuNew;
 
   end

   plot(Mu');

   x=sum(sum(Mu.*pol_fn));%mkt clearing condition
   if x>= 0.1
     q_min = (q_min + q_max) / 2;
   else
     q_max = (q_min + q_max) / 2;

   end
    
    q_guess=(q_min + q_max)/2;
   
       
end