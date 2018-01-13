function spC = spSum(spA,dim)
%SPSUM Sum sparse array structure over dimension 'dim'.
%   spC = spSum(spA,dim): Sum full array, represented as a sparse array
%   structure, over the dimension specified as a scalar in 'dim'. The output is
%   a sparse array structure.
%
%   Version 1.0 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-09
%
%   See also SPIND2SPSUB, SPSUB2SPIND, SPARSE.

sumDim = spA.Size;
if dim <= numel(spA.Size)
    sumDim(dim) = [];
end

subA = spInd2spSub(spA); % get subscripts
subA(:,dim) = 1; % collapse over dim
indA = spSub2spInd(spA.Size,subA); % convert to linear index
sumSpTerm = sparse(indA,1,spA.Val); % sum over repeated indices

[indA,~,valA] = find(sumSpTerm);
spC = struct('Size',sumDim,'Ind',indA,'Val',valA);

end

