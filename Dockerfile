FROM rstudio/plumber:v1.2.0


COPY SeaSondeR.tar.gz /SeaSondeR.tar.gz

RUN R -e "remotes::install_local('SeaSondeR.tar.gz', lib = '/usr/local/lib/R/site-library')"

WORKDIR /app



# Install required R packages and remotes for GitHub installation
RUN R -e "install.packages(c('yaml'), repos='https://cran.r-project.org')"


# Install the SeaSondeR package from GitHub





# Copy run.R to the container
COPY run.R /app/run.R

CMD ["/app/run.R"]
