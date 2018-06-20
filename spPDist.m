function d = spPDist(spA,spB,p)
%PDIST p-norm distance between two sparse array structures.
%
%   d = spPDist(spA,spB,p): The p-norm distance between two vectorized full
%   arrays, each represented as a sparse array structure or as a full array.
%   They must have the same numbers of entries (including zeros). When there
%   are only two arguments, p = 2 is the default, which gives the Euclidean
%   distance between the two vectors; when p = 1, this function gives the
%   taxicab distance; when p = inf, it gives the maximum difference.
%
%   By Andrew J. Milne, The MARCS Institute, Western Sydney University
% 
%   See also SPCOSSIM.

if nargin < 3
    p = 2;
end
if nargin < 2
    error(['There must be exactly two arguments (arrays or sparse array ', ...
           'structures).'])
end

% Convert full array arguments to sparse array structures
if ~isstruct(spA)
    spA = array2SpArray(spA);
end
if ~isstruct(spB)
    spB = array2SpArray(spB);
end
    
spDiff = spPlus(spA,spTimes(-1,spB)); 
diff = spDiff.Val;

% Calculate their p-norm distance
d = sum(abs(diff.^p))^(1/p);

end
