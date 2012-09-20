cat("Calculating background parameters for Brain images ...")
jfrc2csv=file.path(jfconfig$dbdir,"jfrc2_BackgroundParams.csv")
jfrc2histo=file.path(jfconfig$regdir,"reformatted.histo")
if(file.exists(jfrc2csv)){
	jfrc2df=read.csv(jfrc2csv,stringsAsFactors=FALSE)
	jfrc2df=UpdateOrCalculateBackgroundParams(,jfrc2df)
} else jfrc2df=UpdateOrCalculateBackgroundParams(jfrc2files)

if(!isTRUE(attr(jfrc2df,"changed")==FALSE))
	write.csv(jfrc2df,file=jfrc2csv,row.names=FALSE)
