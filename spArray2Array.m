function A = spArray2Array(spA)
%SPARRAY2ARRAY Convert a sparse array structure into a full array. 
%
%   Version 1.0 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-09
%   
%   See also ARRAY2SPARRAY.

if max(spA.Ind) > prod(spA.Size)
    error('The index exceeds the designated size of the array.')
end

if numel(spA.Size)>1
    A = zeros(spA.Size);
else
    A = zeros(spA.Size,1);
end
A(spA.Ind) = spA.Val;

end
