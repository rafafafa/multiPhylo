# function depends on phytools (& dependencies) and rworldmap (& dependencies)
# written by Liam J. Revell 2013

phylo.to.map<-function(tree,coords){
#    coords = data.frame(tree$tip.label,rep(90,length(tree$tip.label)),rep(20,length(tree$tip.label)))
    n = length(tree$tip.label)
#    coords = data.frame(tree$tip.label,runif(n,0,180),runif(n,0,180))
    coords = data.frame(runif(n,-180,180),runif(n,-90,90))
#    coords = data.frame(rep(0,n),rep(0,n))
#    print(coords)
    # open & size a new plot
    par(mai=c(0,0,0,0)
#        mai=c(0.1,0.1,0.1,0.1)
        )
    map<-getMap(resolution="low")
    plot(map,ylim=c(-90,180))
    # rescale tree so it fits in the upper half of the plot
    # with enough space for labels
    sh<-max(strwidth(tree$tip.label))/(par()$usr[2]-par()$usr[1])*(par()$usr[4]-par()$usr[3])
    tree$edge.length<-tree$edge.length/max(nodeHeights(tree))*(90-sh)
    n<-length(tree$tip.label)
    # reorder cladewise to assign tip positions
    cw<-reorder(tree,"cladewise")
    x<-vector(length=n+cw$Nnode)
    x[cw$edge[cw$edge[,2]<=n,2]]<-0:(n-1)/(n-1)*360-180
    # reorder pruningwise for post-order traversal
    pw<-reorder(tree,"pruningwise")
    nn<-unique(pw$edge[,1])
    # compute horizontal position of each edge
    for(i in 1:length(nn)){
        xx<-x[pw$edge[which(pw$edge[,1]==nn[i]),2]]
        x[nn[i]]<-mean(range(xx))
    }
    # compute start & end points of each edge
    Y<-180-nodeHeights(cw)
    # plot vertical edges
    for(i in 1:nrow(Y))
        lines(rep(x[cw$edge[i,2]],2),Y[i,],lwd=2,lend=2)
    # plot horizontal relationships
    for(i in 1:tree$Nnode+n)
        lines(range(x[cw$edge[which(cw$edge[,1]==i),2]]),Y[which(cw$edge[,1]==i),1],lwd=2,lend=2)
    # plot tip labels
    for(i in 1:n)
        text(x[i],Y[which(cw$edge[,2]==i),2],tree$tip.label[i],pos=4,offset=0.1,srt=-90)
#    coords<-coords[tree$tip.label,2:1]
    points(coords,pch=16,cex=1,col="red")
    for(i in 1:n) {
#        print(c(x[i],coords[i,1]))
        lines(c(x[i],coords[i,1]),c(Y[which(cw$edge[,2]==i),2],coords[i,2]),col="red",lty="dashed")
    }
}
