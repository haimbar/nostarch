drawPokerHands <- function(ncards=5, nplayers=4) {
  suits <- c(rep("C",13), rep("D",13), rep("H", 13), rep("S", 13))
  cards <- paste0(suits, rep(1:13, 4))
  if(ncards*nplayers > length(cards)) {
    stop("Too many players for one deck")
  }
  M <- matrix(sample(cards, ncards*nplayers, replace=FALSE),
              nrow=ncards, ncol=nplayers)
  colnames(M) <- paste0("Player", 1:nplayers)
  M
}
drawPokerHands()
drawPokerHands(nplayers=6)
