Unify the signature of zoo_resample and zoo_aggregate, and tsl_resample and tsl_aggregate


Add example to tsl_resample to the standard of zoo_resample

Consider removing loess and gam as method in zoo_resample and tsl_resample, as loess performs worse than splines, and splines and gam are equivalent, but splines need no further dependencies.

Check package autotest https://docs.ropensci.org/autotest/
