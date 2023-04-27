#!/usr/bin/env Rscript

library(data.table)

my_path <- #

fst_pairs <- list.files(
    path = my_path, 
    pattern = "^K", 
    full.names = FALSE
)
fst_pairs <- strsplit(fst_pairs, "_")
fst_names <- list.files(
    path = my_path, 
    pattern = "chr.1-22.fst",
    recursive = TRUE, 
    full.names = TRUE
)
names(fst_pairs) <- fst_names

fst_table <- data.table(
    X = character(),
    Y = character(),
    Min = numeric(),
    Qr_1 = numeric(),
    Median = numeric(),
    Mean = numeric(),
    Qr_1 = numeric(),
    Max = numeric(),
    NAs = integer()
)
for(n in 1:length(fst_pairs)) {
    file_path <- names(fst_pairs)[n]
    f <- fread(file_path, stringsAsFactors = FALSE, select = "Fst")
    row_summary <- summary(f$Fst)
    fst_row <- data.table(
        X = fst_pairs[[n]][1],
        Y = fst_pairs[[n]][2],
        Min = row_summary[[1]],
        Qr_1 = row_summary[[2]],
        Median = row_summary[[3]],
        Mean = row_summary[[4]],
        Qr_1 = row_summary[[5]],
        Max = row_summary[[6]],
        NAs = row_summary[[7]]
    )
    fst_table <- rbind(fst_table, fst_row)
}

fwrite(fst_table, "#.txt", quote = F, row.names = F, na = NA, sep = "\t")

fst_matrix <- fst_table[, c("X", "Y", "Mean", "Median", "Max")]
fst_matrix <- rbind(fst_matrix, data.table(X = fst_matrix$Y, Y = fst_matrix$X, Mean = fst_matrix$Mean, Median = fst_matrix$Median, Max=fst_matrix$Max))
fst_matrix <- rbind(fst_matrix, data.table(X = paste0("K", 1:7), Y = paste0("K", 1:7), Mean = rep(0, 0, 7), Median = rep(0, 0, 7), Max = rep(0, 0, 7)))

fwrite(fst_matrix, "#.txt", quote = F, row.names = F, na = NA, sep = "\t")
