function spC = spShift(spA,shifts,isPer,isProg,collapse)
%SPSHIFT Shift dimensions of a sparse array structure.
%
%   spC = spShift(spA,shifts,isPer,isProg,collapse: Shift each dimension of the
%   full array represented as a sparse array structure by the amounts specified
%   in the integer row vector or matrix 'shifts'. The output is a sparse array
%   structure.
%   
%   When 'shifts' is a row vector, all entries of the array are shifted by the
%   amounts specified in 'shifts': the nth entry of 'shifts' is the shift for
%   the nth dimension of the N-dimensional array. When 'shifts' is a matrix,
%   its mth row gives the N-diensional shift for the mth nonzero element of the
%   full array (i.e., the mth entry of sparse array structure's 'Ind' and 'Val'
%   fields).
%
%   isPer == 1: the shifts are circular (default).
%
%   isProg == 1: the shifts, as specified by the shift vector, for all
%   dimensions except the last are multiplied by the index of the last
%   dimension. For example, if the shift value for the first dimension is m,
%   the shift of that dimension when the final dimension's index is n is mn.
%   Default is isPer = 0.
%
%   collapse == 1: the array is summed over this last dimension. Default is
%   collapse = 0.
%
%   Version 1.1 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-09
%
%   See also SPIND2SPSUB, SPSUB2SPIND, SPSUM.

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

nDimA = size(spA.Size,2);

% Error checks
if nargin < 2
    error('At least two arguments are required.')
end
if size(shifts,1)>1 && isProg==1
    error('''shifts'' must be a row vector, not a matrix, when isProg = 1.')
end
if size(shifts,2) ~= nDimA
    error('''shifts'' must have the same number of columns as the number of dimensions in the full array.')
end
if size(shifts,1)~=1 && size(shifts,1)~=numel(spA.Ind)
    error('''shifts'' must be a row vector or have the same number of rows as nonzero entries in the sparse array structure.')
end

% Convert linear indices to subscripts
subs = spInd2spSub(spA);

% Calculate progressive shifts (if isProg==1)
if isProg == 1
   shifts = (subs(:,end) - 1)*shifts; % make shift proportional subscript in last dimension
end

% Apply shifts (non-circular or circular)
if isPer == 0
    subShift = shifts + subs; % apply noncircular shifts to all subscripts
    negShifts = shifts;
    negShifts(negShifts>0) = 0;
    minNegShifts = min(negShifts,[],1);
    maxShifts = max(shifts,[],1);
    subShift = subShift - minNegShifts;
    % Convert subscripts to linear indices
    indA = spSub2spInd(spA.Size+maxShifts-minNegShifts,subShift);
    spC = struct('Size',spA.Size+maxShifts-minNegShifts,...
                 'Ind',indA,'Val',spA.Val);
else
    subShift = subs;
    for d = 1:nDimA % apply circular shifts to the subscripts
        subShift(:,d) = mod(shifts(:,d)+subs(:,d)-1,spA.Size(d)) + 1;
    end
    % Convert subscripts to linear indices
    indA = spSub2spInd(spA.Size,subShift);
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