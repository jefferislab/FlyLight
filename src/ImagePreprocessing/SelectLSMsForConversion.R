# for the time being, symlink all lsms in dump directory
# in future consider processing VNCs/Brains separately
library(nat.as)
if(!exists('jfconfig')){
	source("~/projects/JFRC/FlyLight/src/JFStartup.R",keep.source=T)
}

lsms=dir(jfconfig$dumpdir,patt=".*-fA01v.*\\.lsm$",recursive=TRUE,full=T)
lsmtoconvertdir=file.path(jfconfig$regroot,"lsmstoconvert.v")
dir.create(lsmtoconvertdir,showWarnings = F)

for(lsm in lsms){
	stem=sub("\\.lsm","",basename(lsm))
	lsmtoconvert=file.path(lsmtoconvertdir,basename(lsm))
	if(!file.exists(lsmtoconvert))
		file.symlink(lsm,lsmtoconvert)
}
