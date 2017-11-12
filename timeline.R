library(timelineS)
library(ggplot2)
library(scales)
data <- read.csv("../../Documentos/IX_Jornadas_de_Usuarios_de_R.csv",sep="\t")
event.data <- data.frame(user=data$Identificador.del.usuario,
                         date=as.Date(data$RSVP.el,format="%m/%d/%Y"))
label.length <- c(1:9)*0.1
timelineS(event.data, main="Inscripción usuarios jornadas R-9",label.length=as.vector(rbind(label.length,label.length)),buffer.days=7)
ggplot(data,aes(x=as.Date(data$RSVP.el,format="%m/%d/%Y")))+geom_histogram()+scale_x_date(date)
ggplot(data,aes(x=as.Date(data$RSVP.el,format="%m/%d/%Y")))+geom_histogram(bins=16)+scale_x_date()+xlab("Mes")
