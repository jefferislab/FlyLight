# script to project nrrd files contained in a directory along given axis

cmdargs=commandArgs(trailingOnly=TRUE)
print(str(cmdargs))
if(length(cmdargs)<3) {
	stop("Must supply indir,outdir and axis")
	# Script to preprocess a directory of images 
} else {
	indir=cmdargs[[1]]
	outdir=cmdargs[[2]]
	axis=cmdargs[[3]]
	if(length(cmdargs)==4) regex=cmdargs[[4]]
	else regex="\\.nrrd$"
}

source(path.expand("~/projects/AnalysisSuite/R/Code/Startup.R"))
# note use of sample to randomise order of processing to help avoid clashes
infiles=sample(dir(indir,patt=regex,full=TRUE))
outfiles=file.path(outdir,sub("nrrd$","png",basename(infiles)))

mapply(NrrdProject,infiles,outfiles,MoreArgs=list(axis=axis,UseLock=TRUE))
