# for the time being, symlink all lsms in dump directory
# in future consider processing VNCs/Brains separately

lsms=dir(jfconfig$dumpdir,patt="\\.lsm$",recursive=TRUE)

for(lsm in lsms){
	stem=sub("\\.lsm","",basename(lsm))
	lsmtoconvert=file.path(lsmtoconvertdir,basename(lsm))
	if(!file.exists(lsmtoconvert))
		file.symlink(lsm,lsmtoconvert)
}
