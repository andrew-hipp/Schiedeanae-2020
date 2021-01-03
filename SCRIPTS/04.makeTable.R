## make table for paper
library(magrittr)
specimens <-
  tr.print$tip.label %>%
  strsplit(split = ' - ', fixed = T) %>%
  sapply(FUN = '[', 2)

columns <- c( "TAXA.Current_determination",
              "Accession_Num_Voucher",
              "voucher_location",
              "Country",
              "State_Province_Region_territory",
              "SPMCODE")
colNames <- c('Taxon', 'Voucher',
              'Herbarium', 'Country',
              'State','Specimen code')

out <- dat.meta[specimens, columns]
dimnames(out)[[2]] <- colNames
