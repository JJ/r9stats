library(rjson)
library(ggplot2)
library(ggthemes)
library(dplyr)
library(reshape2)
library(ggmap)


all.data <- fromJSON(file="r9-user-info.json")
data.df <- data.frame(os=character(),
                      registrado=as.Date(character()),
                      inscrito=as.Date(character()),
                      lenguaje=character(),
                      sexo=character(),
                      city=character(),
                      lat=double(),
                      lon=double(),
                      asistira=character()
                      )

for ( i in 1:length(all.data) ) {
    if ( ! is.null(all.data[[i]]$os) )  {
        os = all.data[[i]]$os
    } else {
        os = ""
    }
    if ( ! is.null(all.data[[i]]$lenguajes) )  {
        lenguajes = all.data[[i]]$lenguajes
    } else {
        lenguajes = ""
    }
    if ( ! is.null(all.data[[i]]$sexo) )  {
        sexo = all.data[[i]]$sexo
    } else {
        sexo = "X"
    }
    data.df <- rbind( data.df,
                     data.frame(os=os,
                                lenguajes=lenguajes,
                                registrado=as.Date(all.data[[i]]$registrado/1000,origin="1970-01-01"),
                                inscrito=as.Date(all.data[[i]]$inscrito/1000,origin="1970-01-01"),
                                sexo=sexo,
                                lon=all.data[[i]]$lon,
                                lat=all.data[[i]]$lat,
                                city=all.data[[i]]$city,
                                asistira=all.data[[i]]$asistira)
                     )
}
write.csv(data.df,file='r9-users-data.csv')
ggplot(data.df,aes(x=sexo))+geom_bar(stat="count")



oss.data <- fromJSON(file="r9-user-oss.json")
oss <- data.frame(os=names(oss.data),usuarios=c(oss.data$windows,oss.data$linux,oss.data$mac))
ggplot(oss,aes(x=os,y=usuarios))+geom_bar(stat="identity")


l.data <- fromJSON(file="r9-user-lenguajes.json")
l <- do.call(rbind, lapply(l.data, data.frame, stringsAsFactors=FALSE))
lenguajes <- data.frame( lenguaje = rownames(l), usuarios=l$X..i..)
lenguajes <- dplyr::filter(lenguajes, !grepl("-",lenguaje))
lenguajes <- lenguajes[ lenguajes$usuarios > 1, ]

ggplot(lenguajes,aes(x=reorder(lenguaje,-usuarios),y=usuarios))+geom_bar(stat="identity") + theme_tufte()+ theme(axis.text.x = element_text(angle = 90, hjust = 1))+xlab('lenguajes')



