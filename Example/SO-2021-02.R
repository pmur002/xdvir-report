#Add libraries
library(here)
library(rosm)
library(prettymapr)

#Generate fake data
gpsdata <- data.frame("Clusters" = c(1,2), "Latitudes" = c(38.896357, 37.819039), "Longitudes" = c(-77.036562, -122.478556))

#Initiate PDF
pdf(file = here::here('multiplemaps.pdf'), width = 8, height = 11)

#For loop over individual clusters
for (loc in gpsdata$Clusters){
  
  #Create subsets of relevant datapoints and cluster
  subclusters <- subset(gpsdata,Clusters==loc)
  
  #Create bounding box
  boundbox <- makebbox(n = subclusters$Latitudes[1]+0.005, e = subclusters$Longitudes[1]+0.003, 
                       s = subclusters$Latitudes[1]-0.005, w = subclusters$Longitudes[1]-0.003)
  
  #Split into map and text plot
  layout(mat = matrix(c(1,2),nrow =2, ncol=1),
         heights = c(8,3),
         widths = 1)
  
  #Generate map plot using prettymapr
  prettymap({
    
    #Set map zoom
    my_zoom <- rosm:::tile.raster.autozoom(extract_bbox(matrix(boundbox,ncol=2,byrow=TRUE)),epsg=4326)
    
    #Make primary plot
    osm.plot(boundbox, zoom = my_zoom, zoomin = -1)
    
    #Add centroid in blue
    osm.points(subclusters$Longitudes, subclusters$Latitudes, pch = 21, col = 'black', bg = 'blue',cex = 5)
  },
  
  #Generate text below plot
  title = paste0("\n\n\n\n\nLocation: ", subclusters$Location, "\n", 
                 "Cluster Centroid Coordinates: ", round(subclusters$Latitudes,5), ",",round(subclusters$Longitudes,5)))
}
dev.off()
