Summary of steps performed for defining diabetes cases (T1D and T2D) and controls in the UKBB data
1. A large phenotype file is subsetted based on the Patient IDs (first column) and ICD9 and ICD10 codes 
2. The first 213 columns represent ICD10 codes with pattern ‘f.41270’ and the remaining column represent ICD9 codes with pattern ’f.41271 ’ in the ‘icdt’ ukbb file 
3. The first 214 columns were subsetted which comprised of Patient IDs and ICD10 codes 
4. Here, we used a R package ‘createPhenotypes’. This package requires ICD 9 and ICD 10 codes in the correct format 
5. Since, we are dealing with ICD10 codes which are alphanumeric codes comprised of either three, four or five characters 
6. UKBB ICD codes are in different format so we need to convert them in first the right format as required by the ‘createPhenotype’ package 
7. Example ICD10 codes are in the UKBB are, (E16,E119, or possibly E23145). The right format of ICD10 codes become for analysis (E16, E11.9, E231.45) 
8. The ICD 10 codes of interest are codes starting with ‘E’, as majority of them represent Diabetes 
9. In the first step, we filtered all patient IDs with ICD10 codes starting with ‘E’ 
10. In the second step, we place ‘dot’ after three characters in ICD10 codes required by R package for phecode conversion 
11. After placing dots, there were majority of ICD10 codes which were not recognized by phecode_map_icd10 in the PheWAS package, so here I join the formatted ICD10 code column with the Phecode_map_IC10 column with correct codes using ‘fuzzyjoin’ package 
12. I extracted the Patient IDs and correct ICD10 codes from the file and further use the ‘count’ function to count the IDs & code pair in file 
13. In the final input file, 1st column = patient IDs, 2nd Column = vocabulary id which is ‘ICD10’, third column = ICD10 codes, 4th Column = count 
14. Next we will apply, createPhenotypes function with minimum code count=1 
15. In the results, we got a data frame with first column of Patient IDs and the rest of them are Phecodes.Our Phecodes of interest are 250.1 (T1D) and 250.2 (T2D) which are cases 
16. Exclusion phecodes are 249 and 250 and they need to be removed from Controls 
17. Control IDs were obtained by excluding T1D, T2D and exclusion codes IDs from all UKBB ids which were almost half million 
