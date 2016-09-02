#' Install and attach packages
#' 
#' @description The function checks if the specified packages are installed.
#'   Packages that are not installed are going to be installed.
#' @param pkg_names Character. A vector specifying the names of packages you
#'   want to install.
#' @param attach Logical. If TRUE the packages will be loaded.
#' @author Frederik Sachser
#' @export
pkg_install <- 
function(pkg_names, attach = TRUE) 
{
    exist_pack <- pkg_names %in% rownames(utils::installed.packages())
    if (any(!exist_pack)) 
        utils::install.packages(pkg_names[!exist_pack])
    if (attach == TRUE) 
        lapply(pkg_names, library, character.only = TRUE)
}
