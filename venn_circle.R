#how to draw a venn diagram using the ggplot2 syntax with ggforce.
#sebastien.renaut@gmail.com
#November 2018

#for Charlotte Capt


#required packages
library(ggplot2)
library(ggforce)

#coordinates of the 3 circles
circle.positions <- data.frame(x = c(0, 0.866, -0.866),y = c(1, -0.5, -0.5),labels = c('HM', 'HF', 'MF'))

#data 
circle.data = data.frame(x.position = c(0, 1.4, -1.4,0.8, -0.8, 0, 0),y.position = c(1.6,-0.6,-0.6, 0.5,0.5, -1, 0),
                         categories = c("hm","hf","mf","hmhf","hmmf","hfmf","hmhfmf"),counts=c(100,90,80,10,9,8,1),
                         counts_totals=c("120 (overexpressed: 30H / 90M)","109 (overexpressed: 29H / 80F)","98 (overexpressed: 9M / 90F)",0,0,0,0))

####ggplot + geom_circle function
#geom_circle will draw the circles, with various options to make it prettier
#annotate will add text
venn = ggplot(circle.positions) +
  geom_circle(aes(x0 = x, y0 = y, r = 1.5, fill = labels), alpha = .3, size = 1,colour="black") +
  coord_fixed() +
  theme_void() +
  theme(legend.position = 'bottom') +
  scale_fill_manual(values = c('cornflowerblue', 'firebrick',  'gold')) +
  labs(fill = NULL) +
  annotate("text", x = circle.data$x.position, y = circle.data$y.position+0.2, label = circle.data$counts, size = 5) +
  annotate("text", x = circle.data$x.position[1:3], y = circle.data$y.position[1:3]-0.2, label = circle.data$counts_totals[1:3], size = 3)


#save graph as pdf on the desktop 
dev.new(width=6, height=6,noRStudioGD = TRUE)
venn
dev.print(device=pdf,"~/Desktop/venn_figure.pdf", onefile=FALSE)
dev.off()
