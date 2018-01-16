function spC = spFlip(spA,dim)
%SPFLIP Flip order of entries in dimensions specified in 'dim'.
%   spC = spFlip(spA,dim): Flip the order of entries of the full array,
%   represented as a sparse array structure or full array, in the dimensions
%   specified in the row vector or scalar 'dim'. The output is a sparse array
%   structure.
%
%   Version 1.0 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-16
%
%   See also FLIP.

% If full array, convert to sparse array structure
if nargin < 2
    error('Two arguments are required.')
end
if ~isstruct(spA)
    spA = array2spArray(spA);
end
if any(dim<1)
    error('All entries in ''dim'' must be positive integers.')
end

nDimA = numel(spA.Size);
dim(dim>nDimA) = [];
dim = unique(dim);
if numel(dim) == nDimA
    % simpler calculation if all dimensions are flipped
    indA = prod(spA.Size) - spA.Ind + 1;
else
    logDim = zeros(1,nDimA);
    % vector of 1s for flips and 0s for no flips
    logDim(dim) = 1;
    % vector of 1s for flips and -1s for no flips
    mult = logDim;
    mult(logDim==0) = -1;
    % convert to subs
    subA = spInd2spSub(spA);
    % do the flips
    flipSubA = (logDim.*spA.Size - subA + logDim).*mult;
    % convert to linearindex
    indA = spSub2spInd(spA.Size,flipSubA);
end

% Make the sparse array structure
spC = struct('Size',spA.Size,'Ind',indA,'Val',spA.Val);

end

