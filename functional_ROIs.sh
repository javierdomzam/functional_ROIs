#!/bin/bash
# Set the directory path where the data is stored
DIR_NAME=/your_dir

# Set the subjects to be analyzed
SUBJECTS=$1

# Set the total number of voxels
num_total=1000

# Loop through each subject
for ID in ${SUBJECTS[*]}; do
  # Set the subject's directory
  DIR_NAME=/media/jglab/SoftRaid/Documents_Javier/Attention_Decisions_fMRI
  SUBJ="sub-$ID"
  echo "----- Subject $SUBJ -----"

  # Remove the ROI_1000voxels directory if it exists
  if [ -d "${DIR_NAME}/${SUBJ}/func/ROI_1000voxels" ]; then 
    rm -Rf ${DIR_NAME}/${SUBJ}/func/ROI_1000voxels; 
  fi

  # Create the ROI_1000voxels directory and its subdirectories
  mkdir ${DIR_NAME}/${SUBJ}/func/ROI_1000voxels
  mkdir ${DIR_NAME}/${SUBJ}/func/ROI_1000voxels/ROI_mask
  mkdir ${DIR_NAME}/${SUBJ}/func/ROI_1000voxels/n_mask
  
  # Set the input file path for further analysis
  input_pre="/${DIR_NAME}/${SUBJ}/func/your_GLM_data"

  # Apply a mask to the input file
  fslmaths ${input_pre} -mas ${DIR_NAME}/${SUBJ}/func/GLM2/GLM2_2ndLevel_output.gfeat/mask.nii.gz ${DIR_NAME}/${SUBJ}/func/ROI_1000voxels/masked_map

  # Add random value to masked map to avoid negative values
  fslmaths ${DIR_NAME}/${SUBJ}/func/ROI_1000voxels/masked_map -add 1000 ${DIR_NAME}/${SUBJ}/func/ROI_1000voxels/corrected_map
  fslmaths ${DIR_NAME}/${SUBJ}/func/ROI_1000voxels/corrected_map -mas ${DIR_NAME}/${SUBJ}/func/GLM2/GLM2_2ndLevel_output.gfeat/mask.nii.gz ${DIR_NAME}/${SUBJ}/func/ROI_1000voxels/masked_corrected_map
  input=${DIR_NAME}/${SUBJ}/func/ROI_1000voxels/masked_corrected_map

  # Set the directory where the ROI files are stored
  VR_ROIFOLDER=${DIR_NAME_ROI}


  # Loop through each ROI
  for MASK in $VR_ROIFOLDER/* ;do
    MASKNAME=`basename $MASK | sed 's/_1000vx//'`
    echo "Extracting voxels from $MASKNAME"

    # Calculate the proportion of 1000 voxels relative to the total size of the image
    output=${DIR_NAME}/${SUBJ}/func/ROI_1000voxels/ROI_mask/${MASKNAME}
    fslmaths ${input} -mas ${MASK} ${output}
    number_voxels_mask=$(fslstats ${output} -V | awk '{printf $1 "\n"}')
    echo "Mask number of voxels = $number_voxels_mask"
    echo "Selecting $num_total voxels"

    # Call a Matlab function to calculate the percentile value
    # This function writes the result to a text file called value.txt
    matlab -nodisplay -r "percentile($number_voxels_mask,$num_total);quit;" | tail +11
    value=$(<value.txt)

    # 2. Use fslstats to find the percentile value at this proportion (Use '-a' before '-p' if you are interested in absolute values):
    thresh=$(fslstats ${output} -P $(<value.txt))

    # 3. Use this percentile value as a threshold in fslmaths to create a mask containing the 1000 voxels with the highest intensity:
    fslmaths ${output} -thr ${thresh} -bin ${DIR_NAME}/${SUBJ}/func/ROI_1000voxels/n_mask/${MASKNAME}_1000vx
    number_voxels_final=$(fslstats ${DIR_NAME}/${SUBJ}/func/ROI_1000voxels/n_mask/${MASKNAME}_1000vx -V | awk '{printf $1 "\n"}')
    echo "Number of voxels for MVPA = $number_voxels_final"
    echo ""
	done
	
done