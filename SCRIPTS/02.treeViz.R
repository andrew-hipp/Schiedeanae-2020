library(ape)
library(phytools)

og <- 'filifol|longis|arsen'
midRoot <- FALSE

tr <- lapply(dir('../DNA.EDITED/', patt = 'RAxML_bipartitions\\.', full = T), read.tree)
names(tr) <- dir('../DNA.EDITED/', patt = 'RAxML_bipartitions\\.', full = F)

for(i in names(tr)) {
  if(midRoot) {tr[[i]] <- midpoint.root(tr[[i]])
  } else {
      tr[[i]] <- root(tr[[i]], grep(og, tr[[i]]$tip.label), edgelabel = T)
    } # close else
  pdf(paste('../OUT/', i, '.pdf', sep = ''), 8.5,11)
  plot(tr[[i]], cex = 0.6)
  nodelabels(text = tr[[i]]$node.label, frame = 'n', cex = 0.5, adj = c(1, -0.5))
  dev.off()
}
