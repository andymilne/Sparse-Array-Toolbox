function spC = spTol(spA,tol)
%SPTOL Make all entries with magnitudes smaller than 'tol' equal to zero.
%   spC = spTol(spA,tol): Make all entries of a full array (represented as a
%   sparse array structure or a full array) with magnitudes smaller than 'tol'
%   equal to zero. The output is a sparse array structure
%
%   Version 1.0 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-16
%
%   See also SPTRUNC.

% If full array, convert to sparse array structure
if ~isstruct(spA)
    spA = array2spArray(spA);
end

indA = spA.Ind(abs(spA.Val-0)>tol);
valA = spA.Val(abs(spA.Val-0)>tol);

% Make the sparse aray structure
spC = struct('Size',spA.Size,'Ind',indA,'Val',valA);

end

