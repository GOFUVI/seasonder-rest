FROM rstudio/plumber:v1.2.0

ENV SEASONDER_VERSION=v0.2.8

RUN Rscript -e "remotes::install_github('GOFUVI/SeaSondeR', ref = '${SEASONDER_VERSION}', dependencies = TRUE)"


WORKDIR /app



# Install required R packages and remotes for GitHub installation
RUN R -e "install.packages(c('yaml', 'openssl'), repos='https://cran.r-project.org')"


# Install the SeaSondeR package from GitHub





# Copy run.R to the container
COPY run.R /app/run.R

CMD ["/app/run.R"]
