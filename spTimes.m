function spC = spTimes(varargin)
%SPTIMES Entrywise product of sparse array structures and/or scalars.
%   spC = spTimes(varargin): Entrywise (Hadamard) product of full arrays and/or
%   scalars, the former represented as sparse array structures. The arrays and
%   scalars can be entered as a comma separated list or as a members of a cell.
%   The output is a sparse array structure.
%
%   Version 1.0 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-09

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
logIndScalars = false(nSpA,1);
for i = 1:nSpA
    if ~isstruct(spA{i}) && isscalar(spA{i})
        scalProd = scalProd*spA{i};
        logIndScalars(i) = true;
        nScalars = nScalars + 1;
        continue
    end
end
%logIndScalars

if nScalars == nSpA
    spC = struct('Size',[],'Ind',1,'Val',scalProd);
    return
end
spA(logIndScalars) = [];
nSpA = nSpA - nScalars;

% Convert remaining (nonscalar) full array arguments to spare array structures
for i = 1:nSpA
    if ~isstruct(spA{i})
        spA{i} = array2spArray(spA{i})
    end
end

% Check all arrays have equivalent size
for i = 2:nSpA
    sizA = spA{i}.Size;
    sizAprev = spA{i-1}.Size;
    if sizA ~= sizAprev
        error('The sizes of the original full arrays must be equal.')
    end
end

% Find common indices and multiply their respective values
indC = spA{1}.Ind;
valC = scalProd;
for i = 1:nSpA
    [~,Locb] = ismember(indC,spA{i}.Ind);
    indC = Locb(Locb>0);
    valC = valC.*spA{i}.Val(indC);
end

% Make the sparse array structure
spC = struct('Size',spA{1}.Size,'Ind',indC,'Val',valC);

end
