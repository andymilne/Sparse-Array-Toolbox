function c = spInner(varargin)
%SPINNER Inner (scalar) product of two sparse array strucures.
%   c = spInner(varargin): Inner (scalar) product of two full arrays
%   represented by sparse array structures. There are alternative definitions
%   of 'inner product' for tensors/arrays. Here, it is their scalar product --
%   the sum of entries resulting from their entrywise (Hadamard) product. The
%   sparse arrays can entered as a comma separated list or as a members of a
%   cell.
%
%   Version 1.0 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-09

% Check whether varargin is a comma separated list or a cell array
if ~iscell(varargin{1})
    spA = varargin;
elseif iscell(varargin{1})
    spA = varargin{:};
else
    error('Arguments must be (a cell array of) sparse array structures.')
end
nSpA = size(spA,2); % count the number of arrays

if nSpA ~= 2
    error('There must be exactly two sparse array structures.')
end

% Check both sparse array strucures have the same numbers of elements 
if prod(spA{1}.Size) ~= prod(spA{2}.Size)
    error('Both full arrays must have the same number of entries.')
end

spC = spTimes(spA{1},spA{2});
c = sum(spC.Ind);

end
