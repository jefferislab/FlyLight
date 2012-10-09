# make amira format registrations (ie 4x4 homogeneous affine)
# from CMTK format registrations in a given directory

# nb use sample to randomise order
ff=sample(dir(file.path(jfconfig$regroot,'Registration','affine'),patt='9dof\\.list$',full=TRUE))

# pb=txtProgressBar(min=0,max=length(ff),style=3)
errfiles=vector(mode='character')
for(i in seq(ff)){
	
	t=try(AmiraRegFromCMTK(ff[i],Overwrite=FALSE))
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
rm(ff,errfiles)