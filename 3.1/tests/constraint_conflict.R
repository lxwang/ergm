#  File tests/constraint_conflict.R in package ergm, part of the Statnet suite
#  of packages for network analysis, http://statnet.org .
#
#  This software is distributed under the GPL-3 license.  It is free,
#  open source, and has the attribution requirements (GPL Section 7) at
#  http://statnet.org/attribution
#
#  Copyright 2003-2013 Statnet Commons
#######################################################################
library(statnet.common)
opttest({
library(ergm)
data(florentine)

#if(!inherits(try(
efit <- ergm(flomarriage~edges, constraints=~edges)#),
#   "try-error"))
#  stop("Should have had an error here.")
}, "constraint conflicts")
