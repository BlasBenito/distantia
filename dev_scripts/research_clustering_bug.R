#for large datasets, parallelization accelerates cluster optimization
future::plan(
  future::multisession,
  workers = 2 #set to parallelly::availableCores() - 1
)

#progress bar
# progressr::handlers(global = TRUE)

#weekly covid prevalence in California counties
data("covid_prevalence")

#load as tsl
tsl <- tsl_initialize(
  x = covid_prevalence,
  name_column = "name",
  time_column = "time"
)

#subset 10 elements to accelerate example execution
tsl <- tsl_subset(
  tsl = tsl,
  names = 1:10
)

#aggregateto monthly data to accelerate example execution
tsl <- tsl_aggregate(
  tsl = tsl,
  new_time = "months",
  fun = sum
)

if(interactive()){
  #plotting first three time series
  tsl_plot(
    tsl = tsl_subset(
      tsl = tsl,
      names = 1:3
    ),
    guide_columns = 3
  )
}

#dissimilarity analysis
distantia_df <- distantia(
  tsl = tsl
)

#hierarchical clustering with a given number of clusters
#-------------------------------------------------------
distantia_clust <- distantia_cluster_hclust(
  df = distantia_df,
  clusters = 5, #arbitrary number!
  method = "complete"
)

#names of the output object
names(distantia_clust)

#cluster object
distantia_clust$cluster_object

#distance matrix used for clustering
distantia_clust$d

#number of clusters
distantia_clust$clusters

#clustering data frame
#group label in column "cluster"
#negatives in column "silhouette_width" higlight anomalous cluster assignation
distantia_clust$df

#mean silhouette width of the clustering solution
distantia_clust$silhouette_width

#plot
if(interactive()){

  clust <- distantia_clust$cluster_object
  k <- distantia_clust$clusters

  #tree plot
  plot(
    x = clust,
    hang = -1
  )

  #highlight groups
  stats::rect.hclust(
    tree = clust,
    k = k,
    cluster = stats::cutree(
      tree = clust,
      k = k
    )
  )

}


#optimized hierarchical clustering
#---------------------------------

#auto-optimization of clusters and method
distantia_clust <- distantia_cluster_hclust(
  df = distantia_df,
  clusters = NULL,
  method = NULL
)

#names of the output object
#a new object named "optimization" should appear
names(distantia_clust)

#first rows of the optimization data frame
#optimized clustering in first row
head(distantia_clust$optimization)

#plot
if(interactive()){

  clust <- distantia_clust$cluster_object
  k <- distantia_clust$clusters

  #tree plot
  plot(
    x = clust,
    hang = -1
  )

  #highlight groups
  stats::rect.hclust(
    tree = clust,
    k = k,
    cluster = stats::cutree(
      tree = clust,
      k = k
    )
  )

}

#disable parallelization
future::plan(
  future::sequential
)
