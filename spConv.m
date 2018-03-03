function spC = spConv(spA,spB,shape)
%SPCONV N-dimensional convolution of two N-dimensional sparse array structures.
%   spC = spConv(spA,spB,shape): N-dimensional convolution of two N-dimensional
%   full arrays, each represented as a sparse array structure or a full array.
%   The output is a sparse array structure.
%
%   shape == 'full': full convolution (default). Its size is the sum of the
%   sizes of its arguments.
%
%   shape == 'same': central part of the convolution, same size as spA.
%
%   shape == 'circ': circular convolution over the size of spA.
%
%   By Andrew J. Milne, The MARCS Institute, Western Sydney University
%
%   See also SPIND2SPSUB, SPSUB2SPIND, SPARSE, CONVN, CCONV.

if nargin < 3
    shape = 'full';
end

% Convert full array arguments to sparse array structures
if ~isstruct(spA)
    spA = array2spArray(spA);
end
if ~isstruct(spB)
    spB = array2spArray(spB);
end

% Get numbers of dimensions in spA and spB
nDimA = size(spA.Size,2);
nDimB = size(spB.Size,2);
if nDimA ~= nDimB
    error('The two arrays must have the same numbers of dimensions.')
end

%% Convert indices to those of an array of size spA.Size+spB.Size-1
sizC = spA.Size+spB.Size-1;
% Convert linear indices to subscripts
subsA = spInd2spSub(spA);
subsB = spInd2spSub(spB);
% Convert subscripts back to a linear indices, but taking the size
% of the array to be the same as spA + spB - 1 (in non-sparse terms,
% this is zero padding)
indASzC = spSub2spInd(sizC,subsA);
indBSzC = spSub2spInd(sizC,subsB);

% Do the convolution
indC = indASzC + indBSzC' - 1; % Outer sum of indices, minus 1
indC = indC(:);
valC = spA.Val.*spB.Val'; % Outer product of values
valC = valC(:);
sparseC = sparse(indC,1,valC); % Accumulate (sum) over repeated indices

% Make sparse array structure for full convolution
[indC,~,valC] = find(sparseC);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spC = struct('Size',sizC,'Ind',indC,'Val',valC);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isequal(shape,'same') % Remove entries outside size A
    % Convert linear indices of spC to subs
    subsC = spInd2spSub(spC);
    % Remove subsC outside sizeA
    subsCTrunc = subsC;
    indCTrunc = all(subsCTrunc<=spA.Size,2);
    valC = valC(indCTrunc,:);
    subsCTrunc = subsCTrunc(indCTrunc,:);
    % convert subsCTrunc to linear index for array of size spA.Size
    indC = spSub2spInd(spA.Size,subsCTrunc);
    % Make into a sparse array structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    spC = struct('Size',spA.Size,'Ind',indC,'Val',valC);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif isequal(shape,'circ') % Wrap entries around size A
    % Convert linear indices of spC to subs
    subsC = spInd2spSub(spC);
    % Wrap subsC over sizeA
    subsCWrap = mod(subsC-1,spA.Size) + 1;
    % Convert wrapped subsC to linear index for size A
    indC = spSub2spInd(spA.Size,subsCWrap);
    % Accumulate (sum) over repeated indices
    sparseC = sparse(indC,1,valC);
    % Make into a sparse array structure
    [indC,~,valC] = find(sparseC);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    spC = struct('Size',spA.Size,'Ind',indC,'Val',valC);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

end
