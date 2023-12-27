# Expected inputs:

- long data frame with grouping column: list of data frames
  + if input is data frame and there is no grouping column: ERROR
  + else, convert to list of data frames
  
- list
  + if number of elements == 1: ERROR
  + if any element is not named: ERROR

- if list of vectors
  + if there are vectors of length < 3: ERROR
  + convert elements to one-column data frame
  
- if list of matrices
  + get column names
  + get number of columns
  + if no names and different columns: ERROR
  + if no names and same columns: set new column names to col1, coln
  + convert to data frame

- list of data frames
  + if time column
    + set columns_to_ignore to time column
    + if not numeric: ERROR
    + else if arrange by time column
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
