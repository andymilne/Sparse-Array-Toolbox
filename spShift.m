function spC = spShift(spA,shifts,isPer,isProg,collapse)
%SPSHIFT Shift dimensions of a sparse array structure.
%
%   spC = spShift(spA,shifts,isPer,isProg,collapse: Shift each
%   dimension of the full array represented as a sparse array structure by the
%   amounts specified in the integer vector 'shifts'. The output is a
%   sparse array structure.
%
%   isPer == 1: the shifts are circular (NB: nonperiodic/noncircular shifts are
%   not yet working correctly).
%
%   isProg == 1: the shift for all dimensions except the last are multiplied by
%   the index of the last dimension. For example, if the shift value for the
%   first dimension is m, the shift of that dimension when the final
%   dimension's index is n is mn.
%
%   collapse == 1: the array is summed over this last dimension.
%
%   Version 1.0 by Andrew J. Milne, The MARCS Institute, Western Sydney
%   University, 2018-01-09
%
%   See also SPIND2SPSUB, SPSUB2SPIND, SPSUM.

% THIS HAS NOT BEEN TESTED WITH isPer==0!!!

nDimA = size(spA.Size,2);

if numel(shifts) ~= nDimA
    error('The number of number of dimensions in the "shifts" vector and the original array must be equal.')
end

% Convert linear indices to subscripts
subs = spInd2spSub(spA);

% Calculate progressive shifts (if isProg==1)
if isProg == 1
   shifts = (subs(:,end) - 1)*shifts; % make shift a function of value in last dimension
end

% Apply shifts (non-circular or circular)
if isPer == 0
    subShift = shifts + subs ; % apply noncircular shifts to all subscripts
else
    subShift = subs;
    for d = 1:nDimA % apply circular shifts to the subscripts
        subShift(:,d) = mod(shifts(:,d)+subs(:,d)-1,spA.Size(d)) + 1;
    end
end

% Convert subscripts to linear indices
indA = spSub2spInd(spA.Size,subShift);
spC = struct('Size',spA.Size,'Ind',indA,'Val',spA.Val);

% Sum over last dimension (if collapse==1)
if collapse == 1 % Accumulate (sum) values in collapsed dimension
    spC = spSum(spC,nDimA);
else

end