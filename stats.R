library(rjson)
library(ggplot2)
library(ggthemes)
library(dplyr)
library(reshape2)


all.data <- fromJSON(file="r9-user-info.json")
data.df <- data.frame(os=character(),
                      registrado=as.Date(character()),
                      inscrito=as.Date(character()),
                      lenguaje=character(),
                      sexo=character())

for ( i in 1:length(all.data) ) {
    if ( ! is.null(all.data[[i]]$os) )  {
        os = all.data[[i]]$os
    } else {
        os = ""
    }
    if ( ! is.null(all.data[[i]]$lenguajes) )  {
        lenguajes = all.data[[i]]$os
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
                                registrado=as.Date(all.data[[i]]$registrado,format="%m/%d/%Y"),
                                inscrito=as.Date(all.data[[i]]$inscrito,format="%m/%d/%Y"),
                                sexo=sexo )
                     )
}
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



