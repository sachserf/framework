summary_warnings <-
  function(filepath_warnings = "meta/warnings.Rout") {
    thelines <- readLines(filepath_warnings)
    thelines <- thelines[-grep(pattern = "^$", x = thelines)]

    warmes <- grep(pattern = "^##\040 *", x = thelines)
    normtxt <- seq_along(thelines)[!seq_along(thelines) %in% warmes]

    for (i in seq_along(thelines)) {
      if (i %in% warmes) {
        message(thelines[i])
      } else {
        print(thelines[i])
      }
    }
  }
