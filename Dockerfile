FROM rstudio/plumber



WORKDIR /app



# Install required R packages and remotes for GitHub installation
RUN R -e "install.packages(c('remotes','yaml'), repos='https://cran.r-project.org')"


# Install the SeaSondeR package from GitHub
RUN R -e "remotes::install_github('GOFUVI/SeaSondeR', ref = '0.2.5')"


# Copy run.R to the container
COPY run.R /app/run.R

CMD ["/app/run.R"]
