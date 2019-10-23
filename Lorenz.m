% PROGRAM NAME: ps4huggett.m
clear, clc

% ASSET VECTOR
a_lo = -2; %lower bound of grid points
a_hi = 5;%upper bound of grid points
num_a = 100;

a = linspace(a_lo, a_hi, num_a); % asset (row) vector
% e.g: y = linspace(x1,x2,n) generates n points evenly b/w x1 and x2

%% Plot the Lorenz curves
b = 0.5; 
w_e=a+1;
w_u=a+b;
w= [w_e w_u].*Mu(:)';
% calculate the cumulative share of iwealth
a1=sort(w); 
a2=a1(a1(:,1)>=0);
a3=cumsum(a2);
a4=a3/sum(a2);
% calculate the cumulative share of people from lowest to highest incomes
a5=[1:length(a2)]';
a6=a5/length(a5);

plot(a6,a4);
xlabel("Cumulative share of people from lowest to highest wealth");
ylabel("Cumulative share of wealth");
title("the Lorenz curve");
hold on;

