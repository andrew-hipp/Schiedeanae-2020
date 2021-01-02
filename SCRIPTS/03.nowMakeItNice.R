library(ggtree)
library(magrittr)
library(phytools)
source('https://raw.githubusercontent.com/andrew-hipp/morton/master/R/label.elements.R')

bs.min = 50 # anything less than this is not included in branch labels

tr.print <- read.tree(text = write.tree(tr$RAxML_bipartitions.concat.schiedeanae.tre))
tr.print$node.label[tr.print$node.label == 'Root'] <- ''
tr.print$node.label[which(as.integer(tr.print$node.label) < bs.min)] <- ''
tr.print$tip.label <- gsub('planilomina', 'planilamina', tr.print$tip.label)
tr.print$tip.label <-
label.elements(tr.print, returnNum = c(1,4), returnDelim = ' - ', fixed = T) %>%
  as.character

clades <- list(
  'Outgroup' = c('Carex_arsenei - spm00004489', 'Carex_filifolia_var._filifolia - spm00000865'),
  'Short scale clade' = c('Carex_mesophila - spm00006354', 'Carex_complexa - spm00000357'),
  'Long scale grade' = c('Carex_muriculata - spm00000355', 'Carex_schiedeana - spm00000354')
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
