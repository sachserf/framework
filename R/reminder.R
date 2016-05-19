reminder <- 
function () 
{
  if (file.exists('.cache/df_cache_summary.rds') == FALSE) {
    saveRDS(object = data.frame(script = readRDS('.cache/df_cache.rds')$basename_in, instruction = readRDS('.cache/df_cache.rds')$instruction), file = '.cache/df_cache_summary.rds')
  }
  print(readRDS(file = '.cache/df_cache_summary.rds'))
  cat('\n')
  print("Don´t forget to add & commit snapshots and pull & push your git repository.")
}

