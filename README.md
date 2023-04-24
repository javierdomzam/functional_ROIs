# Create functional ROIs with FSL and Matlab
This code performs functional ROI analysis using FSL and Matlab. The goal is to create a set of ROIs with 1000 voxels each, based on the highest intensity values in a given functional image.

# Getting Started
Before running this code, make sure you have the following software installed:

FSL (FMRIB Software Library)
Matlab

# Also, ensure that you have the necessary data organized in a specific directory structure. See below for details.

Directory Structure
The input data should be organized in the following directory structure:

```shell
your_dir/
    sub-001/
        func/
            your_GLM_data
            GLM2/
                GLM2_2ndLevel_output.gfeat/
                    mask.nii.gz
    sub-002/
        func/
            your_GLM_data
            GLM2/
                GLM2_2ndLevel_output.gfeat/
                    mask.nii.gz
    ...
 ```
 
# Usage
To run the script, open a terminal window and navigate to the directory where the code is stored. Then, execute the following command:

```bash
./create_ROIs.sh SUBJECTS
```
Replace SUBJECTS with a list of subject IDs separated by spaces. For example:

```bash
./create_ROIs.sh 001 002 003
```
The script will loop through each subject and perform the following steps:

1. Create a directory called ROI_1000voxels and its subdirectories (ROI_mask and n_mask).
2. Apply a mask to the input file.
3. Add a random value to the masked map to avoid negative values.
4. Loop through each ROI in the directory specified by DIR_NAME_ROI.
5. Extract the voxels from the ROI.
6. Calculate the percentile value using Matlab.
7. Use the percentile value as a threshold to create a mask containing the 1000 voxels with the highest intensity.

The resulting ROIs will be saved in the n_mask subdirectory.
