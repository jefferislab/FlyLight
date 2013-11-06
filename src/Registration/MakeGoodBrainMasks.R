# Make masks for good brains (without lamina) that will be used to
# mask out lamina from bad brains 

# 1. mask masks from levelset data for 5 good brains
goodimages=dir('/Volumes/JData/JPeople/Marta/JFRC/FlyLight/FLReg/original_images_used_for_masking_goodbrains',full=T)
maskdir="/Volumes/JData/JPeople/Marta/JFRC/FlyLight/FLReg/goodbrain_masks"

for(img in goodimages){
	mask=file.path(maskdir,basename(img))
	# make a mask with levelset tool
	cmd=paste("levelset -b --levelset-threshold 4",img,mask)
	print(cmd)
	system(cmd)
}

