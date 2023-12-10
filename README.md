LinkedIn Dataset Analysis 
========================================================


This repository contains an LinkedIn dataset with detailed information about job
postings on the platform.This dataset seems quite comprehensive and can provide 
valuable insights into various job roles, industries, locations, salaries, and 
required skills.


Using This Repository
=====================

This repository is best used via Docker although you may be able to
consult the Dockerfile to understand what requirements are appropriate
to run the code.

Clone my github repository to local:
```
git clone -b master https://github.com/Maeve816/611_project_Yin
```

One Docker container is provided for both "production" and
"development." To build it, you will need to create a Dockerfile as in main 
directory. Then you run:

```
docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=1234 -t my_image 
```

This will create a docker container. Users should be able to get a password and
start an RStudio server by running:

```
docker run --rm -v $(pwd):/home/rstudio/work -p 8789:8787 -it my_image

```

You then visit http://localhost:8789 via a browser on your machine to
access the machine and development environment. 

Project Organization
====================

The best way to understand what this project does is to examine the
Makefile.

A Makefile is a textual description of the relationships between
_artifacts_ (like data, figures, source files, etc). In particular, it
documents for each artifact of interest in the project:

1. what is needed to construct that artifact
2. how to construct it



What to Look At
===============

There are only one product of this analysis: A report on how the details of the results.

You can simply invoke:

```
make project/code/writeup_report.html
```

And this will build the report and any missing dependencies required
on the way.

Results
=======

You can check the project/code/writeup_report.html report for all the details.

