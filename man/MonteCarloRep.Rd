\name{MonteCarloRep}
\alias{MonteCarloRep}
\title{Parametric repeatabilities with covariance or correlation matrices}
\usage{
MonteCarloRep(cov.matrix, ComparisonFunc = c("randomskewers", "mantel",
  "krzanowski"), sample.size, iterations = 1000, correlation = F,
  num.cores = 1)
}
\arguments{
  \item{cov.matrix}{Covariance matrix.}

  \item{ComparisonFunc}{Comparison function for calculated
  statistic, either "randomskewers", "mantel" or
  "krznowski" correlations}

  \item{sample.size}{Size of the random populations}

  \item{iterations}{Number of random populations}

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
Using a multivariate normal model, random populations are
generated using the suplied covariance matrix. A statistic
is calculated on the random population and compared to the
statistic calculated on the original matrix.
}
\details{
Since this function uses multivariate normal model to
generate populations, only covariance matrices should be
used.
}
\examples{
cov.matrix <- RandomMatrix(10, 1, 1, 10)

MonteCarloRep(cov.matrix, "randomskewers", 30)
MonteCarloRep(cov.matrix, "mantel", 30)
MonteCarloRep(cov.matrix, "krz", 30)
MonteCarloRep(cov.matrix, "krz", 30, TRUE)

#Creating repeatability vector for a list of matrices
mat.list <- RandomMatrix(10, 3, 1, 10)
unlist(lapply(mat.list, MonteCarloRep, "krz", 30, correlation = TRUE))
}
\author{
Diogo Melo Guilherme Garcia
}
\seealso{
\code{\link{BootstrapRep}}, \code{\link{AlphaRep}}
}
\keyword{montecarlo}
\keyword{parametricsampling}
\keyword{repeatability}

