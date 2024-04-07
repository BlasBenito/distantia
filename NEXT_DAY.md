
utils_time_breaks_type() returns type of breaks to be used to generate the breaks vector, by checking the breaks and the time features of the tsl object.

These breaks types are then used by utils_time_breaks() to generate the breaks vector from either a keyword or a number.

It uses tsl_time_summary() to return all the relevant details about tsl time.
