#' Calculate mean values for various matrix statistics
#'
#' Calculates: Mean Squared Correlation, Autonomy, ConditionalEvolvability, Constraints, Evolvability, Flexibility, Pc1Percent, Respondability.
#' @aliases Autonomy ConditionalEvolvability Constraints Evolvability Flexibility Pc1Percent Respondability
#' @param cov.matrix A covariance matrix
#' @param iterations Number of random vectors to be used in calculating the stochastic statistics
#' @param full.results If TRUE, full distribution of statistics will be returned.
#' @param num.cores Number of threads to use in calculations. Requires doMC library.
#' @return dist Full distribution of stochastic statistics, only if full.resuts == TRUE
#' @return mean Mean value for all statistics
#' @export
#' @references Hansen, T. F., and Houle, D. (2008). Measuring and comparing evolvability
#' and constraint in multivariate characters. Journal of evolutionary
#' biology, 21(5), 1201-19. doi:10.1111/j.1420-9101.2008.01573.x
#' @author Diogo Melo Guilherme Garcia
#' @examples
#' cov.matrix <- cov(iris[,1:4])
#' MeanMatrixStatistics(cov.matrix)
#' @keywords Autonomy
#' @keywords ConditionalEvolvability
#' @keywords Constraints
#' @keywords Evolvability
#' @keywords Flexibility
#' @keywords Pc1Percent
#' @keywords Respondability
MeanMatrixStatistics <- function (cov.matrix, iterations = 1000, full.results = F, num.cores = 1) {
  if (num.cores > 1) {
    library(doMC)
    library(foreach)
    registerDoMC(num.cores)
    parallel = TRUE
  }
  else{
    parallel = FALSE
  }
  matrix.stat.functions = list ('respondability' = Respondability,
                                'evolvability' = Evolvability,
                                'conditional.evolvability' = ConditionalEvolvability,
                                'autonomy' = Autonomy,
                                'flexibility' = Flexibility,
                                'constraints' = Constraints)
  num.traits <- dim (cov.matrix) [1]
  beta.mat <- array (rnorm (num.traits * iterations), c(num.traits, iterations))
  beta.mat <- apply (beta.mat, 2, Normalize)
  iso.vec <- Normalize (rep(1, num.traits))
  null.dist <- abs (t (iso.vec) %*% beta.mat)
  null.dist <- sort (null.dist)
  crit.value <- null.dist [round (0.95 * iterations)]
  if(full.results) cat ('critical value: ', crit.value, '\n')
  MatrixStatisticsMap <- function (CurrentFunc) return (apply (beta.mat, 2, CurrentFunc, cov.matrix = cov.matrix))
  stat.dist <- t(laply (matrix.stat.functions, MatrixStatisticsMap, .parallel = parallel))
  stat.dist <- cbind (stat.dist, null.dist)
  colnames (stat.dist) <- c('respondability',
                            'evolvability',
                            'conditional.evolvability',
                            'autonomy',
                            'flexibility',
                            'constraints',
                            'null.dist')
  stat.mean <- colMeans (stat.dist[,-7])
  integration <- c (CalcR2 (cov2cor(cov.matrix)), Pc1Percent (cov.matrix))
  names (integration) <- c ('MeanSquaredCorrelation', 'pc1%')
  stat.mean <- c (integration, stat.mean)
  if(full.results)
    return (list ('dist' = stat.dist, 'mean' = stat.mean))
  else
    return (stat.mean)
}

#' @export
Autonomy <- function (beta, cov.matrix) return ((1/(t (beta) %*% solve (cov.matrix, beta))) / (t (beta) %*% cov.matrix %*% beta))
#' @export
ConditionalEvolvability <- function (beta, cov.matrix) return (1/(t (beta) %*% solve (cov.matrix, beta)))
#' @export
Constraints <- function (beta, cov.matrix) return (abs (t (Normalize (eigen (cov.matrix)$vectors[,1])) %*% Normalize (cov.matrix %*% beta)))
#' @export
Evolvability <- function (beta, cov.matrix) return (t (beta) %*% cov.matrix %*% beta)
#' @export
Flexibility <- function (beta, cov.matrix) return (t (beta) %*% cov.matrix %*% beta / Norm (cov.matrix %*% beta))
#' @export
Pc1Percent <- function (cov.matrix) return (eigen (cov.matrix)$values [1] / sum (eigen (cov.matrix)$values))
#' @export
Respondability <- function (beta, cov.matrix) return (Norm (cov.matrix %*% beta))
