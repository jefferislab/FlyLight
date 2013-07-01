if(!exists('jfconfig')){
	source(path.expand("~/projects/AnalysisSuite/R/Code/Startup.R"),keep.source=T)
	source("~/projects/JFRC/FlyLight/src/JFStartup.R",keep.source=T)
}

# Take precomputed background statistics and make new images which fill a given
# range by linearly scaling old values from threshold (=>0) to oldmax (=>2^bits-1)
QuantiseAllNrrds<-function(indir,outdir=paste(indir,"-quant",sep=""),paramdf,patt="nrrd$",bits=8)
{
	infiles=list.files(indir,patt=patt,recursive=TRUE)
	cat("Quantising",length(infiles),":\n")
	for(infile in infiles){
		outfile=file.path(outdir,infile)
		# Make nrrd default output even if input is nhdr
		outfile=sub("nhdr$","nrrd",outfile)
		s=subset(paramdf,filestem==jfimagestem_forfile(infile))
		if(nrow(s)>1) {
			warning("multiple parameter matches for infile: ",infile)
			next
		} else if (nrow(s)<1){
			warning("no parameter matches for infile: ",infile)
			next
		}
		result<-try(NrrdQuantize(file.path(indir,infile),outfile,
			min=s$threshold,max=s$max,
			bits=as.character(bits),gzip=TRUE,UseLock=TRUE,Verbose=FALSE))
		if(inherits(result,"try-error")){
			cat("Problem processing file: ",infile,"\n")			
		} else if(result){
			cat("+")
		} else cat(".")
	}
	cat("\nFinished!\n")
}

load(file.path(jfconfig$dbdir,"jfrc2bparams.rda"))

# 4xd - could be useful for skeletonization
QuantiseAllNrrds(file.path(jfconfig$regroot,"reformatted"),
	outdir=file.path(jfconfig$regroot,"reformatted-quant"),
	paramdf=jfrc2bparams,patt='_02_warp.*\\.nrrd$')
 
