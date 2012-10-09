# Try calculating image cross-correlations to form a manifold that can be
# used to look for consistency with registrations

pngs=dir("/GD/projects/JFRC/FlyLight/FLReg/images4um.zsmall.z",patt='png$',full=T)
library(readbitmap)
pngl=lapply(pngs,function(f) as.vector(read.bitmap(f)))
table(sapply(pngl,length))
good=(sapply(pngl,length)==2809)
names(pngl)=basename(pngs)
pngm=do.call(cbind,pngl[good])
colnames(pngm)=basename(pngs[good])
cormat=cor(pngm)
d=as.dist(1-cormat)

api=apcluster(cormat)
system2('open',goodpngs[select3d()(i1k$points[,1:3])])

#
i3k=isomap(d,k=10)
# or 
load('~/projects/JFRC/FlyLight/data/i3k.rda')

source('/GD/projects/ChiangReanalysis/src/FlycircuitAnalysis/FCImageAnalysisFunctions.R', chdir = TRUE)
clear3d()
plot3d.isomap(i3k,'points')
spheres3d(i3k$points[api@exemplars,1:3],col='green',rad=0.01)
regular=select3d()(i3k$points[,1:3])
system2('open',goodpngs[select3d()(i3k$points[,1:3])])

ras=function(x) as.raster(read.bitmap(file.path("/GD/projects/JFRC/FlyLight/FLReg/images4um.zsmall.z",x)))
r=ras(colnames(pngm)[1])
r
plot(i3k,net=F)
for(n in names(api@exemplars)){#
  rasterImage(ras(n),i3k$points[n,1],i3k$points[n,2],i3k$points[n,1]+0.1,i3k$points[n,2]+0.1)#
}
