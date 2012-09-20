# Calculate background parameters for neuron (green) images based on
# nrrd format histograms of reformatted images
# Depends on CalculateHistograms.R

if(!exists('jfconfig')){
	source(path.expand("~/projects/AnalysisSuite/R/Code/Startup.R"),keep.source=T)
	source("~/projects/JFRC/FlyLight/src/JFStartup.R",keep.source=T)
}

cat("Calculating background parameters for Brain images ...")
jfrc2csv=file.path(jfconfig$dbdir,"jfrc2_BackgroundParams.csv")
jfrc2histo=file.path(jfconfig$regroot,"reformatted.histo")
if(file.exists(jfrc2csv)){
	jfrc2df=read.csv(jfrc2csv,stringsAsFactors=FALSE)
	jfrc2df=UpdateOrCalculateBackgroundParams(jfrc2histo,jfrc2df)
} else jfrc2df=UpdateOrCalculateBackgroundParams(jfrc2histo)

# write out table if it has changed
if(isTRUE(attr(jfrc2df,"changed")))
	write.csv(jfrc2df,file=jfrc2csv,row.names=FALSE)
