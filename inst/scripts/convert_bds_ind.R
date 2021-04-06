# script to upload data
args <- commandArgs(trailing = TRUE)
data_ind <- bdsreader::read_bds(args)
