function spC = spPlus(varargin)
%SPPLUS The sum of sparse array strucures with equivalent size
%   spC = spPlus(varargin): The sum of identically sized full arrays,
%   each represented as a sparse array structure. The sparse arrays can
%   entered as a comma separated list or as a members of a cell. The output is
%   a sparse array structure.
%
%   Version 1.01 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-13
%
%   See also SPARSE.

% Check whether varargin is a list of structures (e.g., sparse arrays) or a 
% cell array of structures.
if isstruct(varargin{1})
    spA = varargin;
else
    spA = varargin{:};
end
nSpA = size(spA,2); % count the number of arguments

% Check all arrays have equivalent size and get their numbers of indices
nInd = nan(nSpA,1);
nInd(1) = numel(spA{1}.Ind);
for i = 2:nSpA
    sizA = spA{i}.Size;
    sizAprev = spA{i-1}.Size;
    if sizA ~= sizAprev
        error('All full arrays must have the same size.')
    end
    nInd(i) = numel(spA{i}.Ind);
end
cumSumInd = [0;cumsum(nInd)];

% Concatenate indices and values from all sparse arrays
indSpCat = zeros(cumSumInd(end),1);
valSpCat = zeros(cumSumInd(end),1);
for i = 1:nSpA
    indSpCat(cumSumInd(i)+1:cumSumInd(i+1)) = spA{i}.Ind;
    valSpCat(cumSumInd(i)+1:cumSumInd(i+1)) = spA{i}.Val;
end
% Accumulate (sum) across all repeated indices
sumSpSpA = sparse(indSpCat,1,valSpCat); 

% Return sparse array
[indA,~,valA] = find(sumSpSpA);
spC = struct('Size',sizA,'Ind',indA,'Val',valA);

end
