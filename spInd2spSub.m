function subsA = spInd2spSub(spA)
%SPIND2SPSUB Convert a sparse array's linear index into a matrix of subscripts. 
%
%   subsA = spInd2spSub(spA)
%
%   By Andrew J. Milne, The MARCS Institute, Western Sydney University
%   
%   See also SPSUB2SPIND, IND2SUB.

% Convert spA's linear index to subscripts
nDimA = numel(spA.Size);
cellSubA = cell(1,nDimA); % create empty cell for next line
[cellSubA{:}] = ind2sub(spA.Size,spA.Ind);
subsA = [cellSubA{:}];

end

