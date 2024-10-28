library(sf)
library(leaflet)
library(here)
library(dplyr)

url <- paste0(
  "https://gis.lmi.is/geoserver/wfs?request=GetFeature&service=WFS&version=1.1.0&typeName=LMI_vektor:Sveitarfelog_timalina&outputFormat=SHAPE-ZIP"
)

download.file(
  url,
  here("data-raw", "sveitarfelog", "sveitarfelog.zip"),
  method = "auto"
)

unzip(
  here("data-raw", "sveitarfelog", "sveitarfelog.zip"),
  exdir = here("data-raw", "sveitarfelog")
)



d <- st_read(
  here("data-raw", "sveitarfelog", "Sveitarfelog_timalina.shp"),
  options = "ENCODING=ISO-8859-10"
)

d <- d |> 
  filter(endir_tima == max(endir_tima))

d |> 
  st_transform(crs = "WGS84") |> 
  leaflet() |> 
  addProviderTiles(providers$OpenStreetMap) |> 
  addPolygons(
    weight = 2,
    opacity = 1,
    color = "blue",
    dashArray = "3",
    fillOpacity = 0.3,
    highlightOptions = highlightOptions(
      weight = 5,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE
    ),
    label = ~ sveitarfel,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto")
  )


st_write(
  d,
  here("data", "sveitarfelog", "sveitarfelog.shp")
)






