reminder <- 
function () 
{
  print(readRDS(file = '.cache/df_cache_summary.rds'))
  cat('\n')
  print("Don´t forget to add & commit snapshots and pull & push your git repository.")
}

