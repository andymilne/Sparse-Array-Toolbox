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
for i = 2:nSpA
    sizA = spA{i}.Size;
    sizAprev = spA{i-1}.Size;
    if sizA ~= sizAprev
        error('All full arrays must have the same size.')
    end
end

% Concatenate indices and values from all sparse arrays
indSpCell = cell(1,nSpA);
valSpCell = cell(1,nSpA);
for i = 1:nSpA
    indSpCell{i} = spA{i}.Ind;
    valSpCell{i} = spA{i}.Val;
end
indSpCat = cat(1,indSpCell{:});
valSpCat = cat(1,valSpCell{:});
% Accumulate (sum) across all repeated indices
sumSpSpA = sparse(indSpCat,1,valSpCat); 

% Return sparse array
[indA,~,valA] = find(sumSpSpA);
spC = struct('Size',sizA,'Ind',indA,'Val',valA);

end
