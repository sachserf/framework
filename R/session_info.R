session_info <- function(file = 'output/auto/documents/info/session_info.txt'){
  if (dir.exists(dirname(file)) == FALSE) {
    dir.create(dirname(file), recursive = TRUE)
  }
  sink(file)
  print(Sys.time())
  print(sessionInfo())
  sink()
  }

