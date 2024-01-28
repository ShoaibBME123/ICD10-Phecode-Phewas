library(data.table)
library(dplyr)
library(tidyverse)
library(PheWAS)
library(fuzzyjoin)
icdt <- fread("icd_codes.tab",header=T,sep="\t")
icdt <- as.data.frame(icdt)
icdt <- icdt[,c(1,(2:214))] ## First 214 columns represents patients IDs and ICD10 columns ##
x1 <- icdt %>%
filter(if_any(starts_with(’f.41271’), ~ substr(., 1, 1) == ’250’)) %>%
pivot_longer(cols = starts_with("f.41270"),
values_to = ’DiagnosisCodes’, names_to = NULL) %>%
filter(substr(DiagnosisCodes, 1, 1) == "250")
x1 <- as.data.frame(x1)
ci_str_detect <- function(x, y) {
str_detect(y, pattern = sub(’(^[A-Z][0-9]{2})([0-9]{1,2})’, ’\\1\\.\\2’, x, perl = TRUE))
}
x2 <- fuzzyjoin::fuzzy_left_join(x1, phecode_map_icd10, by = c("DiagnosisCodes" = "code"), match_fun = ci_str_detect)
## In x2, only 2 columns are of interest, first (f.eid) and fourth one (code) ##
x3 <- x2[,c(1,4)]
colnames(x3)[2] <- ’DiagnosisCodes’
x4 <- as.data.frame(count(x3, f.eid, DiagnosisCodes))
x5 <- data.frame(f.eid=x4$f.eid,vocabulary_id="ICD10",DiagnosisCodes=x4$DiagnosisCodes,count=x4$n)
x6 <- createPhenotypes(x5, min.code.count=1,
add.phecode.exclusions=T, translate=T,
2
full.population.ids=unique(x5[[1]]),
aggregate.fun=PheWAS:::default_code_agg,
vocabulary.map=PheWAS::phecode_map_icd10,
rollup.map=PheWAS::phecode_rollup_map,
exclusion.map=PheWAS::phecode_exclude)
## The results are TRUE/FALSE/NA ##
## For counting number of patients with T1D and T2D (T1D phecode=250.1, T2D phecode=250.2) ##
which(x6$’250.1’==TRUE)
which(x6$’250.2’==TRUE)
x7 <- as.data.frame(x6[,c(1,27)])
colnames(x7)[2] <- ’Codes’
x8 <- subset(x7, Codes) ## T1D Patient IDs with TRUE values ##
x9 <- as.data.frame(x6[,c(1,33)])
colnames(x9)[2] <- ’Codes’
x10 <- subset(x9, Codes) ## T2D Patient IDs with TRUE values ##
