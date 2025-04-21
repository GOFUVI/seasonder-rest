FROM rstudio/plumber:v1.2.0


RUN R -e "remotes::install_github('GOFUVI/SeaSondeR', lib = '/usr/local/lib/R/site-library', ref = 'v0.2.7')"

WORKDIR /app



# Install required R packages and remotes for GitHub installation
RUN R -e "install.packages(c('yaml', 'openssl'), repos='https://cran.r-project.org')"


# Install the SeaSondeR package from GitHub





# Copy run.R to the container
COPY run.R /app/run.R

CMD ["/app/run.R"]
