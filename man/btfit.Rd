% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BTfit.R
\name{btfit}
\alias{btfit}
\title{Fits the Bradley-Terry model}
\usage{
btfit(W, a, b = NULL, components = NULL, ML_method = c("MM", "ILSR"),
  maxit = 10000, epsilon = 0.001)
}
\arguments{
\item{W}{A \eqn{K} by \eqn{K} square wins matrix (e.g. the output of \code{\link{pairs_to_matrix}}), where the \eqn{i,j}-th element is the number of times player \eqn{i} wins against player \eqn{j}, and \eqn{K} is the total number of players.}

\item{a}{Must be >= 1. When \code{a = 1}, the function returns the MLE estimate of \eqn{pi} (by component, if necessary). When \code{a > 1}, \code{a} is the shape parameter for the Gamma prior (See Details).}

\item{b}{The rate parameter for the Gamma prior (See Details). When \code{a = 1}, \code{btfit} returns the MLE and this argument is ignored. If \code{b = NULL} (the default) when \code{a > 1}, then \code{b} is set to \eqn{aK - 1}.}

\item{components}{The fully-connected components of \eqn{G_W}, as calculated by \code{\link{connected_components}}. If the MLE is requested (i.e. if \code{a = 1}) and \code{components = NULL}, \code{btfit} will calculate the components within the function, but for large matrices, this is time consuming, so we recommend passing in the components as an argument (especially as \code{\link{connected_components}} should be run before \code{btfit} in any case). If \code{a > 1} then components are not necessary, but if they are provided, the function will return the penalised \eqn{pi} by component.}

\item{ML_method}{The algorithm to be used when finding the MLE. By default this is set to \code{MM} but \code{ILSR} can also be selected (See Details).}

\item{maxit}{The maximum number of iterations for the algorithm. If returning \code{pi} by component, this will be the maximum number of iterations for each component.}

\item{epsilon}{Determines when the algorithm is deemed to have converged. (See Details.)}
}
\value{
\code{btfit} returns an S3 object of class \code{"btfit"}, which has \code{print}, \code{summary} and \code{\link{fitted.btfit}} methods. It is a list containing at least the following components:
\item{pi}{The stregth parameter for the Bradley-Terry model. If \code{a = 1}, this is the MLE. If \code{a > 1}, this is the MAP estimate. If components are provided, or the MLE estimate is requested but \eqn{G_W} is not fully connected, then \code{pi} is list of length \eqn{M}, where \eqn{M} is the number of fully-connected components of \eqn{G_W} of two or more players. The \eqn{m}-th item is a vector \eqn{\pi} for the players in the \eqn{m}-th fully connected component, \eqn{m = 1, \ldots, M}.}
\item{iters}{A vector of length \eqn{M}. The \eqn{m}-th entry is the number of iterations it took for the algorithm to converge for the \eqn{m}-th component, for \eqn{m = 1, \ldots, M}. Note that if the algorithm has not converged in any component, a warning will be produced.}
\item{converged}{A logical vector of length \eqn{M}, indicating whether the algorithm has converged for the \eqn{m}-th component in \code{maxit} iterations.}
\item{N}{A matrix where each element \eqn{n_{ij}} is the number of times player \eqn{i} played against player \eqn{j}. Or, if the model has been fitted on the fully-connected components of \eqn{G_W}, a list of such matrices for each fully-connected component.}
\item{diagonal}{A vector of the diagonal elements of the original \code{W} matrix. Or, if the model has been fitted on the fully-connected components of \eqn{G_W}, a list of vectors of the diagonal elements for each submatrix of \code{W} corresponding to each component.}
\item{names_dimnames}{The names of the dimnames of the original \code{W} matrix. Or, if the model has been fitted on the fully-connected components of \eqn{G_W}, a list of the dimnames for each submatrix of \code{W} corresponding to each component. This will be \code{NULL} if \code{W} does not have named dimnames.}
}
\description{
\code{btfit} fits the Bradley-Terry model on (potentially) large and sparse datasets.
}
\details{
Let there be \eqn{K} players, let \eqn{\pi_k} be the Bradley-Terry strength parameter of player \eqn{k}, for \eqn{k = 1, \ldots, K} and let \eqn{\pi} be the vector of all the \eqn{\pi_k}. Let \eqn{w_{ij}} be the number of times player \eqn{i} wins against player \eqn{j}, let \eqn{n_{ij} = w_{ij} + w_{ji}} be the number of times they play, with \eqn{w_{ii} = 0} by convention and let \eqn{W_i = \sum_{j=1}^K w_{ij}}. Then the Bradley-Terry model states that the probability of player \eqn{i} beating player \eqn{j}, \eqn{p_{ij}}, is:

\deqn{p_{ij} = \frac{\pi_i}{\pi_i + \pi_j}.}

Assuming that Ford's assumption holds (see \code{\link{connected_components}}), the MLE of the Bradley-Terry model can be found either using the MM-algorithm (Hunter, 2004) or the Iterative-Luce Spectral Ranking (ILSR) (Maystre & Grossglauser, 2015). Setting \code{ML_method} argument to \code{MM} and \code{ILSR} uses the MM-algorithm and ILSR respectively.

If Ford's assumption does not hold (see \code{\link{connected_components}}), there are two principled options for fitting the Bradley-Terry model. One is to find the MLE within each fully-connected component. The other is to find the Bayesian MAP estimate, as suggested by Caron & Doucet (2012), where a \eqn{Gamma(a,b)}  gamma prior is placed on each \eqn{\pi_i}, and the product of these is taken as a prior on \eqn{\pi}. The MAP estimate can then be found with an EM-algorithm. When \eqn{a = 1} and \eqn{b = 0}, the EM and MM-algorithms are eqivalent and the MAP estimate and MLE are identical.

In the \code{btfit} function, the MLE within each fully-connected component can be found by setting \code{a = 1}. Additionally, the fully-connected components (e.g. the \code{components} output from the \code{\link{connected_components}} function) can be passed to the \code{components} argument. If \code{a = 1} and the \code{components} arguemnt is left as the default \code{NULL}, then the components are calculated within the \code{btfit} function. This can be computationally expensive for large \code{W}, so it is highly recommended to pass in \code{components}, especially since these are generated by \code{\link{connected_components}}, and the suggested workflow is always to run that function before \code{btfit} in order to determine which method of fitting the Bradley-Terry model is most appropriate for the data.

The likelihood equations give

\deqn{a - 1 + W_i = b\pi_i + \sum_{j \neq i} \frac{n_{ij}\pi_i}{\pi_i + \pi_j},}

for \eqn{i = 1, \ldots, K}. For the algorithm to have converged, we \eqn{\pi} to be such that the LHS and RHS of this equation are close for all \eqn{i}. Therefore, we set the convergence criteria as

\deqn{\left|\frac{a - 1 + W_i}{b\pi_i + \sum_{j \neq i} \frac{n_{ij}\pi_i}{\pi_i + \pi_j}} - 1\right| < \epsilon,}

for all \eqn{i}.
}
\examples{
W_connected <- Matrix::rsparsematrix(10, 10 , 0.5, rand.x = function(n) rbinom(n, 10, 0.5))
i <- c(3,1,5,4,2,5,5,7,8,5,6,8,7)
j <- c(1,2,2,3,4,4,6,6,6,7,7,7,8)
dimnames = list(letters[1:8], letters[1:8])
W_not_connected <-  Matrix::sparseMatrix(i, j, x = 1:13, dims = c(8,8), dimnames = dimnames)
W_components <- connected_components(W_not_connected)$components
fit1 <- btfit(W_connected, 1)
fit2 <- btfit(W_not_connected, 1, components = W_components)
fit3 <- btfit(W_not_connected, 3)
}
\references{
Caron, F. and Doucet, A. (2012) Efficient Bayesian Inference for Generalized Bradley-Terry Models. \emph{Journal of Computational and Graphical Statistics}, \strong{21}(1), 174-196.

Hunter, D. R. (2004) MM Algorithms for Generalized Bradley-Terry Models. \emph{The Annals of Statistics}, \strong{32}(1), 384-406.

Maystre, L. and Grossglauser, M. (2015) Fast and accurate inference of Plackett-Luce models. In \emph{Advances in Neural Information Processing Systems 28 (NIPS 28)}.
}
\seealso{
\code{\link{connected_components}}, \code{\link{fitted.btfit}}, \code{\link{btprob}}
}

