suppressMessages({
  library("sleuth")
  library("dplyr")
})

# ----------------------------------
# Set paths (customize if needed)
# ----------------------------------
datapath <- "/work/md40040/project"
resultdir <- "/work/md40040/project"
setwd(resultdir)

# ----------------------------------
# Define samples and conditions
# ----------------------------------
sample <- c("SRR23421854", "SRR23421855","SRR23421856","SRR23421857","SRR23421858","SRR23421859", "SRR23421860", "SRR23421861")
condition <- c("KO", "KO", "KO", "KO", "KO", "WT", "WT", "WT")
kallisto_dirs <- file.path(datapath, sample)

samples_to_conditions <- data.frame(sample, condition) %>%
  mutate(path = kallisto_dirs)

# ----------------------------------
# Load data into sleuth
# ----------------------------------
sleuth_object <- sleuth_prep(samples_to_conditions, 
                             extra_bootstrap_summary = TRUE, 
                             read_bootstrap_tpm = TRUE)

# Fit models
sleuth_object <- sleuth_fit(sleuth_object, ~condition, 'full')
sleuth_object <- sleuth_fit(sleuth_object, ~1, 'reduced')

# Likelihood ratio test
sleuth_object <- sleuth_lrt(sleuth_object, 'reduced', 'full')

# ----------------------------------
# Summarize and save significant results
# ----------------------------------
sleuth_table <- sleuth_results(sleuth_object, 'reduced:full', test_type = 'lrt', show_all = FALSE)
sleuth_significant <- sleuth_table %>% 
  filter(!is.na(qval), qval <= 0.05)

write.csv(x = sleuth_significant, file = "wt_vs_KO_sleuth_q_0.05.csv", row.names = FALSE)

# ----------------------------------
# Plot top DE genes (if available)
# ----------------------------------
if (nrow(sleuth_significant) >= 1) {
  n_plot <- min(10, nrow(sleuth_significant))
  top_targets <- sleuth_significant$target_id[1:n_plot]

  pdf(file = "SleuthResults.pdf")
  for (target in top_targets) {
    try({
      p1 <- plot_bootstrap(sleuth_object, target, units = "tpm", color_by = "condition")
      print(p1)
    }, silent = TRUE)
  }
  dev.off()
} else {
  message("No significant DE transcripts found (qval ≤ 0.05).")
}

# ----------------------------------
# Done
# ----------------------------------
q("no")
