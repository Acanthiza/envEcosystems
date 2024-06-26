#
#' Create a dataframe of taxa percent cover for each cluster
#'
#' Optionally including structural information associated with each taxa.
#'
#' @param clust_df Dataframe with column indicating cluster membership.
#' @param clust_col Name of column in clustdf with cluster membership.
#' @param bio_df Dataframe with taxa records. Linked to clust_df by context.
#' @param context Name of columns defining the context.
#' @param cov_col Name of column in taxa_df with numeric cover values.
#' @param lustr Dataframe of structural information. Needs columns 'lifeform',
#' 'str' and 'storey': structure and storey, respectively. See lulifeform.
#'
#' @return Dataframe with structural information per cluster
#' @export

# Generate the structural percent cover for each cluster
make_eco_str_per <- function(clust_df
                        , clust_col = "cluster"
                        , bio_df
                        , context
                        , cov_col = "cover"
                        , lustr
                        ) {

  clust_df %>%
    dplyr::select(any_of(context),!!ensym(clust_col)) %>%
    dplyr::add_count(cluster, name = "cluster_sites") %>%
    dplyr::inner_join(bio_df %>%
                        dplyr::filter(!is.na(lifeform))
                      ) %>%
    # cover per lifeform*site (otherwise presences is per taxa, not per str)
    dplyr::group_by(!!ensym(clust_col),across(any_of(context)),lifeform,cluster_sites) %>%
    dplyr::summarise(cov = sum(!!ensym(cov_col))) %>%
    dplyr::ungroup() %>%
    dplyr::left_join(lustr) %>%
    dplyr::group_by(!!ensym(clust_col),lifeform,ht,str,storey,cluster_sites) %>%
    # cover per lifeform * ecosystem
    dplyr::summarise(presences = n()
                     , str = names(which.max(table(str)))
                     , storey = names(which.max(table(storey)))
                     , sum_cover = sum(cov)
                     , ht = mean(ht)
                     ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(per_pres = 100*presences/cluster_sites
                  , per_cov = 100*sum_cover/cluster_sites
                  , per_cov_pres = 100*sum_cover/presences
                  , str = factor(str, levels = levels(lustr$str))
                  , storey = factor(storey, levels = levels(lustr$storey), ordered = TRUE)
                  ) %>%
    dplyr::select(-sum_cover) %>%
    dplyr::arrange(!!ensym(clust_col),desc(ht)) %>%
    dplyr::mutate(storey = factor(storey,levels = levels(lustr$storey), ordered = TRUE))

}
