FROM rstudio/plumber:v1.2.0



RUN git clone https://github.com/GOFUVI/SeaSondeR.git /tmp/SeaSondeR \
  && cd /tmp/SeaSondeR \
  && git checkout tags/0.2.6 \
  && Rscript -e "remotes::install_deps('/tmp/SeaSondeR', dependencies = TRUE)" \
  && rm -rf /tmp/SeaSondeR
RUN R -e "remotes::install_github('GOFUVI/SeaSondeR', ref = 'v0.2.7')"


WORKDIR /app



# Install required R packages and remotes for GitHub installation
RUN R -e "install.packages(c('yaml', 'openssl'), repos='https://cran.r-project.org')"


# Install the SeaSondeR package from GitHub





# Copy run.R to the container
COPY run.R /app/run.R

CMD ["/app/run.R"]
