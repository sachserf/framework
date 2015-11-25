set_ts <-
  function(target_dir = getwd(), cp = FALSE, info = FALSE, changewd = FALSE){
  orig_wd <- getwd()
  stime <- format(Sys.time(), format(Sys.time(), format="%Y%m%d-%A-%H%M%S"))
  if (file.exists(target_dir) == FALSE) dir.create(target_dir, recursive = TRUE)
  dir.create(paste(target_dir, stime, sep="/"))
  setwd(paste(target_dir, stime, sep="/"))
  if(info == TRUE) {
  dir.create("info/")
  write.table(Sys.info(), "info/SysInfo.txt")
  savehistory(file = "info/history.Rhistory")
  save.image("info/image.RData")
  sink(file= "info/SessionInfo.txt")
  print(sessionInfo())
  sink()
  sink(file= "info/SysGetenv.txt")
  print(Sys.getenv())
  sink()
  sink(file= "info/options.txt")
  print(options())
  sink()
  }
  if (cp != FALSE) dir.create("copy/")
  if (cp != FALSE) file.copy(cp, "copy/", copy.mode = TRUE, recursive = TRUE, copy.date = TRUE)
  if (changewd == FALSE) setwd(orig_wd)
}
