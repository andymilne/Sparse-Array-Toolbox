function spC = spPerm(spA,order)
%SPPERM Permute dimensions of sparse array structure.
%   spC = spPerm(spA,order): Permute the dimensions of the full array
%   represented as a sparse array structure. The second argument is the vector
%   of permutations. The output is a sparse array structure.
%
%   Version 1.0 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-09
%
%   See also SPIND2SPSUB, SPSUB2SPIND. 

subA = spInd2spSub(spA); % Get subscripts
subAPerm = subA(:,order); % Permute subscripts
indA = spSub2spInd(spA.Size,subAPerm); % convert subs to linear index

spC = struct('Size',spA.Size,'Ind',indA,'Val',spA.Val);

end