function spC = spSum(spA,dim)
%SPSUM Sum sparse array structure over dimension 'dim'.
%
%   spC = spSum(spA,dim): Sum full array, represented as a sparse array
%   structure or a full array, over the dimension specified as a scalar in
%   'dim'. The output is a sparse array structure.
%
%   By Andrew J. Milne, The MARCS Institute, Western Sydney University
%
%   See also SPIND2SPSUB, SPSUB2SPIND, SPARSE, SUM.

% If full array, convert to sparse array structure
if ~isstruct(spA)
    spA = array2SpArray(spA);
end

sumDim = spA.Size;
if dim <= numel(spA.Size)
    sumDim(dim) = [];
end

subA = spInd2SpSub(spA); % get subscripts
subA(:,dim) = 1; % collapse over dim
indA = spSub2SpInd(spA.Size,subA); % convert to linear index
sumSpTerm = sparse(indA,1,spA.Val); % sum over repeated indices

[indA,~,valA] = find(sumSpTerm);
spC = struct('Size',sumDim,'Ind',indA,'Val',valA);

end

