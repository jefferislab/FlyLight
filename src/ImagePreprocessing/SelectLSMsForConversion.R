# for the time being, symlink all lsms in dump directory
# in future consider processing VNCs/Brains separately

if(!exists('jfconfig')){
	source(path.expand("~/projects/AnalysisSuite/R/Code/Startup.R"),keep.source=T)
	source("~/projects/JFRC/FlyLight/src/JFStartup.R",keep.source=T)
}

lsms=dir(jfconfig$dumpdir,patt="\\.lsm$",recursive=TRUE)
lsmtoconvertdir=file.path(jfconfig$regroot,"lsmstoconvert")

for(lsm in lsms){
	stem=sub("\\.lsm","",basename(lsm))
	lsmtoconvert=file.path(lsmtoconvertdir,basename(lsm))
	if(!file.exists(lsmtoconvert))
		file.symlink(lsm,lsmtoconvert)
}
