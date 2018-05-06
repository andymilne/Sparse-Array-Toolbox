function spC = spTimes(varargin)
%SPTIMES Entrywise product of sparse array structures and/or scalars.
%
%   spC = spTimes(varargin): Entrywise (Hadamard) product of full arrays and/or
%   scalars, each represented as a sparse array structure or a full arrays The
%   arrays and scalars can be entered as a comma separated list or as a members
%   of a cell. The output is a sparse array structure.
%
%   By Andrew J. Milne, The MARCS Institute, Western Sydney University
%
%   See also TIMES.

% Check whether varargin is a comma separated list or a cell array
if ~iscell(varargin{1})
    spA = varargin;
elseif iscell(varargin{1})
    spA = varargin{:};
end
nSpA = size(spA,2); % count the number of arguments

if nSpA <2
    error('There must be more than one sparse array or scalar.')
end

% Find scalars' positions, number, and product
scalProd = 1;
nScalars = 0;
lgclIndScalars = false(nSpA,1);
for i = 1:nSpA
    if ~isstruct(spA{i}) && isscalar(spA{i})
        scalProd = scalProd*spA{i};
        lgclIndScalars(i) = true;
        nScalars = nScalars + 1;
        continue
    end
end

% Remove all scalars (if all entries are scalars return their product) 
if nScalars == nSpA
    spC = struct('Size',[],'Ind',1,'Val',scalProd);
    return
end
spA(lgclIndScalars) = [];
nSpA = nSpA - nScalars;

% Convert remaining (nonscalar) full array arguments to sparse array structures
for i = 1:nSpA
    if ~isstruct(spA{i})
        spA{i} = array2spArray(spA{i});
    end
end

% Check remaining (nonscalar) arrays have equivalent sizes
if nSpA > 1
    for i = 2:nSpA
        sizA = spA{i}.Size;
        sizAprev = spA{i-1}.Size;
        if sizA ~= sizAprev
            error('The sizes of the original full arrays must be equal.')
        end
    end
end

% Find common indices across input arrays
comInd = spA{1}.Ind;
for i = 2:nSpA
    comInd = intersect(comInd,spA{i}.Ind);
end
% Multiply over common indices
valC = scalProd;
for i = 1:nSpA
    lgclComInd = ismember(spA{i}.Ind(:),comInd);
    valC = valC.*spA{i}.Val(lgclComInd);
end

% Make sparse array structure
spC = struct('Size',spA{1}.Size,'Ind',comInd,'Val',valC);

end
