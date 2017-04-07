
#Helpful formulae
  child_entropy <- function(target, split.var){
    
    tab <- table(target, split.var)
    p1 <- tab[1,1]/sum(tab[,1])
    p2 <- tab[1,2]/sum(tab[,2])
    n1 <- sum(tab[,1])/sum(tab[,1] + tab[,2])
    ent1 <- sum(-p1*log2(p1) + -(1-p1)*log2(1-p1), na.rm = T)
    ent2 <- sum(-p2*log2(p2) + -(1-p2)*log2(1-p2), na.rm = T)
    avg.ent <- (ent1 * n1) + (ent2 * (1 - n1))
    return(avg.ent)
  }
  
  1 - child_entropy(customers$user, customers$income)
  1- child_entropy(customers$user, customers$employ)
  1- child_entropy(customers$user, customers$area)
 