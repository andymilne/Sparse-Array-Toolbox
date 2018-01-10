function spC = spOuter(varargin)
%SPOUTER THE Outer (tensor) product of sparse array structures.
%   spC = spOuter(varargin): The outer (tensor) product of full arrays, each
%   represented as a sparse array structure. The sparse array structures can
%   entered as a comma separated list or as a members of a cell. The output is
%   a sparse array structure. Calculations are performed from left to right in
%   the list. All singleton dimensions are collapsed: if A is a row vector of
%   size (1,M) and B is a matrix of size (N,P), the resulting tensor has size
%   (M, N, P), not size (1,M,N,P). The output is a sparse array structure.
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

valspA = 1;
indspA = spA{1}.Ind;
numPrev = 1;
sizeArray = [];
for i = 1:nSpA
    % Calculate the values
    valTermi = spA{i}.Val;
    if i > 1
        % Orthogonalize vector representations of sparse arrays' values to make
        % use of implicit expansion
        valTermi = permute(valTermi,circshift(1:nSpA,i-1));
    end
    % Outer product of nonzeros in original arrays
    valspA = valspA.*valTermi; 
    
    % Calculate the respective indices
    if i > 1
        % Linear indices of nonzeros in ith array
        indTermi = spA{i}.Ind;
        % Orthogonalize vector representations of sparse arrays' indices to
        % make use of implicit expansion
        indTermi = permute(indTermi,circshift(1:nSpA,i-1));
        % Get size of previous dimension of original array
        numPrevi = prod(spA{i-1}.Size);
        % Calculate the linear index weights for each successive dimension
        numPrev = numPrev*numPrevi;
        % Weighted outer sum of indices of nonzero entries in arrays
        indspA = indspA + numPrev*(indTermi-1); 
    end
    sizeArray = [sizeArray spA{i}.Size]; 
end
spC = struct('Size',sizeArray,'Ind',indspA(:),'Val',valspA(:));

end