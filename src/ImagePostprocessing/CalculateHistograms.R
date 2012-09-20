# As a first step for processing the green channel (neuron) images,
# we need to calculate image histograms.
# Although there might be discussion about whether we should do this with 
# reformatted or original images, I will start with doing this with reformatted
# The other question is whether we should be using a mask for the 

# Next step would be to calculate background parameters and then use this 
# information to quantise images (probably downsampling as well.)

if(!exists('jfconfig')){
	source(path.expand("~/projects/AnalysisSuite/R/Code/Startup.R"),keep.source=T)
	source("~/projects/JFRC/FlyLight/src/JFStartup.R",keep.source=T)
}

# nb use sample to randomise order
indir=file.path(jfconfig$regroot,'reformatted')
outdir=paste(indir,sep=".",'histo')

if(!file.exists(outdir)) dir.create(outdir)
ff=sample(dir(indir,patt='_02_.*\\.nrrd$',full=TRUE))

# pb=txtProgressBar(min=0,max=length(ff),style=3)
errfiles=vector(mode='character')
for(i in seq(ff)){
	outfile=file.path(outdir,basename(ff[i]))
	shouldrun=RunCmdForNewerInput(NA,infiles=ff[i],outfiles=outfile))
	if(!isTRUE(shouldrun)) {
		cat(".")
		next
	}
	# we should overwrite if RunCmdForNewerInput returned TRUE
	t=try(ReadHistogramFromNrrd(ff[i],Overwrite=TRUE))
	if(inherits(t,'try-error')){
		errfiles=c(errfiles,ff[i])
		cat("x")
	} else {
		# if(is.null(t)) cat(".")
		# else 
		cat("+")
	}
	if((i%%100)==0) cat(" i = ",i,"/",length(ff),"\n")
	
	# setTxtProgressBar(pb,i)
}
if((i%%100)!=0) cat("\n")

print(errfiles)
rm(indir,outdir,outfile,ff,errfiles)

