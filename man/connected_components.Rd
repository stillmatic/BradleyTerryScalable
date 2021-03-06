% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connected_components.R
\name{connected_components}
\alias{connected_components}
\title{Checks whether MLE exists for Bradley-Terry model.}
\usage{
connected_components(W = NULL, g = NULL, return_components = TRUE,
  return_graph = FALSE)
}
\arguments{
\item{W}{A \eqn{K} by \eqn{K} square wins matrix (e.g. the output of \code{\link{pairs_to_matrix}}), where the \eqn{i,j}-th element is the number of times player \eqn{i} wins against player \eqn{j}, and \eqn{K} is the total number of players. Either \code{W} or \code{g} must be provided (see Details).}

\item{g}{A directed \code{\link[igraph]{igraph}} object. If \code{g} is unweighted, an edge from node \eqn{i} to \eqn{j} represents one win for player \eqn{i} over player \eqn{j} (and \eqn{n} edges from \eqn{i} to \eqn{j} represents \eqn{n} wins). If \code{g} is weighted, the weight on an edge from node \eqn{i} to \eqn{j} represents the number of times player \eqn{i} has beaten player \eqn{j}.}

\item{return_components}{Logical. When \code{TRUE}, the function will return the fully-connected components of the comparison graph \eqn{G_W} (see Details).}

\item{return_graph}{Logical. When \code{TRUE}, the function will return the comparison graph \eqn{G_W}, an \code{\link[igraph]{igraph}} object (see Details).}
}
\value{
Returns a list containing:

\item{\code{connected}}{Logical. Returns \code{TRUE} if the comparison graph associated with W is fully connected, \code{FALSE} otherwise.}
\item{\code{components}}{If \code{components} is set to \code{TRUE}, this returns a list of the fully connected components of \eqn{G_W}. This can be passed as the \code{components} argument to \code{\link{btfit}}.}
\item{\code{graph}}{If \code{graph} is set to \code{TRUE}, this returns the \code{\link[igraph]{igraph}} object of \eqn{G_W}.}
}
\description{
\code{connected_components} checks whether a unique, finite MLE for the Bradley-Terry model exists. It also returns the fully connected components of the comparison graph of \code{W}, which can be used in \code{\link{btfit}}.
}
\details{
As described by Ford (1957), if it is possible to partition the \eqn{K} players into two groups A and B such that there are never any comparisons between players in A and players in B, then there is no basis for rating any player in A with respect to any player in B. Conversely, if all intergroup comparisons are won by a player from the same group, then the likelihood of the Bradley-Terry model has no finite maximiser.

Therefore, the following assumption, known as Ford's assumption, must hold for a unique, finite maximiser of the log-likelihood function of the Bradley-Terry model to exist: in every possible partition of players into two non-empty subsets, some individual in the second set beats some individual in the first set at least once.

Let the players be nodes in a graph and let there be a directed edge \eqn{(i, j)} when \eqn{i} has won against \eqn{j} at least once. We call this the comparison graph of \code{W}, and denote it by \eqn{G_W}. Ford's assumption is equivalent to saying that there is a path from \eqn{i} to \eqn{j} for all nodes \eqn{i} and \eqn{j}, so that \eqn{G_W} is fully connected.

In \code{connected_components}, one of \code{W} or \code{g} must be provided. If the user already has the data represented as an \code{\link[igraph]{igraph}} object, it is faster to supply \code{g} than \code{W}, since if only given \code{W}, \code{connected_components} must converted it to an \code{\link[igraph]{igraph}} object anyway. \code{connected_components} then calls on functions from the \code{\link[igraph]{igraph}} package to check whether Ford's assumption holds for \eqn{G_W}. This will allow the user to decide how they wish to use the \code{\link{btfit}} function.
}
\examples{
## A fully connected comparison graph
set.seed(1)
W <- Matrix::rsparsematrix(10, 10 , 0.7, rand.x = function(n) rbinom(n, 10, 0.5))
connected_components(W)$connected
## A comparison graph which is not fully connected
set.seed(1)
W2 <- Matrix::rsparsematrix(20, 20 , 0.1, rand.x = function(n) rbinom(n, 10, 0.5))
connected_components(W2)$components
}
\references{
Ford, L. R. (1957) Solution of a Ranking Problem from Binary Comparisons. \emph{The American Mathematical Monthly}, \strong{64}(8, Part 2), 28-33.
}
\seealso{
\code{\link{pairs_to_matrix}}, \code{\link{btfit}}.
}

