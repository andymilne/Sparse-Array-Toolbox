function s = spCosSim(spA,spB)
%SPCOSSIM Cosine similarity of two sparse array structures
%   s = spCosSim(spA,spB):  Cosine similarity of two vectorized full arrays,
%   represented by sparse array structures, with the same numbers of entries.
%
%   Version 1.0 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-09
%
%   See also SPPDIST.

persistent ipAA ipBB spALast spBLast

if ~isstruct(spA) || ~isstruct(spB)
    error('Arguments must be (a cell array of) sparse array structures.')
end

if nargin ~= 2
    error('There must be exactly two sparse array structures.')
end

spANew = ~isequal(spA,spALast);
spBNew = ~isequal(spB,spBLast);
if spANew
    ipAA = spInner(spA,spA);
end
if spBNew
    ipBB = spInner(spB,spB);
end
s = spInner(spA,spB)/sqrt(ipAA*ipBB);

spALast = spA;
spBLast = spB;

end