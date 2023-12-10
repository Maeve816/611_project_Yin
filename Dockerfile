FROM rocker/verse

RUN apt update && apt install -y man-db && rm -rf /var/lib/apt/lists/*
RUN R -e "install.packages('matlab', repos='http://cran.us.r-project.org')"
RUN yes | unminimize


RUN apt update && apt install -y python3 python3-pip
RUN apt update -y && apt install -y python3-pip
RUN pip3 install jupyter jupyterlab
RUN pip3 install numpy scikit-learn pandas



ARG USER_ID
ARG GROUP_ID

RUN usermod -u $USER_ID rstudio && groupmod -g $GROUP_ID rstudio
RUN chown -R rstudio:rstudio /home/rstudio