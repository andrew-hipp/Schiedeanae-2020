library(ggtree)
library(magrittr)
library(phytools)
source('https://raw.githubusercontent.com/andrew-hipp/morton/master/R/label.elements.R')

bs.min = 50 # anything less than this is not included in branch labels
dat.meta2 <- read.xlsx('../DATA/SCHIEDEANAE_sampleMetadata_extractSPECIMENtable-20200917v2_S-MH20201016.xlsx', 1)
row.names(dat.meta2) <- dat.meta2$SPMCODE

tr.print <- read.tree(text = write.tree(tr$RAxML_bipartitions.concat.schiedeanae.tre))
tr.spm <- label.elements(tr.print, returnNum = 4, delim = '|', fixed = T) %>%
  as.character
tr.print$tip.label <-
  paste(tr.print$tip.label,
        dat.meta2[tr.spm, 'State_Province_Region_territory'],
        sep = '|')
tr.print$node.label[tr.print$node.label == 'Root'] <- ''
tr.print$node.label[which(as.integer(tr.print$node.label) < bs.min)] <- ''
tr.print$tip.label <- gsub('planilomina', 'planilamina', tr.print$tip.label)
tr.print$tip.label <-
label.elements(tr.print, returnNum = c(1,5,4), returnDelim = ' - ', fixed = T) %>%
  as.character
tr.print$tip.label <- gsub('_', ' ', tr.print$tip.label, fixed = T)

clades <- list(
  'Outgroup' = grep('spm00004489|spm00000865', tr.print$tip.label, value = T),
  'Woodland clade' = grep('spm00006354|spm00000357', tr.print$tip.label, value = T),
  'Dryland grade' = grep('spm00000355|spm00000354', tr.print$tip.label, value = T)
)

# clades <- list(
#   Short_scale_clade = c('angustilepis', 'complexa', 'mesophila', 'perstricta', 'planilamina'),
#   Long_scale_grade = c('cabralii', 'dentata', 'gypsophila', 'muriculata', 'revoluta', 'schiedeana', 'stellata', 'tehuacana', 'vizarronensis')
# )
#
# names(clades) <- gsub('_', ' ', names(clades))
#
# for(i in names(clades))
#   clades[[i]] <- sapply(clades[[i]], grep, tr.print$tip.label, value = T) %>%
#   unlist %>% as.character
# clades <- sapply(clades, function(x) tr.print$tip.label[tr.print$tip.label %in% x])
# clades <- lapply(clades, function(x) c(x[1], tail(x, 1)))

trP <- ggtree(tr.print)
trP <- trP + xlim(NA, 0.2)
trP <- trP + geom_tiplab()
trP <- trP + geom_nodelab(aes(x = branch, label = label),
                          hjust = 0.7, vjust = -0.5, size = 3)
for(i in names(clades)) {
  trP <- trP + geom_strip(
    clades[[i]][1], clades[[i]][2],
    label = i,
    barsize = 1, color = 'black', align = TRUE,
    offset = 0.08, offset.text = 0.002
  )
}


pdf('../OUT/combinedAnalysis.for.paper.pdf', 10, 7)
print(trP)
dev.off()
