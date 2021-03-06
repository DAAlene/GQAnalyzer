% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geochemical_dataset_utilities.R
\name{plot_schoeller}
\alias{plot_schoeller}
\title{plot_schoeller}
\usage{
plot_schoeller(x, measure = c("conc", "meql"), vars = NULL,
  color = NULL, Size = NULL, labels = NULL, additional.args = NULL)
}
\arguments{
\item{x}{A geochemical dataset}

\item{measure}{The type of measure}

\item{vars}{variables}

\item{color}{color}

\item{Size}{size}

\item{labels}{Character variable that specifies the labels to be used in the current plot}

\item{additional.args}{A list with additional arguments}
}
\value{
A ggplot2 object with the corresponding Schoeller plot
}
\description{
Function to create a Schoeller plot
}
\author{
Oscar Garcia-Cabrejo, \email{khaors@gmail.com}
}
