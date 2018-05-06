function indC = spSub2spInd(siz,subsA)
%SPSUB2SPIND Convert subscripts into linear indices for an array of size 'siz'.
%
%   indC = spSub2spInd(siz,subsA)
%
%   By Andrew J. Milne, The MARCS Institute, Western Sydney University
%
%   See also SPIND2SPSUB, SUB2IND.

nDimA = numel(siz);
if size(subsA,2) ~= nDimA
    error('Numbers of dimensions of ''siz'' and the array must be identical')
end

mult = cumprod(siz);
mult = [1 mult(1 : nDimA-1)];
indC = (subsA-1)*mult' + 1;

end

