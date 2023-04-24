% This function calculates the percentile value for a given number of voxels and total number of voxels
%
% Inputs:
% - number_voxels_mask: the number of voxels in the mask
% - num_total: the total number of voxels to be included in the ROI
%
% Outputs:
% - a text file named "value.txt" containing the percentile value
%
% Example usage: percentile(100, 1000)
%
% Written by F.Javier Dominguez Zamora

function percentile(number_voxels_mask,num_total)

% Calculate the proportion of the number of voxels in the mask relative to the total number of voxels
proportion = num_total / number_voxels_mask;

% Calculate the percentile value
percentile_value = 100 - (100 * proportion);

% Write the percentile value to a text file called "value.txt"
writematrix(percentile_value, 'value.txt')

end