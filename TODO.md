# replace dplyr verbs in combine.R with base R

# function to fill gaps in sequences with GAMs

# function to plot importance scores

# function to plot distance scores between sequences

# new version of workflowPartialMatch

# new version of workflowTransfer


# new naming convention

Choose how to call time-series. Currently it's "sequences", but maybe consider replacing it with "ts_" or something along these lines.

Functions to compute psi step by step should probably be grouped by a prefix.

importance() could be named distantia_importance() so we have distantia(), distantia_importance(), and distantia_plot()
