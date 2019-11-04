function h = spHistEntropy(spA,isNorm)
%SPHISTENTROPY Normalized entropy of a histogram in sparse array format.
%
%   h = spHistEntropy(v): Normalized entropy of a histogram v, where the
%   histogram is normalized to convert it into a probability mass function so
%   its emtropy can be calculated. Normalized entropy is entropy divided by
%   maximum possible entropy; it is, therefore, unitless and in the interval
%   [0,1]; it allows for comparisons between differently sized sample spaces.
%
%   By Andrew J. Milne, The MARCS Institute, Western Sydney University.


if nargin < 2
    isNorm = 1;
end

% Normalize to make into probability mass function
histNorm = spA.Val./sum(spA.Val);

% Size of sample space
N = prod(spA.Size);

% Calculate entropy
logHistNorm = -log(histNorm);
logHistNorm(isinf(logHistNorm)) = 0;

if isNorm == 1
    h = histNorm'*logHistNorm/log(N);
else
    h = histNorm'*logHistNorm;
end

end
