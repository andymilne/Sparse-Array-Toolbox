function spC = spTrunc(lo,hi,spA)
%SPTRUNC Truncate a sparse array structure.
%   spC = spTrunc(limits,spA): Truncate a sparse array, represented as a sparse
%   array structure or a full array, so all entries with subscripts lower than
%   the corresponding entries in the row vector 'lo', and higher than the
%   corresponding entries in the row vector 'hi' are removed. The output is
%   sparse array structure with size hi-lo+1.
%
%   Version 1.0 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-09

if nargin ~= 3
    error('Three arguments are required.')
end
if size(lo,1)>1 || size(hi,1)>1
    error('''lo'' and ''hi'' must be row vectors.')
end
% If full array, make into sparse array structure
if ~isstruct(spA)
    spA = array2spArray(spA);
end
if numel(lo) ~= numel(spA.Size) || numel(hi) ~= numel(spA.Size)
    error('''lo'' and ''hi'' must have the same number of entries as dimensions in the sparse array structure.')
end

subsA = spInd2spSub(spA);

dimC = hi-lo+1;
valC = spA.Val;
subsC = subsA;

valC = valC(all(subsC>=lo & subsC<=hi,2),:);
subsC = subsC(all(subsC>=lo & subsC<=hi,2),:);
subsC = subsC - lo + 1;

% convert subsC to linear index for array of size dimC
if isempty(subsC)
    warning('All array entries have been truncated.')
    indC = [];
    valC = [];
else
    indC = spSub2spInd(dimC,subsC);
end
% Make the sparse array structure
spC = struct('Size',dimC,'Ind',indC,'Val',valC);
