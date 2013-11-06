# set up initial affine registrations for 5 good brain registration
# basically do this by concatenating
# goodbrain->JFRC2 and inverse(sample->JFRC2)
# this should provide a good starting point for the regular CMTK image-based
# registration

outputregdir<-file.path(jfconfig$regroot,'Registration.masked','affine')
if(!file.exists(outputregdir)) dir.create(outputregdir,recursive=TRUE)

sampleregs=dir(file.path(jfconfig$regroot,'Registration/affine'),patt='9dof',full=T)
goodregs=file.path(jfconfig$regroot,'Registration/affine',
c("JFRC2_GMR_10H03_AE_01_17-fA01b_C101205_20101206103312015_01_9dof.list", 
"JFRC2_GMR_10H05_AE_01_04-fA01b_C090922_20090922111220641_01_9dof.list", 
"JFRC2_GMR_15B07_AE_01_03-fA01b_C090929_20090929125913076_01_9dof.list", 
"JFRC2_GMR_16D02_AE_01_06-fA01b_C100815_20100815145445171_01_9dof.list", 
"JFRC2_GMR_19F11_AE_01_07-fA01b_C100323_20100323115643671_01_9dof.list"
))

for(gb in goodregs){
	message("Writing GHT registrations for ",gb)
	
	jfrc2_gb_reg<-ReadIGSRegistration(gb)
	jfrc2_gb_mat=ComposeAffineFromIGSParams(jfrc2_gb_reg$affine_xform)
	for(s in sampleregs){
		jfrc2_s_reg<-ReadIGSRegistration(s)
		jfrc2_s_mat=ComposeAffineFromIGSParams(jfrc2_s_reg$affine_xform)
		# calculate affine xform from sample (bad brain) to good brain
		m=solve(jfrc2_s_mat)%*%jfrc2_gb_mat
		
		# write the matrix we calculated to temporary file
		tf=tempfile()
		on.exit(unlink(tf))
		# don't forget to transpoe matrix so that it is written out
		# row major (what CMTK expects) rather than R's default column major
		cat(t(m),file=tf)
		
		# find the short name for the sample image (bad brain)
		outputreg=paste(jfshortname_forfile(s),sep="_",sub("JFRC2_","",basename(gb)))
		# although we calculated these from image-based affine registrations
		# let's pretend that they came from GHT so that they are used as
		# seed for a new image-based affine.
		outputreg=sub("9dof\\.list","ght.list")
		outputlist=file.path(outputregdir,outputreg)
		cmd=paste('mat2dof --list ',outputlist,"<",tf)
		system(cmd)
		cat(".")
	}
}

