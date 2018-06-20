function spC = spPlus(varargin)
%SPPLUS The sum of sparse array strucures with equivalent size
%
%   spC = spPlus(varargin): The sum of identically sized full arrays, each
%   represented as a sparse array structure or a full array. The sparse
%   arrays can entered as a comma separated list or as a members of a cell. The
%   output is a sparse array structure.
%
%   By Andrew J. Milne, The MARCS Institute, Western Sydney University
%
%   See also SPARSE, PLUS.

% Check whether varargin is a list of structures (e.g., sparse arrays) or a 
% cell array of structures.
if isstruct(varargin{1})
    spA = varargin;
else
    spA = varargin{:};
end
nSpA = size(spA,2); % count the number of arguments

% Convert full array arguments to sparse array structures
for i = 1:nSpA
    if ~isstruct(spA{i})
        spA{i} = array2SpArray(spA{i});
    end
end

% Check all arrays have equivalent size and get their numbers of indices
for i = 2:nSpA
    sizA = spA{i}.Size;
    sizAprev = spA{i-1}.Size;
    if ~isequal(sizA,sizAprev)
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
