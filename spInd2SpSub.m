function subsA = spInd2SpSub(spA)
%SPIND2SPSUB Convert a sparse array's linear index into a matrix of subscripts.
%
%   subsA = spInd2spSub(spA)
%
%   By Andrew J. Milne, The MARCS Institute, Western Sydney University
%
%   See also spSub2SpInd, spSub4Sp, ind2sub, sub2ind.

% Convert spA's linear index to subscripts
nDimA = numel(spA.Size);
if nDimA == 1
    subsA = spA.Ind;
else
    cellSubA = cell(1,nDimA); % create empty cell for next line
    [cellSubA{:}] = ind2sub(spA.Size,spA.Ind);
    subsA = [cellSubA{:}];
end

end

