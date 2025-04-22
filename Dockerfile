FROM rstudio/plumber:v1.2.0

ENV SEASONDER_VERSION=v0.2.7

RUN git clone https://github.com/GOFUVI/SeaSondeR.git /tmp/SeaSondeR \
  && cd /tmp/SeaSondeR \
  && git checkout tags/${SEASONDER_VERSION} \
  && Rscript -e "remotes::install_deps('/tmp/SeaSondeR', dependencies = TRUE)" \
  && rm -rf /tmp/SeaSondeR \
  && Rscript -e "remotes::install_github('GOFUVI/SeaSondeR', ref = '${SEASONDER_VERSION}')"


WORKDIR /app



# Install required R packages and remotes for GitHub installation
RUN R -e "install.packages(c('yaml', 'openssl'), repos='https://cran.r-project.org')"


# Install the SeaSondeR package from GitHub





# Copy run.R to the container
COPY run.R /app/run.R

CMD ["/app/run.R"]
