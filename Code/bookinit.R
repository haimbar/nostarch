## 1. Dynamically find or create the default personal library path
user_lib <- Sys.getenv("R_LIBS_USER")

## 2. Create the directory if it doesn't exist yet
if (!dir.exists(user_lib)) {
  dir.create(user_lib, recursive = TRUE, showWarnings = FALSE)
}

## 3. Install the package into that personal library
if (! ("lattice" %in% installed.packages()))
	install.packages("lattice", repos = "https://cloud.r-project.org", lib = user_lib)
library("lattice")
if (! ("xtable" %in% installed.packages()))
	install.packages("xtable", repos = "https://cloud.r-project.org", lib = user_lib)
library("xtable")
if (! ("pastecs" %in% installed.packages()))
	install.packages("pastecs", repos = "https://cloud.r-project.org", lib = user_lib)
library("pastecs")
if (! ("pracma" %in% installed.packages()))
	install.packages("pracma", repos = "https://cloud.r-project.org", lib = user_lib)
library("pracma")
