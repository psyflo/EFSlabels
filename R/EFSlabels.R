# Hello, world!  This is an example function named 'hello' which prints 'Hello, world!'.  You can learn more
# about package authoring with RStudio at: http://r-pkgs.had.co.nz/ Some useful keyboard shortcuts for package
# authoring: Build and Reload Package: 'Cmd + Shift + B' Check Package: 'Cmd + Shift + E' Test Package: 'Cmd +
# Shift + T'

.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Welcome to my EFSlabels v0.1\nCall the function with EFSlabels()")
}

#' Label data exported from unipark.
#'
#' \code{EFSlabels} returns a data frame with labeled values for each variable found in the codebook.
#'
#' The parameter \code{dataFileLocation} should point to the location of the .csv file on your drive.
#' \code{codebookFileLocation} should point to the location of the .csv codebook file.
#' Export this file from unipark by selecting Documentation > Codebook > Export > Export as CSV.
#'
#' @param dataFileLocation A .csv file exported from unipark.
#' @param codebookFileLocation The codebook file exported from unipark (.csv with UTF-8, NOT from 'Export variable names for external editing').
#' @return A data frame \code{dataFileLocation} with labels from \code{codebookFileLocation}.
#' @examples
#' df <- EFSlabels("data_project_206763_2015_09_23.csv","codebook_project_206763_2015_09_23")
#' head(df)
EFSlabels <- function(dataFileLocation, codebookFileLocation) {
    df <- read.csv(dataFileLocation, header = T, sep = ";", na.strings = c("-77", "-99", "-66"))
    names(df)

    df_names <- readLines(codebookFileLocation)

    for (name in colnames(df)) {
        # do this for each comlumname
        loc <- grep(paste("\t", name, "\t", sep = ""), df_names)  # find location of column name in file

        if (length(loc) == 1) {
            # do this only if a column name was found
            i <- 1  # start value, go through all possible levels

            lvlvect <- c()
            while (df_names[loc + i] != "" &
                   length(grep("v_", df_names[loc + i], invert = TRUE)) != 0) {
                # enter this loop only if a subsequent row is not empty (this indicates change of page) and if next row does not
                # include a 'v_' (this indicates a new question)

                # strip everything before the last tab '\t'
                level <- strsplit(df_names[loc + i], "\t")[[1]][3]
                label <- strsplit(df_names[loc + i], "\t")[[1]][4]
                lvlvect <- rbind(lvlvect, data.frame(label, level))
                # lvlvect <- c(lvlvect,df_names[loc+i]) # create a vector including all levels
                i <- i + 1  # increment
            }
            if (length(lvlvect) != 0) {
                # cat(name)
                print(lvlvect)
                print(strsplit(df_names[loc], "\t")[[1]][4])
                df[, name] <- factor(df[, name], levels = lvlvect[, "level"], labels = lvlvect[, "label"])
            }
        } else {
            cat(paste(name, " not found\n", sep = ""))
        }
    }
    return(df)
}
