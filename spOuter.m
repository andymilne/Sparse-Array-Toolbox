function spC = spOuter(varargin)
%SPOUTER THE Outer (tensor) product of sparse array structures.
%   spC = spOuter(varargin): The outer (tensor) product of full arrays, each
%   represented as a sparse array structure. The sparse array structures can be
%   entered as a comma separated list or as a members of a cell. The output is
%   a sparse array structure. Calculations are performed from left to right in
%   the list. All singleton dimensions are removed: if A is a row vector of
%   size (1,M) and B is a matrix of size (N,P), the resulting tensor has size
%   (M,N,P), not size (1,M,N,P). The output is a sparse array structure.
%
%   Version 1.0 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-09

% Check whether varargin is a comma separated list or a cell array
if ~iscell(varargin{1})
    spA = varargin;
elseif iscell(varargin{1})
    spA = varargin{:};
end
nSpA = size(spA,2); % count the number of arguments

numPrev = 1;
valspA = spA{1}.Val;
indspA = spA{1}.Ind;
sizeCell = cell(1,nSpA);
sizeCell{1} = spA{1}.Size;
for i = 2:nSpA
    % Calculate values:
    % Orthogonalize vector representations of sparse arrays' values to make use
    % of implicit expansion
    valTermi = permute(spA{i}.Val,circshift(1:nSpA,i-1));
    % Outer product of nonzeros in original arrays
    valspA = valspA.*valTermi;
    
    % Calculate linear indices:
    % Orthogonalize vector representations of sparse arrays' indices to
    % make use of implicit expansion
    indTermi = permute(spA{i}.Ind,circshift(1:nSpA,i-1));
    % Get size of previous dimension of original array
    numPrevi = prod(spA{i-1}.Size);
    % Calculate the linear index weights for each successive dimension
    numPrev = numPrev*numPrevi;
    % Weighted outer sum of indices of nonzero entries in arrays
    indspA = indspA + numPrev*(indTermi-1);
    sizeCell{i} = spA{i}.Size;
end
sizeArray = cat(2,sizeCell{:});

% Make the sparse array structure
spC = struct('Size',sizeArray,'Ind',indspA(:),'Val',valspA(:));

end