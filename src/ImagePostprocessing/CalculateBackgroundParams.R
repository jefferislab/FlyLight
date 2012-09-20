# Calculate background parameters for neuron (green) images based on
# nrrd format histograms of reformatted images
# Depends on CalculateHistograms.R

if(!exists('jfconfig')){
	source(path.expand("~/projects/AnalysisSuite/R/Code/Startup.R"),keep.source=T)
	source("~/projects/JFRC/FlyLight/src/JFStartup.R",keep.source=T)
}

cat("Calculating background parameters for Brain images ...")
jfrc2bparams_path=file.path(jfconfig$dbdir,"jfrc2bparams.rda")
jfrc2histo=file.path(jfconfig$regroot,"reformatted.histo")
if(file.exists(jfrc2bparams_path)){
	load(jfrc2bparams_path)
	jfrc2bparams=UpdateOrCalculateBackgroundParams(jfrc2histo,jfrc2bparams,filestems=jfimagestem_forfile)
} else jfrc2bparams=UpdateOrCalculateBackgroundParams(jfrc2histo,filestems=jfimagestem_forfile)

# write out table if it has changed
if(isTRUE(attr(jfrc2bparams,"changed")))
	save(jfrc2bparams,file=jfrc2bparams_path,row.names=FALSE)
