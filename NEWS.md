# Version 1.0.3

Fixed bug in Hellinger distances and reworked the distance() function to make it slightly faster.

# Version 1.0.2

Fixed an issue with the paralellization of tasks in the Windows platform. Now all parallelized functions modify their cluster settings depending on the user's platform.

## Version 1.0.1

Fixed a bug in the function **workflowImportance**. The argument 'exclude.columns' was being ignored.

Fixed the documentation of the functions **workflowImportance** and **workflowSlotting**. Their outputs were not well documented.

Fixed an error in workflowTransfer.

Changed how psi is computed. It's now more respectful with the original formulation, and handles very similar sequences better.

Fixed the function **workflowPsi** to add +1 to the least cost produced by the options paired.samples = TRUE and diagonal = TRUE

Added the function **workflowPsiHP**, a High Performance version of **workflowPsi**. It has less options, but it is much faster, and has a much lower memory footprint.

## Version 1.0.0 is ready!


