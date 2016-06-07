reminder <-
  function ()
  {
    print(data.frame(
      script = readRDS(".cache/df_cache.rds")$basename_in,
      instruction = readRDS(".cache/df_cache.rds")$instruction
    ))
    cat("\n")
    print("Don´t forget to add & commit snapshots and pull & push your git repository.")
  }
