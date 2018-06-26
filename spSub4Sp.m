function a = spSub4Sp(spA,subs)
%SPSUB4SP Use subscripts to access entries in a sparse array structure.
%
%   By Andrew J. Milne, The MARCS Institute, Western Sydney University
%
%   See also: spSub2spInd, spInd2Sub, sub2ind, ind2sub.

if ~isequal(numel(spA.Size), numel(subs))
    error(['The subscripts vector must have the same number of entries as' ... 
           'the sparse array has dimensions'])
end

index = spSub2SpInd(spA.Size, subs);
indexLoc = spA.Ind == index;

a = spA.Val(indexLoc);

end
