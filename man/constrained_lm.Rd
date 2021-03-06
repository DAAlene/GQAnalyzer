% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mixing_utilities.R
\name{constrained_lm}
\alias{constrained_lm}
\title{constrained_lm}
\usage{
constrained_lm(y, X, tol = 1e-12)
}
\arguments{
\item{y}{A column matrix with the y values}

\item{X}{The design matrix of the problem}

\item{tol}{A numeric value with the tolerance specified to avoid numerical instability
during the solution of the least-squares problem.}
}
\value{
This function returns a numeric vector with the values of the estimated coeffcicients.
}
\description{
Constrained least-squares function. The constraint included ensures that the sum of the
estimated coefficients is equal to 1 and the coefficients are positive.
}
\seealso{
Other mixing functions: \code{\link{m3_mixing_model}},
  \code{\link{mix_model}},
  \code{\link{plot_m3_mixing_results}},
  \code{\link{select_end_members}},
  \code{\link{uncertainty_m3_mixing_model}}
}
\author{
Oscar Garcia-Cabrejo, \email{khaors@gmail.com}
}
\concept{mixing functions}
