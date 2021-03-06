context("fCover")


suppressPackageStartupMessages(library(raster))
suppressPackageStartupMessages(library(randomForest))

data(lsat)
lc	  <- unsuperClass(lsat, nClass=3)$map
modis <- aggregate(lsat, 9)


for(cl in 1:2) {
	test_that(sprintf("works for %s classes(s)",cl), {
				expect_is(fc <- fCover(
								classImage = lc ,
								predImage = modis,
								classes=1:cl,
								model="rf",
								nSample = 50,
								number = 5,
								tuneLength=1
						), c("RStoolbox", "fCover"))
				expect_equal(nlayers(fc$map), cl)
				
			})

}

test_that("errors and warnings are thrown",{
expect_error(fCover(
		classImage = lc ,
		predImage = modis,
		classes = 4,
		model="rf",
		nSample = 50,
		number = 5,
		tuneLength=1
),"One or more classes are not represented in the sampled pixels")
})