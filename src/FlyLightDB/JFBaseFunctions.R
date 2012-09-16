#' Return the janelia image name for a path (excluding any file extension)
#'
#' @param file Path to file(s) to test
#' @param checkExists Check that calculated image stem exists (TODO)
#' @return Character vector of image names (or NA if checkExists fails)
#' @export
#' @seealso \code{\link{fc_gene_name}}
#' @examples
#' stopifnot(jfimagestem_forfile("Registration.GHT/affine/JFRC2_GMR_10A06_AE_01_08-fA01b_C100709_20100709225242046_01_ght.list")=="GMR_10A06_AE_01_08-fA01b_C100709_20100709225242046")
jfimagestem_forfile<-function(file,checkExists=FALSE){
	# get rid of any leading directories
	jfi=basename(file)
	# GMR_9G09_AE_01_41-fA01b_C100120_20100120131426046
	regex="GMR_[0-9]{1,2}[A-H][0-9]{2}_[A-Z]{2}_[0-9]{2}_[0-9]{2}-fA0[1-2](b|v)_C[0-9]{6}_[0-9]{17}"
	#trim off template brain
	jfi=sub(sprintf(".*(%s).*",regex),"\\1",jfi)
	if(checkExists){
		message("This option is not yet implemented!")
		# load_fcdb("neuron")
		# missing=!gn%in%neuron$gene_name
		# if(any(missing)){
		#		warning("gene_name:",gn[missing]," for file:",file[missing]," not present in neuron table")
		#		gn[missing]=NA_character_
		# }
	}
	jfi
}
