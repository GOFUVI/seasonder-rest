# seasonder-rest

## Introduction
This repository provides a REST API and configuration management for the SeaSondeR package. It facilitates updating settings, processing input files, and serving computed radial metrics via a set of HTTP endpoints.

## Installation
You can either build the Docker image locally or pull the pre-built image from Docker Hub.

## Docker Setup
### Installing Docker
- **Windows**: Download and install Docker Desktop from https://www.docker.com/products/docker-desktop. Ensure that WSL 2 is enabled.
- **Mac**: Download and install Docker Desktop for Mac from https://www.docker.com/products/docker-desktop.
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

## Scripts & Help
### Description of Scripts
- **configure_seasonder.sh**: Updates server configuration via the `/config` endpoint and uploads a pattern file via the `/upload_pattern` endpoint.
- **process_files.sh**: Processes `.css`, `.cs4`, and `.csr` files by sending them to the `/process_css` endpoint, then renames the output to a `.ruv` file.

> **Note**: If you run the Docker image using a port other than 8000 (e.g., `docker run -p 8080:8000`), make sure to specify the correct port in the `-p` or `-s` options of the scripts. For example:
> ```bash
> ./configure_seasonder.sh -p 8080
> ./process_files.sh -p 8080
> ```

> **Important**: When using the `configure_seasonder.sh` script to update the configuration, all existing configuration values on the server will be overwritten. Ensure you provide all necessary configuration options when running the script. Parameters not supplied as options will be reset to their default values.

Both scripts support a help flag `-h` to display usage instructions.

### Script Help

#### configure_seasonder.sh
```
Usage: configure_seasonder.sh [-h] [-p port] [-s server_addr] [-f pattern_file] [-o key=value]
  -h: Display this help message.
  -p: Specify port (default: 8000).
  -s: Specify server address (default: http://localhost:PORT).
  -f: Specify pattern file path (default: ./MeasPattern.txt).
  -o: Override OPTIONS key with key=value (can be used multiple times).

Defaults for OPTIONS:
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

#### process_files.sh
```
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