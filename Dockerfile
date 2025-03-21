FROM rocker/r-ver:latest

# Install system dependencies (if required by some packages)
RUN apt-get update && apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev

# Install required R packages and remotes for GitHub installation
RUN R -e "install.packages(c('plumber', 'yaml', 'remotes'), repos='https://cran.r-project.org')"

# Install the SeaSondeR package from GitHub
RUN R -e "remotes::install_github('GOFUVI/SeaSondeR')"

# Copy run.R to the container
COPY run.R /app/run.R
WORKDIR /app

# Expose the port for the plumber service
EXPOSE 8000

# Start the Plumber service to expose endpoints defined in run.R
CMD ["R", "-e", "pr <- plumber::plumb('run.R'); pr$run(host='0.0.0.0', port=8000)"]
