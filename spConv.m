function spC = spConv(spA,spB,shape)
%SPCONV N-dimensional convolution of two N-dimensional sparse array structures.
%   spC = spConv(spA,spB,shape): N-dimensional convolution of two N-dimensional
%   full arrays, each represented as a sparse array structure or a full array.
%   structures.
%
%   shape == 'full': full convolution (default). Its size is the sum of the
%   sizes of its arguments.
%
%   shape == 'same': central part of the convolution, same size as spA.
%
%   shape == 'circ': circular convolution over the size of spA.
%
%   Version 1.0 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-09
%
%   See also SPIND2SPSUB, SPSUB2SPIND, SPARSE.

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

% Convert spB's linear index to subscripts
subsB = spInd2spSub(spB);

% Convert spB's subscripts back to a linear index, but taking the size of the
% array to be the same as spA (in non-sparse terms, this is zero padding)
indBSzA = spSub2spInd(spA.Size,subsB);

% Do the convolution
indCSizA = spA.Ind + indBSzA' - 1;
indCSizA = indCSizA(:);
valC = spA.Val.*spB.Val';
valC = valC(:);
sparseC = sparse(indCSizA,1,valC); % Accumulate (sum) over repeated indices

% Convert linear indices to subs for an array of size A
[indCSizA,~,valC] = find(sparseC);
spC = struct('Size',spA.Size,'Ind',indCSizA,'Val',valC);
subsC = spInd2spSub(spC);

% If 'shape' is 'full', convert subsC to linear indices for array of 
% size A + size B - 1
if isequal(shape,'full')
    % Convert subsC to linear indices for array of size A + size B - 1
    indCSizAB = spSub2spInd(spA.Size+spB.Size-1, subsC);
    % Make into a sparse array structure
    spC = struct('Size',spA.Size+spB.Size-1,'Ind',indCSizAB,'Val',valC);
    
% If 'shape' is 'circ', all spC's subs outside spA's size are wrapped
elseif isequal(shape,'circ')
    % Wrap subsC outside sizeA
    subsCWrap = mod(subsC-1,spA.Size) + 1;
    % Convert wrapped subsC to linear index for size A
    indC = spSub2spInd(spA.Size, subsCWrap);
    % Accumulate (sum) over repeated indices
    sparseC = sparse(indC,1,valC);
    % Make into a sparse array structure
    [indC,~,valC] = find(sparseC);
    spC = struct('Size',spA.Size,'Ind',indC,'Val',valC);
    
% If 'shape' is 'same', all spC's subs outside spA's size are removed
elseif isequal(shape,'same')
    % Remove subsC outside sizeA
    subsCTrunc = subsC;
    valC  = valC(all(subsCTrunc<=spA.Size,2),:);
    subsCTrunc = subsCTrunc(all(subsCTrunc<=spA.Size,2),:); 
    % convert subsCTrunc to linear index for SizA
    indC = spSub2spInd(spA.Size,subsCTrunc);
    % Make into a sparse array structure
    spC = struct('Size',spA.Size,'Ind',indC,'Val',valC);
end

end
