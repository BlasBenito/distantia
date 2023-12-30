# Expected inputs:

- DONE matrix
  + DONE to data frame

- DONE data frame
  + DONE if nrow < 3 ERROR
  + DONE if grouping column: convert to list of data frames
  +  DONE else
    + DONE if time column: convert to list of two column data frames
    + DONE else: convert to list of one column data frame
  
- DONE list
  + if number of elements == 1: ERROR
  + if any element is not named: ERROR

- DONE if list of vectors
  + convert vectors to one column data frame
  
- if list of matrices
  + convert to list of data frames

- DONE list of data frames
  + if time column
    + set columns_to_ignore to time column
    + if not numeric: ERROR
    + else if arrange by time column
    + add time column to attribute "time" and remove from df
    + if paired samples, keep paired samples only
  + if no time column, add row_id
    + set time_column to row_id
  + keep numeric columns only
  + apply na action
  + handle zeros
  + transform
  + if "row_id" in colnames, remove it.
  + convert to matrix
  + if columns_to_ignore is not NULL, set as attribute "ignore_columns".
  + add attribute validated
