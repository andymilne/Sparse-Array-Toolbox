function spC = spShift(spA,shifts,isPer,isProg,collapse)
%SPSHIFT Shift dimensions of a sparse array structure.
%
%   spC = spShift(spA,shifts,isPer,isProg,collapse): Shift each dimension of
%   the full array (represented as a sparse array structure or a full array) by
%   the amounts specified in the integer row vector or matrix 'shifts'. The
%   output is a sparse array structure.
%
%   When 'shifts' is a row vector, all entries of the array are shifted by the
%   amounts specified in 'shifts': the nth entry of 'shifts' is the shift for
%   the nth dimension of the N-dimensional array. When 'shifts' is a matrix,
%   its mth row gives the N-dimensional shift for the mth nonzero element of the
%   full array (i.e., the mth entry of sparse array structure's 'Ind' and 'Val'
%   fields).
%
%   isPer == 1: the shifts are circular (default).
%
%   isProg == 1: the shifts, as specified by the shift vector, for all
%   dimensions except the last are multiplied by the index of the last
%   dimension. For example, if the shift value for the first dimension is m,
%   the shift of that dimension when the final dimension's index is n is mn.
%   Default is isProg = 0.
%
%   collapse == 1: the array is summed over this last dimension. Default is
%   collapse = 0.
%
%   By Andrew J. Milne, The MARCS Institute, Western Sydney University
%
%   See also SPIND2SPSUB, SPSUB2SPIND, SPSUM, CIRCSHIFT.

% Defaults
if nargin < 5
    collapse = 0;
end
if nargin < 4
    isProg = 0;
end
if nargin < 3
    isPer = 1;
end

% If full array, convert to sparse array structure
if ~isstruct(spA)
    spA = array2SpArray(spA);
end

nDimA = size(spA.Size,2);

% Error checks
if nargin < 2
    error('At least two arguments are required.')
end
if size(shifts,1)>1 && isProg==1
    error('''shifts'' must be a row vector, not a matrix, when isProg = 1.')
end
if size(shifts,2) ~= nDimA
    error(['''shifts'' must have the same number of columns as ', ...
           'the number of dimensions in the full array.'])
end
if size(shifts,1)~=1 && size(shifts,1)~=numel(spA.Ind)
    error(['''shifts'' must be a row vector or have the same number of ', ...
           'rows as nonzero entries in the sparse array structure.'])
end

% Convert linear indices to subscripts
subs = spInd2SpSub(spA);
% Calculate progressive shifts (if isProg==1)
if isProg == 1
    % make shift proportional subscript in last dimension
    shifts = (subs(:,end) - 1)*shifts;
end

% Apply shifts (non-circular or circular)
if isPer == 0
    subShift = shifts + subs; % apply noncircular shifts to all subscripts
    % Negative shifts can make some subscripts less than 1, hence all shifts in
    % each dimension are offset by the most negative shift (so the smallest
    % shift is zero). Relative to these, positive shifts make the array
    % dimension larger, so it must be appropriately expanded.
    negShifts = shifts;
    negShifts(negShifts>0) = 0;
    minNegShifts = min(negShifts,[],1); % most negative shift in each dimension
    subShift = subShift - minNegShifts; % offset shifts
    maxShifts = max(shifts,[],1); % greatest shift in each dimension
    % Convert subscripts to linear indices and expand array, if necessary
    indA = spSub2SpInd(spA.Size+maxShifts-minNegShifts,subShift); 
    % Make the sparse array structure
    spC = struct('Size',spA.Size+maxShifts-minNegShifts,...
                 'Ind',indA,'Val',spA.Val);
else
    subShift = mod(shifts+subs-1,spA.Size) + 1;
    % Convert subscripts to linear indices
    indA = spSub2SpInd(spA.Size,subShift);
    % Accumulate (sum) over repeated indices
    sparseC = sparse(indA,1,spA.Val);
    % Make the sparse array structure
    [indC,~,valC] = find(sparseC);
    spC = struct('Size',spA.Size,'Ind',indC,'Val',valC);
end

% Sum over last dimension (if collapse==1)
if collapse == 1 % Accumulate (sum) values in collapsed dimension
    spC = spSum(spC,nDimA);
else
    
end
