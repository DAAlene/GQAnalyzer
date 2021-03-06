% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/piper_modified.R
\name{add_lines_modified_piper}
\alias{add_lines_modified_piper}
\title{add_lines_modified_piper}
\usage{
add_lines_modified_piper(color = NULL, Size = NULL)
}
\arguments{
\item{color}{A character string specifying the color of the lines separating 
mature and inmature waters.}

\item{Size}{A numeric value specifying the size of the temperature labels 
in the Giggenbach's geothermometer plot}
}
\value{
This function adds lines to define separate fields in the Giggenbach's 
geothermometer plot that has been previously created with the function 
ggplot_giggenbach
}
\description{
Auxiliary function to add the lines of the inmature and mature waters 
in a Giggenbach's geothermometer plot.
}
\seealso{
Other modified_piper functions: \code{\link{classification_reactions_piper_mode}},
  \code{\link{ggplot_modified_piper}},
  \code{\link{modified_piper_transform}},
  \code{\link{plot_modified_piper}}
}
\author{
Oscar Garcia-Cabrejo, \email{khaors@gmail.com}
}
\concept{modified_piper functions}
