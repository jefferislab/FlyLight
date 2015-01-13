#!/usr/bin/env Rscript

# Script to go through all lsms and find metadata using 
# LOCI bioformats showinf command line tool
# will update database when finished

# To allow running direct from command line
library(nat.as)
if(!exists("fcconfig")) {
	source("~/projects/ChiangReanalysis/src/FlyCircuitStartup.R",keep.source=T)
	source("~/projects/JFRC/FlyLight/src/JFStartup.R",keep.source=T)
}
jfconfig$showinf='/lmb/home/jefferis/dev/ij/fiji.old/modules/bio-formats.setaside/tools/showinf'

#debug(makeLSMdf)
lsmdir=file.path(jfconfig$regroot,"lsmstoconvert.v")
for(f in dir(lsmdir,patt="lsm$",full=T)) extractLociLSMMetadata(f,UseLock=TRUE,showinf=jfconfig$showinf)

# Only actually make summary dataframe if something has changed
# AND nobody else is already trying to do it
# TODO: this does mean that it will be necessary to run this script once more 
# after all other instances are finished
if(RunCmdForNewerInput(NULL,
	infiles=dir(lsmdir,patt="txt$",full=T),
	outfile=file.path(jfconfig$db,"lsm.rda"),
	UseLock=TRUE,Verbose=TRUE))
{
	lsm=makeLSMdf(lsmdir=lsmdir,
		oldlsmdf=file.path(jfconfig$db,"lsm.rda"))
	print(summary(lsm))
	save(lsm,file=file.path(jfconfig$db,"lsm.rda"),ascii=TRUE)
}
