library(rjson)
library(ggplot2)
library(ggthemes)
library(dplyr)

oss.data <- fromJSON(file="r9-user-oss.json")
oss <- data.frame(os=names(oss.data),usuarios=c(oss.data$windows,oss.data$linux))
ggplot(oss,aes(x=os,y=usuarios))+geom_bar()


l.data <- fromJSON(file="r9-user-lenguajes.json")
l <- do.call(rbind, lapply(l.data, data.frame, stringsAsFactors=FALSE))
lenguajes <- data.frame( lenguaje = rownames(l), usuarios=l$X..i..)
lenguajes <- dplyr::filter(lenguajes, !grepl("-",lenguaje))
lenguajes <- lenguajes[ lenguajes$usuarios > 1, ]

ggplot(lenguajes,aes(x=reorder(lenguaje,-usuarios),y=usuarios))+geom_bar(stat="identity") + theme_tufte()+ theme(axis.text.x = element_text(angle = 90, hjust = 1))+xlab('lenguajes')



