#' dsfrrgrsgdsgh
#' 
#' @description aswgarsg swegsdg
#' @author Frederik Sachser
#' @export
pkg_install <- 
function (pkg_names = ..., attach = TRUE) 
{
    exist_pack <- pkg_names %in% rownames(installed.packages())
    if (any(!exist_pack)) 
        install.packages(pkg_names[!exist_pack])
    if (attach == TRUE) 
        lapply(pkg_names, library, character.only = TRUE)
}
