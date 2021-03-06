\name{BootstrapRep}
\alias{BootstrapRep}
\title{Bootstrap analysis via ressampling}
\usage{
BootstrapRep(ind.data, ComparisonFunc = c("randomskewers", "mantel",
  "krzanowski"), iterations = 1000, correlation = F, num.cores = 1)
}
\arguments{
  \item{ind.data}{Matrix of residuals or indiviual
  measurments}

  \item{iterations}{Number of ressamples to take}

  \item{ComparisonFunc}{Comparison function for calculated
  statistic, either "randomskewers", "mantel" or
  "krznowski" correlations}

  \item{correlation}{If TRUE, correlation matrix is used,
  else covariance matrix. MantelCor always uses correlation
  matrix.}

  \item{num.cores}{Number of threads to use in computation.
  Requires doMC library.}
}
\value{
returns the mean repeatability, or mean value of
comparisons from samples to original statistic.
}
\description{
Calculates the repeatability of the covariance matrix of
the suplied data via bootstrap ressampling
}
\details{
Samples with replacement are taken from the full
population, a statistic calculated and compared to the full
population statistic.
}
\examples{
BootstrapRep(iris[,1:4], "mantel",
             iterations = 5,
             num.cores = 1)

BootstrapRep(iris[,1:4], "randomskewers", 50)

# Partial matching for comparison function also works.
BootstrapRep(iris[,1:4], "krz", 50, TRUE)
}
\author{
Diogo Melo, Guilherme Garcia
}
\seealso{
\code{\link{MonteCarloStat}}, \code{\link{AlphaRep}}
}
\keyword{bootstrap}
\keyword{repetabilities}

