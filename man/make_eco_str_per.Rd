% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_eco_str_per.R
\name{make_eco_str_per}
\alias{make_eco_str_per}
\title{Create a dataframe of taxa percent cover for each cluster}
\usage{
make_eco_str_per(
  clust_df,
  clust_col = "cluster",
  bio_df,
  context,
  cov_col = "cover",
  lustr
)
}
\arguments{
\item{clust_df}{Dataframe with column indicating cluster membership.}

\item{clust_col}{Name of column in clustdf with cluster membership.}

\item{bio_df}{Dataframe with taxa records. Linked to clust_df by context.}

\item{context}{Name of columns defining the context.}

\item{cov_col}{Name of column in taxa_df with numeric cover values.}

\item{lustr}{Dataframe of structural information. Needs columns 'lifeform',
'str' and 'storey': structure and storey, respectively. See lulifeform.}
}
\value{
Dataframe with structural information per cluster
}
\description{
Optionally including structural information associated with each taxa.
}
