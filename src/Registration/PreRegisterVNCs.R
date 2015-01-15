# script to register VNCs using a home-made principal components rule
# By default runs with 10 parallel processes using plyr/doMC (suitable for hex)

library(nat.as)
setwd("~/projects/JFRC/FlyLight/FLReg/")

rotate_vnc <- function(image_file, threshold=500, transform=TRUE, centre=c('centroid', 'com'), 
	target_centre=c(191.9926, 164.9407, 83.8469), Verbose=FALSE) {
	if(Verbose) message("computing rotation for file:", image_file)
	centre <- match.arg(centre)
	x <- read.im3d(image_file)
	max_x=max(x)
	if(max_x<threshold) {
		threshold=max_x/8
		message("setting threshold to ", threshold," for image ", image_file)
	}
	xzps <- imexpand.grid(x)
	pa <- prcomp(xzps[x > threshold, ])
	pa_mod <- matrix(rep(0, 16), ncol=4)
	pa_mod[1:3, 1:3] <- pa$rotation
	pa_mod[4, 4] <- 1
	rot_params <- affmat2cmtkparams(pa_mod)

	# check if x scale factor is negative
	scales=rot_params[3,]
	if(scales[2]<0 || scales[3]<0) stop("I wasn't expecting that!")
	if(scales[1]<0) {
		# set scale factors positive
		rot_params[3,]=1
		# if it was negative then need to change z rotation
		# we rotate by a further 180 degrees, which approximates (modulo handedness)
		# the scale=-1 that would otherwise be applied _after_ the rotation
		zrot=rot_params[2,3]
		zrot=zrot+180
		# need to check that we don't now have zrot>180 which then next snippet
		# would not expect
		if(zrot>180) zrot=zrot-360
		rot_params[2,3]=zrot
	}
	
	# the principal components could be 180 degrees off what we want (the SVD sign is degenerate) 
	# check the Z rotation to see if we are 180 off our estimate (of -135 degrees) based on FlyLight's
	# mounting standard
	zrot=rot_params[2,3]
	if(zrot > -45 && zrot < 135) {
		# turn the VNC round in the opposite direction
		zrot=zrot-180
		# fix if we've dropped below -180 (we want things to be in range -180 to +180)
		if(zrot < -180) zrot=zrot+360
		rot_params[2,3] = zrot
		message("inverting rotation for ", image_file)
	}
	
	centroid <- apply(xzps[x > threshold, ], 2, median)
	com <- apply(xzps[x > threshold, ], 2, mean)
	
	if(centre == 'centroid') rot_params[5, ] <- centroid
		else rot_params[5, ] <- com
	
	affmat <- cmtkparams2affmat(rot_params)
	
	if(transform) {	
		centroid_transformed <- c(solve(affmat) %*% c(centroid, 1))[1:3]
		com_transformed <- c(solve(affmat) %*% c(com, 1))[1:3]
		trans_params <- affmat2cmtkparams(cmtkparams2affmat())
	
		if(centre == 'centroid') trans_params[1, ] <- c(centroid_transformed)[1:3] - target_centre
			else trans_params[1, ] <- c(com_transformed)[1:3] - target_centre
		trans_affmat <- cmtkparams2affmat(trans_params)
		
		affmat <- affmat %*% trans_affmat
	}
	
	cmtkreglist(affmat)
}

# construct name of output registration from input image
image_to_registration <- function(image) {
	registration <- gsub("images4um.v/", "Registration/affine/VNCIS14um_", image)
	registration <- gsub(".nrrd", "_ght.list", registration)
	registration
}

images <- dir("images4um.v", patt="01.nrrd$", full=TRUE)

make_vnc_reg<-function(x, UseLock=F) {
	outfile=image_to_registration(x)
	RunCmdForNewerInput(expression(try(write.cmtkreg(rotate_vnc(x), outfile))), infiles=x,outfiles=outfile,UseLock=UseLock)
}


# sapply(sample(images), make_vnc_reg)
# library(plyr)
# l_ply(sample(images), make_vnc_reg, .progress='text')

library(doMC)
registerDoMC(10)
l_ply(images, make_vnc_reg, .parallel=TRUE)
