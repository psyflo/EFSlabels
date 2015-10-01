# EFSlabels
An R package helping with Unipark EFS labels.

Install with the following commands: 
```{r}
install.packages("devtools")
devtools::install_github("psyflo/EFSlabels")
```
Load the package and use its function:
```{r}
library(EFSlabels)
df <- EFSlabels("data_project_206763_2015_09_23.csv","codebook_project_206763_2015_09_23")
head(df)
```
