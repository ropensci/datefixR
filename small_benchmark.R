#!/usr/bin/env Rscript

# Smaller performance benchmark to analyze optimization results
library(datefixR)
library(microbenchmark)

# Create smaller test data
set.seed(42)
n_dates <- 1000

test_dates <- c(
  # Simple formats that should be fast to process
  sample(c("01/12/2020", "31/12/2019", "15/05/2021", "28/03/2022"), n_dates/2, replace = TRUE),
  sample(c("2020-12-01", "2021-05-15", "2022-03-28", "2019-12-31"), n_dates/2, replace = TRUE)
)

# Create a test data frame
test_df <- data.frame(
  dates = test_dates,
  subject_id = paste0("ID_", 1:length(test_dates)),
  stringsAsFactors = FALSE
)

cat("Running smaller benchmark with", nrow(test_df), "dates...\n")

# Benchmark the fix_date_df function (which uses our optimized Rust backend)
benchmark_result <- microbenchmark(
  optimized_rust = fix_date_df(
    test_df, 
    col.names = "dates",
    id = "subject_id",
    day.impute = 1, 
    month.impute = 7, 
    format = "dmy"
  ),
  times = 10,
  unit = "ms"
)

print(benchmark_result)

# Let's also test single date performance to see if the issue is in R wrapper or Rust
cat("\nTesting single date processing time:\n")
single_benchmark <- microbenchmark(
  single_date = fix_date_char(c("01/12/2020"), day.impute = 1, month.impute = 7, format = "dmy"),
  times = 100,
  unit = "ms"
)
print(single_benchmark)

cat("\nOptimization analysis complete!\n")
