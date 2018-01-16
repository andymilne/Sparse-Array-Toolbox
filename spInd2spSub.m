function subsA = spInd2spSub(spA)
%SPIND2SPSUB Convert a sparse array's linear index into a matrix of subscripts. 
%
%   Version 1.0 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-09
%   
%   See also SPSUB2SPIND, IND2SUB.

% Convert spA's linear index to subscripts
nDimA = numel(spA.Size);
cellSubA = cell(1,nDimA); % create empty cell for next line
[cellSubA{:}] = ind2sub(spA.Size,spA.Ind);
subsA = [cellSubA{:}];

end

