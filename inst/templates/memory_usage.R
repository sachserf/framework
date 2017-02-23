#' calculate memory usage
#' 
#' @description Calculate the size of all objects within globalenv and baseenv.
#' @param units Character. Specify dimension of output. See ?utils::object.size for possible values.
#' @return A data frame with the sum of the size of all objects within the global environment and the base environment
#' @author Frederik Sachser
#' @export
memory_usage <- function(units = "B") {
  inner_fun <- function(x) {
    utils::object.size(x = get(x))
  }
  
  base_env_objects <- ls(envir = baseenv(), all.names = TRUE)
  global_env_objects <- ls(envir = globalenv(), all.names = TRUE)
  
  size_base_env <-
    sum(sapply(X = base_env_objects, FUN = inner_fun))
  size_global_env <-
    sum(sapply(X = global_env_objects, FUN = inner_fun))
  
  class(size_base_env) <- "object_size"
  class(size_global_env) <- "object_size"
  
  size_base_env <- format(size_base_env, units = units)
  size_global_env <- format(size_global_env, units = units)
  
  df_out <- data.frame("base_env" = size_base_env, "global_env" = size_global_env)
  row.names(df_out) <- "size"
  return(t(df_out))
}
