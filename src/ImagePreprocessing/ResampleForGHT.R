# Calculating Generalised Hough Transform on GJAC from SMB share is v slow
# precalculate small images

if(!exists('jfconfig')){
	source(path.expand("~/projects/AnalysisSuite/R/Code/Startup.R"),keep.source=T)
	source("~/projects/JFRC/FlyLight/src/JFStartup.R",keep.source=T)
}

# would have been images, but since flylight images seem well behaved, we
# can do it for all raw nrrds
ff=dir(file.path(jfconfig$regroot,'rawnrrds'),full=T,patt="_01\\.nrrd$")
# gene_names
names(ff)=sub("_01.nrrd","",fixed=T,basename(ff))

outdir=file.path(jfconfig$regroot,'images4um')
if(!exists(outdir)) dir.create(outdir)

for(f in sample(ff)){
	# check if we need to update
	shouldrun=RunCmdForNewerInput(NA,infiles=f,outfiles=file.path(outdir,basename(f)))
	if(!isTRUE(shouldrun)) {
		cat(".")
		next
	}
	# Force because we know we need to update
	t<-try(NrrdResample(f,outdir,voxdims=c(4,4,4),UseLock=TRUE,Force=TRUE))
	cat("+")
}
