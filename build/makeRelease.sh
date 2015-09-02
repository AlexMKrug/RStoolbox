#!/bin/bash
cd ~/eclipseWorkspace/RStoolbox

## Check for uncommited changes
if [[ -n $(git status -s) ]] 
then
	echo "Uncommited changes. Clean-up first."
	git status
	exit 1
fi

## Begin build and check
git checkout master
echo "\n**********************************************************"
echo "Document and install RStoolbox ***************************"
echo "**********************************************************"
Rscript -e "library(devtools);library(methods); document(); install()"

echo "\n**********************************************************"
echo "Generate example data ************************************"
echo "**********************************************************"
Rscript data-raw/generate_data.R

echo "\n**********************************************************"
echo "Generate sysdata *****************************************"
echo "**********************************************************"
Rscript data-raw/generate_sysdata.R

echo "\n**********************************************************"
echo "R CMD check **********************************************"
echo "**********************************************************"
Rscript -e "library(devtools); library(methods); build_win(); check()"

git commit -a -m "Automatic commit: Update sysdata and example data"


## Website
echo "\n**********************************************************"
echo "Build website documentation ******************************"
echo "**********************************************************"
git checkout gh-pages
Rscript rstbx-docu/build_docu.R
git commit -a -m "Automatic commit: Update gh-pages package documentation"
git checkout master