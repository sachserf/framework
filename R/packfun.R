packfun <- function(packlist = ..., NAMESPACE_only = FALSE){
  exist_pack <- packlist %in% rownames(installed.packages())
  if(any(!exist_pack)) install.packages(packlist[!exist_pack])
  if(NAMESPACE_only == FALSE) lapply(packlist, library, character.only = TRUE)
}