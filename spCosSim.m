function s = spCosSim(spA,spB)
%SPCOSSIM Cosine similarity of two sparse array structures
%
%   s = spCosSim(spA,spB):  Cosine similarity of two vectorized full arrays,
%   each represented as a sparse array structure or as a full array. They must
%   have the same numbers of entries (including zeros). The output is a scalar.
%
%   By Andrew J. Milne, The MARCS Institute, Western Sydney University
%
%   See also SPPDIST.

persistent innerAA innerBB spALast spBLast

if nargin ~= 2
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

spANew = ~isequal(spA,spALast);
spBNew = ~isequal(spB,spBLast);
if spANew
    innerAA = spInner(spA,spA);
end
if spBNew
    innerBB = spInner(spB,spB);
end
s = spInner(spA,spB)/sqrt(innerAA*innerBB);

spALast = spA;
spBLast = spB;

end