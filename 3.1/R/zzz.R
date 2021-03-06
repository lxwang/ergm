#  File R/zzz.R in package ergm, part of the Statnet suite
#  of packages for network analysis, http://statnet.org .
#
#  This software is distributed under the GPL-3 license.  It is free,
#  open source, and has the attribution requirements (GPL Section 7) at
#  http://statnet.org/attribution
#
#  Copyright 2003-2013 Statnet Commons
#######################################################################
.onAttach <- function(lib, pkg){
  sm <- statnetStartupMessage("ergm", c("statnet","ergm.count","tergm"), TRUE)
  if(!is.null(sm)){
    packageStartupMessage(sm)
    packageStartupMessage(paste(c(strwrap(paste("NOTE: If you use custom ERGM terms based on ",sQuote("ergm.userterms")," version prior to 3.1, you will need to perform a one-time update of the package boilerplate files (the files that you did not write or modify) from ",sQuote("ergm.userterms")," 3.1 or later. See help('eut-upgrade') for instructions.",sep="")),""),collapse="\n"))
    packageStartupMessage(paste(c(strwrap(paste("NOTE: Dynamic network modeling functionality (STERGMs) has been moved to a new package, ",sQuote("tergm"),".",sep="")),""),collapse="\n"))
  }
  
  # If the following have already been defined in the latentnet package, don't duplicate. Otherwise, assign them.
  IFNOTEXISTS <- c("robust.inverse","mcmc.diagnostics","mcmc.diagnostics.default","gof","gof.default")
  for(fun in IFNOTEXISTS){
    if(!exists(fun, mode="function")){
      assign(fun, get(paste('.',fun,sep='')), pos="package:ergm")
    }
  }
  
  .RegisterMHPs()
  .RegisterConstraintImplications()
  .RegisterInitMethods()
}

.RegisterMHPs <- function(){
  ergm.MHP.table("c", "Bernoulli", "",  0, "random", "randomtoggle")
  ergm.MHP.table("c", "Bernoulli", "bd",  0, "random", "randomtoggle")
  ergm.MHP.table("c", "Bernoulli", "",  1, "TNT", "TNT")
  ergm.MHP.table("c", "Bernoulli", "bd",  1, "TNT", "TNT")
  ergm.MHP.table("c", "Bernoulli", "", -1, "TNT10", "TNT10")
  ergm.MHP.table("c", "Bernoulli", "degrees",  0, "random", "CondDegree")
  ergm.MHP.table("c", "Bernoulli", "idegrees+odegrees",  0, "random", "CondDegree")
  ergm.MHP.table("c", "Bernoulli", "b1degrees+b2degrees",  0, "random", "CondDegree")
  ergm.MHP.table("c", "Bernoulli", "odegrees",  0, "random", "CondOutDegree")
  ergm.MHP.table("c", "Bernoulli", "idegrees",  0, "random", "CondInDegree")
  ergm.MHP.table("c", "Bernoulli", "b1degrees",  0, "random", "CondB1Degree")
  ergm.MHP.table("c", "Bernoulli", "b2degrees",  0, "random", "CondB2Degree")
  ergm.MHP.table("c", "Bernoulli", "degreedist",  0, "random", "CondDegreeDist")
  ergm.MHP.table("c", "Bernoulli", "idegreedist",  0, "random", "CondInDegreeDist")
  ergm.MHP.table("c", "Bernoulli", "odegreedist",  0, "random", "CondOutDegreeDist")
  ergm.MHP.table("c", "Bernoulli", "bd+edges",  0, "random", "ConstantEdges")
  ergm.MHP.table("c", "Bernoulli", "edges",  0, "random", "ConstantEdges")
  ergm.MHP.table("c", "Bernoulli", "edges+hamming",  0, "random", "HammingConstantEdges")
  ergm.MHP.table("c", "Bernoulli", "hamming",  0, "random", "HammingTNT")
  ergm.MHP.table("c", "Bernoulli", "bd+observed",  0, "random", "randomtoggleNonObserved")
  ergm.MHP.table("c", "Bernoulli", "observed",  0, "random", "randomtoggleNonObserved")
  ergm.MHP.table("c", "Bernoulli", "blockdiag", 0, "random", "blockdiag")
  ergm.MHP.table("c", "Bernoulli", "blockdiag", 1, "TNT", "blockdiagTNT")
  ergm.MHP.table("c", "Bernoulli", "bd+blockdiag", 0, "random", "blockdiag")
  ergm.MHP.table("c", "Bernoulli", "bd+blockdiag", 1, "TNT", "blockdiagTNT")
  ergm.MHP.table("c", "Bernoulli", "blockdiag+observed",  0, "random", "blockdiagNonObserved")
  ergm.MHP.table("c", "Bernoulli", "bd+blockdiag+observed",  0, "random", "blockdiagNonObserved")

  ergm.MHP.table("c", "Unif", "",  0, "random", "Unif")
  ergm.MHP.table("c", "Unif", "observed",  0, "random", "UnifNonObserved")
  
  ergm.MHP.table("c", "DiscUnif", "",  0, "random", "DiscUnif")
  ergm.MHP.table("c", "DiscUnif", "observed",  0, "random", "DiscUnifNonObserved")  
}

.RegisterConstraintImplications <- function(){
  ergm.ConstraintImplications("edges", c())
  ergm.ConstraintImplications("degrees", c("edges", "idegrees", "odegrees", "idegreedist", "odegreedist", "degreedist", "bd"))
  ergm.ConstraintImplications("odegrees", c("edges", "odegreedist"))
  ergm.ConstraintImplications("idegrees", c("edges", "idegreedist"))
  ergm.ConstraintImplications("b1degrees", c("edges"))
  ergm.ConstraintImplications("b2degrees", c("edges"))
  ergm.ConstraintImplications("degreedist", c("edges", "idegreedist", "odegreedist"))
  ergm.ConstraintImplications("idegreedist", c("edges"))
  ergm.ConstraintImplications("odegreedist", c("edges"))
  ergm.ConstraintImplications("bd", c())
  ergm.ConstraintImplications("blockdiag", c())
  ergm.ConstraintImplications("hamming", c())
  ergm.ConstraintImplications("observed", c())
}

.RegisterInitMethods <- function(){
  ergm.init.methods("Bernoulli", c("MPLE", "zeros"))
  ergm.init.methods("Unif", c("zeros"))
  ergm.init.methods("DiscUnif", c("zeros"))
}
