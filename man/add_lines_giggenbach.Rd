% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/giggenbach_utilities.R
\name{add_lines_giggenbach}
\alias{add_lines_giggenbach}
\title{add_lines_giggenbach}
\usage{
add_lines_giggenbach(color = NULL, Size = NULL, dy = NULL)
}
\arguments{
\item{color}{A character string specifying the color of the lines separating 
mature and inmature waters.}

\item{Size}{A numeric value specifying the size of the temperature labels 
in the Giggenbach's geothermometer plot}

\item{dy}{A numeric value specifying the vertical displacement of the 
temperature labels in the Giggenbach's geothermometer plot}
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
Other giggenbach functions: \code{\link{ggplot_giggenbach}},
  \code{\link{plot_giggenbach}}
}
\author{
Oscar Garcia-Cabrejo, \email{khaors@gmail.com}
}
\concept{giggenbach functions}
