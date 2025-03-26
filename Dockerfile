FROM rstudio/plumber



WORKDIR /app



# Install required R packages and remotes for GitHub installation
RUN R -e "install.packages(c('yaml'), repos='https://cran.r-project.org')"


# Install the SeaSondeR package from GitHub
RUN R -e "remotes::install_github('GOFUVI/SeaSondeR', ref = '0.2.5', lib = '/usr/local/lib/R/site-library')"


# Copy run.R to the container
COPY run.R /app/run.R

CMD ["/app/run.R"]
