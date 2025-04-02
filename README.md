# seasonder-rest

## Table of Contents
1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Docker Setup](#docker-setup)
   - [Installing Docker](#installing-docker)
   - [Building or Pulling the Image](#building-or-pulling-the-image)
   - [Running the Server](#running-the-server)
4. [Scripts](#scripts)
   - [configure_seasonder.sh](#configure_seasondersh)
   - [process_files.sh](#process_filessh)
5. [API Endpoints](#api-endpoints)
6. [Image Build Guide](#image-build-guide)
7. [run.R Script Explanation](#runr-script-explanation)
8. [Disclaimer](#disclaimer)

## Introduction
This repository provides a Docker Image to build a container with the [SeaSondeR package](https://github.com/GOFUVI/SeaSondeR) preinstaled, along with a REST API and configuration management for the SeaSondeR package. It facilitates updating settings, processing input files, and serving computed radial metrics via a set of HTTP endpoints.

## Installation
You can either build the Docker image locally or pull the pre-built image from Docker Hub.

## Docker Setup

### Installing Docker
- **Windows**: Download and install Docker Desktop from [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop). Ensure that WSL 2 is enabled.
- **Mac**: Download and install Docker Desktop for Mac from [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop).
- **Linux**: Follow the installation instructions for your distribution. For example, on Ubuntu:
  ```bash
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io
  ```

### Building or Pulling the Image
- To build locally, run:
  ```bash
  docker build . --tag gofuvi/seasonder-rest:latest
  ```
- To pull the image directly, run:
  ```bash
  docker pull gofuvi/seasonder-rest:latest
  ```

### Running the Server
Once the Docker image is built or downloaded, you can run the server using the following command:

```bash
docker run -p <host_port>:8000 gofuvi/seasonder-rest:latest
```

Replace `<host_port>` with the desired port on your host machine. For example, to run the server on port 8080:

```bash
docker run -p 8080:8000 gofuvi/seasonder-rest:latest
```

The server will now be accessible at `http://localhost:<host_port>`.

## Scripts

### configure_seasonder.sh
This script updates server configuration via the `/config` endpoint and uploads a pattern file via the `/upload_pattern` endpoint.

#### Usage
```bash
Usage: configure_seasonder.sh [-h] [-p port] [-s server_addr] [-f pattern_file] [-o key=value]
  -h: Display this help message.
  -p: Specify port (default: 8000).
  -s: Specify server address (default: http://localhost:PORT).
  -f: Specify pattern file path (default: ./MeasPattern.txt).
  -o: Override OPTIONS key with key=value (can be used multiple times).
```

#### Notes
- If you run the Docker image using a port other than 8000, specify the correct port in the `-p` or `-s` options.
- When updating the configuration, all existing values on the server will be overwritten. Ensure you provide all necessary options.

#### Default OPTIONS
```
nsm=2
fdown=10
flim=100
noisefact=3.981072
currmax=2.0
reject_distant_bragg=TRUE
reject_noise_ionospheric=TRUE
reject_noise_ionospheric_threshold=0
COMPUTE_FOR=FALSE
PPMIN=5
PPMAX=50
smoothNoiseLevel=FALSE
discard=low_SNR,no_solution
doppler_interpolation=2
MUSIC_parameters=40,20,2,20
```

### process_files.sh
This script processes `.css`, `.cs4`, and `.csr` files by sending them to the `/process_css` endpoint, then renames the output to a `.ruv` file.

#### Usage
```bash
Usage: process_files.sh [-h] [-o output_dir] [-i input_dir] [-p port] [-s server_addr]
  -h: Display this help message.
  -o: Specify output directory (default: .)
  -i: Specify input directory (default: ./)
  -p: Specify port (default: 8000)
  -s: Specify server address (default: http://localhost:PORT)
```

## API Endpoints
- **PUT /config**: Updates configuration options. Pass the configuration key and value as query parameters.
- **POST /process_css**: Accepts an uploaded CSS file, processes it, and returns the computed radial metrics.
- **POST /upload_pattern**: Handles pattern file uploads, saves the file, and updates the configuration with the new pattern file path.

## Image Build Guide

To build the Docker image from the repository and customize it to your needs, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/your_username/seasonder-rest.git
   cd seasonder-rest
   ```

2. Review and modify configuration files:
   - **Dockerfile**: Adjust the build instructions according to your environment.
   - **run.R**: Make any necessary modifications for execution.

3. Build the Docker image:
   ```bash
   docker build . --tag gofuvi/seasonder-rest:latest
   ```

4. Run the container (for example, using port 8080):
   ```bash
   docker run -p 8080:8000 gofuvi/seasonder-rest:latest
   ```

## run.R Script Explanation
The `run.R` script is responsible for starting the REST application. It sets up the execution environment, loads the necessary configurations, and launches the REST server, enabling the service.

## Acknowledgements

This work has been funded by the HF-EOLUS project (TED2021-129551B-I00), financed by MICIU/AEI /10.13039/501100011033 and by the European Union NextGenerationEU/PRTR - BDNS 598843 - Component 17 - Investment I3.

## Disclaimer

This software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the software or the use or other dealings in the software.
