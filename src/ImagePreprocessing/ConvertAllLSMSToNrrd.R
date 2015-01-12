# script to be run on hex to convert all LSM files to nrrds
library(nat.as)
if(!exists('jfconfig')){
	source("~/projects/JFRC/FlyLight/src/JFStartup.R",keep.source=T)
}
source("~/projects/CommonCode/Rscripts/ImageProcessingFunctions.R")

#' Split Zeiss LSMs and save each channel to a nrrd
#'
#' image.lsm -> image_01.nrrd image_02.nrrd image_03.nrrd
#'
#' Uses fiji and BatchConvertFlycircuitLSMsToNrrds macro, which in turn
#' relies on LOCI Bio-Formats which cannot currently be run headless.
#'
#' Uses RunCmdForNewerInput to compare in/outputs to see if action required.
#' Uses file locking so can be run in parallel, although IO intensive so
#' running too many jobs in parallel would be counter-productive. 
#' RandomOrder=TRUE reduces file locking pressure when several processes
#' compete to lock the same file.
#' @param lsmstoconvertdir Directory containing LSM
#' @param rawnrrdsdir Output directory in which to save nrrds
#' @param RandomOrder Scramble processing order (default TRUE)
#' @param DryRun Show what would happen but don't run (default TRUE)
#' @param Verbose Show filename (default !DryRun)
#' @return Named logical vector indicating whether action was required for each file
#' @export
#' @seealso \code{\link{runFijiMacro}}, \code{\link{RunCmdForNewerInput}}
convertlsmstonrrd<-function(
	lsmstoconvertdir=file.path(jfconfig$regroot,"lsmstoconvert.v"),
	rawnrrdsdir=file.path(jfconfig$regroot,"rawnrrds.v"),
	RandomOrder=TRUE,DryRun=TRUE,Verbose=!DryRun){

	if(!file.exists(rawnrrdsdir)) dir.create(rawnrrdsdir)

	lsmstoconvert=dir(lsmstoconvertdir,patt="lsm$",full=T)
	if(RandomOrder) lsmstoconvert <- sample(lsmstoconvert)
	runsummary=logical(length(lsmstoconvert))
	names(runsummary)=basename(lsmstoconvert)
	
	for(i in seq(along=lsmstoconvert)){
		f=lsmstoconvert[i]
		cmd=runFijiMacro(
			macro=file.path(jfconfig$srcdir,'ImagePreprocessing','lsmtonrrd.txt'),
			macroArg=paste(f, rawnrrdsdir, 'nrrd',sep=","),
			# javaArgs="-noverify",
			headless=TRUE, DryRun=TRUE,
			fijiPath=path.expand("~/dev/ij/fiji.2011/fiji"))
		gene_name=sub("\\.lsm","",basename(f))
		nrrds=file.path(rawnrrdsdir,paste(gene_name,"_0",1:2,".nrrd",sep=""))
		# either run cmd, or say what would have happened
		runsummary[i]=RunCmdForNewerInput(ifelse(DryRun,NA,cmd),infiles=f,
			outfiles=nrrds,UseLock=TRUE)
		if(Verbose)
			cat(ifelse(runsummary[i],"Processed","Skipped"),f,'\n')
		else {
			cat(ifelse(runsummary[i],"+","."))
			if((i%%100)==0) cat(" i = ",i,"\n",sep="")
		}
	}
	if(!Verbose && (i%%100)!=0) cat("\n") # Just to finish cleanly
	runsummary
}

runsummary=convertlsmstonrrd(DryRun=FALSE)
print(summary(runsummary))
save(runsummary,file=file.path(jfconfig$dbdir,'runsummary.rda'))
