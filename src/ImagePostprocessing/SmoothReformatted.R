# Smooth and Quantise Refomatted Images

ResampleAndSmoothAllNrrds<-function(indir,outdir=paste(indir,"-smooth",sep=""),
	paramdf,patt="nrrd$",...)
{
	infiles=list.files(indir,patt=patt,recursive=TRUE)
	cat("Resampling and smoothing",length(infiles),":\n")
	for(infile in infiles){
		outfile=file.path(outdir,infile)
		# nb need Aggressive to prevent matched against mask file
		s=subset(paramdf,filestem==(infile,Aggressive=TRUE))
		if(nrow(s)>1) {
			warning("multiple parameter matches for infile: ",infile)
			next
		} else if (nrow(s)<1){
			warning("no parameter matches for infile: ",infile)
			next
		}
		result<-try(NormaliseAndSmoothNrrd(infile=file.path(indir,infile),outfile=outfile,
			threshold=s$threshold,max=s$max,gzip=TRUE,UseLock=TRUE,...))
		if(inherits(result,"try-error")){
			cat("Problem processing file: ",infile,"\n")			
		} else if(result){
			cat("+")
		} else cat(".")
	}
	cat("\nFinished!\n")
}

jfrc2bparams_path=file.path(jfconfig$dbdir,"jfrc2bparams.rda")
load(jfrc2bparams_path)

# 4xd - could be useful for skeletonization
ResampleAndSmoothAllNrrds(file.path(jconfig$regroot,"reformatted"),
	outdir=file.path(jconfig$regroot,"reformatted-4xd-smooth"),
	paramdf=jfrc2bparams,
	scalefactor="x0.5 x0.5 =",sigma=0.6)