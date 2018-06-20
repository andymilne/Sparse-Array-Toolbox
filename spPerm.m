function spC = spPerm(spA,order)
%SPPERM Permute dimensions of sparse array structure.
%
%   spC = spPerm(spA,order): Permute the dimensions of the full array
%   represented as a sparse array structure or a full array. The second
%   argument is the vector of permutations. The output is a sparse array
%   structure.
%
%   By Andrew J. Milne, The MARCS Institute, Western Sydney University
%
%   See also SPIND2SPSUB, SPSUB2SPIND, PERMUTE.

% If full array, convert to sparse array structure
if ~isstruct(spA)
    spA = array2SpArray(spA);
end

subA = spInd2SpSub(spA); % Get subscripts
subAPerm = subA(:,order); % Permute subscripts
indA = spSub2SpInd(spA.Size,subAPerm); % convert subs to linear index

spC = struct('Size',spA.Size,'Ind',indA,'Val',spA.Val);

end