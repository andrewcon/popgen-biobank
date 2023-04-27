DetermineK = function(mydata, kmax = 20, num_iter = 100, plotrepress=FALSE){
  ##############################
  ## 1. Kmeans
  ##############################
  K = lapply(1:kmax, function(k){
    kmeans(mydata, centers = k, iter.max = num_iter, nstart = 10 )
    })  
  
  ##############################
  ## 2. Within Group SumOfSquares
  ##############################
  WSS <- sapply(1:kmax,function(i){
    K[[i]]$tot.withinss
    })
  
  ##############################
  ## 2. Silhouette analysis
  ##############################
  sil = sapply(2:kmax, function(k){
    cluster::pam(mydata, k)$silinfo$avg.width
  })
  k.sil = which.max(sil) + 1
  
  ##############################
  ## 3. Silhouette analysis 2
  ##############################
  sil.est = fpc::pamk(mydata, krange=1:kmax)$nc
  
  ##############################
  ## 4. Plot
  ##############################
  if(plotrepress == 0){
    ## PLOT LAYOUT
    mat = matrix(c(1,2,3,3), ncol = 2, byrow = FALSE)
    layout(mat)
    ## Plot WSS
    plot(1:kmax, WSS, type="b", pch = 19, frame = FALSE, 
      xlab="Number of clusters K", 
      ylab="Tot. Within Clusters SS", 
      main = "Cluster Within Group\nSum of Squares")
    abline(v = sil.est , lty =2)
    #### PLOT Silhouette
    plot(c(0,sil), type = "b", pch = 19, frame = FALSE, 
      main = "Silhouette Analysis", 
      ylab  = "Avg Silhouette Width")
    abline(v = sil.est , lty =2)
    
    ### Distance Matrix
    d <- dist(mydata, method = "euclidean")
    plot(cluster::pam(d, sil.est))
  }
  # ##############################
  # ##  estimate the clusters
  # ##############################
  # K = kmeans(mydata, centers = sil.est, iter.max = num_iter, nstart = 10 )$cluster
  # ##
  # Krequested = kmeans(mydata, centers = desiredK, iter.max = num_iter, nstart = 10 )$cluster
  # ##############################
  ## 5. Prepare Output
  ##############################
  return(list( K = K, BestK = sil.est, WSS = WSS, Silhouette = sil  ))
  
    
}
