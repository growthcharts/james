# script to upload data
args <- commandArgs(trailing = TRUE)
data_ind <- minihealth::convert_bds_individual(args)
