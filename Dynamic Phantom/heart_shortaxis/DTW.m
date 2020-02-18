% alignedtest = DTW(reference,test)
%
% 1D arrar warping, is based on DTW
% Inputs:
%   reference:  1D series
%   test:       1D series
% Output:
%   alignedtest: re-ordered test, to match the shape of reference
%   OptPath:    the optional path on the cost matrix
%
% ZYH, 10/14/2010
% ZYH, 02/01/2012: add comments

function [alignedtest, OptPath] = DTW(reference,test)

N = length(reference);
M = length(test);
d = zeros(N,M);

% difference matrix
for n = 1:N
   for m = 1:M
       d(n,m) = abs(reference(n)-test(m));
   end
end

% cost matrix
D=zeros(size(d));
D(1,1)=d(1,1);

% fill the cost matrix
for n=2:N
    D(n,1)=d(n,1)+D(n-1,1);
end
for m=2:M
    D(1,m)=d(1,m)+D(1,m-1);
end
for n=2:N
    for m=2:M
        D(n,m)=d(n,m)+min(min(D(n-1,m-1),D(n,m-1)),D(n-1,m));
    end
end

n = N;
m = M;
OptPath = [N,M];

% back-track the optimal path
while ((n+m)~=2)
    if n == 1       % boundary case
        m = m-1;
    elseif m == 1   % boundary case
        n = n-1;
    else 
      [value,number]=min([D(n-1,m-1), D(n-1,m), D(n,m-1)]);
      switch number
      case 1
        n = n-1;
        m = m-1;
      case 2
        n = n-1;
      case 3
        m = m-1;
      end
    end
    OptPath = cat(1, [n,m], OptPath);
end

alignedtest = zeros(N, 1);

for n = 1:N
    index = find(OptPath(:,1) == n);    % locate in reference series
    alignedtest(n) = test(round(mean(OptPath(index, 2))));  % find the match
end