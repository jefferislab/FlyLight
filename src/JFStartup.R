jfconfig<-list(
	url="http://flweb.janelia.org/",
	srcdir=path.expand(dirname(attr(body(function() {}),'srcfile')$filename))
)
jfconfig$rootdir=dirname(jfconfig$srcdir)
jfconfig$regroot=file.path(jfconfig$rootdir,'FLReg')
jfconfig$dbdir=file.path(jfconfig$rootdir,'db')
jfconfig$FunctionFiles=list.files(jfconfig$srcdir,patt="Functions",full=T,recurs=T)
jfconfig$dumpdir=file.path(jfconfig$rootdir,'dump.v')

for (MyPath in jfconfig$FunctionFiles) {
	try(source(MyPath))
}
