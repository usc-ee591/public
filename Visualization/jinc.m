function f = jinc(r)
%
% jinc:
%  Matlab function to evaluate the 'jinc' function:
%      jinc(r) = J_1(pi r) / (2r)
%  where J_1 is the Bessel function of the first kind, order 1.
%
% Inputs:
%  r  = values for which the jinc is to be evaluated
%
% Outputs:
%  f  = jinc function evaluated at each value specified in r
%
% Timothy Schulz
% EE3190, Fall 2005
% October 5, 2005
%

%
% first, determine where r is not equal to zero
%
mask = (r~=0);

%
% initialize the result to the value of the jinc at r=0 (pi/4)
%
f   = (pi/4)*ones(size(r));

%
% assign values everywhere that r is not equal to zero
%
f(mask) = besselj(1, pi*r(mask))./(2*r(mask));

return;

