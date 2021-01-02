library(ape)
library(openxlsx)
library(magrittr)
source('https://raw.githubusercontent.com/andrew-hipp/morton/master/R/tidyName.R')
library(phytools)

delNCBI <- TRUE # if true, drops anything we didn't sequence ourselves
delDupes <- TRUE # if true, drops duplicated seq IDs
renameSet <- c( "TAXA.Current_determination",
                "Ownership_of_Sequence",
                "Collector_no",
                "SPMCODE") # metadata fields to include in renamed phylo files
schiedFil <- T # if true, limit to individuals in sections Schiedeanae and Filifoliae
replaceSpaces <- '_' # if not NULL, replace spaces with this character

## run parameters
genes <- c('ITS', 'ETS') # excluding matK for this project
include <- 'ITS|ETS'
tidyNames <- TRUE
dropsies <- 'distachya|000360|006341|006524|12263|10297|0006359'

## get data
dat.dna <- sapply(dir('../DATA/', full = T, patt = 'fasta'), read.dna, format = 'fasta')
message('done reading dna')
dat.dna <- dat.dna[grep(include, names(dat.dna))]
# dat.meta <- read.xlsx(dir('../DATA/', full = T, patt = '.xlsx', 1))
dat.meta <- read.delim('../DATA/carexMeta.v2.tsv', as.is = T, quote = "")
row.names(dat.meta) <- dat.meta$SPMCODE
message('done reading meta')

## clean names
dat.newRowNames <- vector('list', length(dat.dna))
names(dat.newRowNames) = names(dat.dna)

for(i in names(dat.dna)) {
  dat.newRowNames[[i]] <- row.names(dat.dna[[i]])
  dat.newRowNames[[i]] <- gsub("[organism=Carex", "", dat.newRowNames[[i]], fixed = T)
  dat.newRowNames[[i]] <- gsub("_(reversed)", "", dat.newRowNames[[i]], fixed = T)
  toChange <- match(tidyName(dat.newRowNames[[i]]), tidyName(dat.meta$Original_Tube_No))
  dat.newRowNames[[i]][which(!is.na(toChange))] <-
    dat.meta$SPMCODE[toChange[which(!is.na(toChange))]]
  names(dat.newRowNames[[i]]) <- row.names(dat.dna[[i]])
  row.names(dat.dna[[i]]) <- dat.newRowNames[[i]] %>% as.character

  ### conditional subsets
  if(delNCBI) dat.dna[[i]] <- dat.dna[[i]][which(row.names(dat.dna[[i]]) %in% dat.meta$SPMCODE), ]
  if(delDupes) dat.dna[[i]] <- dat.dna[[i]][which(!duplicated(row.names(dat.dna[[i]]))), ]
  if(schiedFil) dat.dna[[i]] <- dat.dna[[i]][grep('Schied|Filifol', dat.meta[row.names(dat.dna[[i]]), 'SECTION']), ]

  ### rename using metadata
  row.names(dat.dna[[i]]) <- apply(dat.meta[row.names(dat.dna[[i]]), renameSet] , 1, paste, collapse = "|")
  if(!is.null(replaceSpaces)) row.names(dat.dna[[i]]) <- gsub(" ", replaceSpaces, row.names(dat.dna[[i]]))

  ### delete any labels indicated as problems for deletion
  dat.dna[[i]] <- dat.dna[[i]][grep(dropsies, row.names(dat.dna[[i]]), invert = T), ]
}

dat.dna$concat <- do.call(cbind.DNAbin, c(dat.dna[grep(include, names(dat.dna))], fill.with.gaps = T))

name.adder <- ifelse(schiedFil, '.schiedeanae', '.all2015')
for(i in c(genes, 'concat')) {
  write.dna(dat.dna[[grep(i, names(dat.dna))]],
            file = paste('../DNA.EDITED/', i, name.adder, '.phy', sep = ''),
            format = 'sequential',
            colsep = '',
            nbcol = -1)
}
