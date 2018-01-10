function d = spPDist(spA,spB,p)
%PDIST p-norm distance between two sparse array structures.
%   d = spPDist(spA,spB,p): The p-norm distance between two vectorized full
%   arrays, represented as sparse array structures, with same numbers of
%   entries. When there are only two arguments, p = 2 is the default, which
%   gives the Euclidean distance between the two vectors; when p = 1, this
%   function gives the taxicab distance; when p = inf, it gives the maximum
%   difference.
%
%   Version 1.0 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-09
% 
%   See also SPCOSSIM.

if ~isstruct(spA) || ~isstruct(spB)
    error('Arguments must be (a cell array of) sparse array structures.')
end
    
spDiff = spSum(spA,spScale(-1,spB)); 
diff = spDiff.Val;

% Calculate their p-norm distance
d = sum(abs(diff.^p))^(1/p);

end
