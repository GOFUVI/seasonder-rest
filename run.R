# Load the yaml package
if (!require("yaml", quietly = TRUE)) {
    install.packages("yaml", repos = "https://cran.r-project.org")
    library("yaml")
}
# Install and load the plumber package for REST API
if (!require("plumber", quietly = TRUE)) {
    install.packages("plumber", repos = "https://cran.r-project.org")
    library("plumber")
}

# Paths to the configuration files
config_path <- "settings.yaml"
default_config_path <- "settings.default.yaml"

# Function to read the configuration from the YAML files.
# The default configuration is always loaded first, and any user-defined options 
# from 'settings.yaml' override them.
read_configuration <- function(path = config_path, defaultPath = default_config_path) {
    config <- list()
    if (file.exists(defaultPath)) {
        config <- yaml::read_yaml(defaultPath)
    } else {
        cat("The default configuration file does not exist.\n")
    }
    
    if (file.exists(path)) {
        user_config <- yaml::read_yaml(path)
        # Merge the user settings into the default configuration (overriding defaults)
        config <- modifyList(config, user_config)
    } else {
        cat("The user configuration file does not exist. Using default configuration.\n")
    }
    return(config)
}

# Function to save the user configuration to the YAML file.
# Only non-default settings will be saved.
save_configuration <- function(config, path = config_path) {
    yaml::write_yaml(config, path)
}

# Function to update an option in the configuration and save it to the YAML file.
# The updated option will override the default configuration.
update_configuration <- function(key, value, path = config_path) {
    # Read the current user configuration (if exists)
    user_config <- list()
    if (file.exists(path)) {
        user_config <- yaml::read_yaml(path)
    }
    user_config[[key]] <- value
    save_configuration(user_config, path)
    cat(sprintf("The key '%s' has been updated to '%s'.\n", key, toString(value)))
}


process_css <- function(css_path, pattern_path, options){

options <- read_configuration()

seasonder_apm_obj <- SeaSondeR::seasonder_readSeaSondeRAPMFile(
    pattern_path
)

seasonder_cs_obj <- SeaSondeR::seasonder_createSeaSondeRCS(css_path, seasonder_apm_object = seasonder_apm_obj)



  
  seasonder_cs_obj %<>% SeaSondeR::seasonder_runMUSIC_in_FOR(doppler_interpolation = options$doppler_interpolation, options = list(PPMIN = options$PPMIN, PWMAX = options$PPMAX, smoothNoiseLevel = options$smoothNoiseLevel))



rm_file <- tempfile(fileext = ".ruv")

 radial_metrics <-SeaSondeR::seasonder_exportLLUVRadialMetrics(seasonder_cs_obj,rm_file)

 return(rm_file)
}

#* @put /config
#* @param key query string: configuration key to update
#* @param value query string: new value for the option
#* @response 200 Returns a confirmation message after updating the configuration
function(key, value) {
    update_configuration(key, value)
    return(list(status = "success", key = key, newValue = value))
}

# Code to start the REST server if desired:
# pr <- plumber::plumb("run.R")
# pr$run(port = 8000)

#* @post /process_css
function(req) {
    
    
    
    if (!(length(req$body) > 0 && !is.null(req$body[[1]]$name) && !is.null(req$body[[1]]$filename))) {
        return(list(status = "error", message = "No se ha subido ningún archivo"))
    }
    file <- req$body[[1]]
    tmp <- tempfile()

     writeBin(file$value, tmp)
    
    return(list(status = "success"))
}



#* @post /upload_measpattern
function(req) {
   
    save(req,file = "req.RData")
    
    if (!(length(req$body) > 0 && !is.null(req$body[[1]]$name) && !is.null(req$body[[1]]$filename))) {
        return(list(status = "error", message = "No file uploaded."))
    }
    file <- req$body[[1]]
    # Crear el directorio "uploads" si no existe
    uploads_dir <- "measpattern"
    if (!dir.exists(uploads_dir)) {
        dir.create(uploads_dir)
    }
    

    tmp <- tempfile(fileext = ".txt")

     writeBin(file$value, tmp)

     apm_object <- try(SeaSondeR::seasonder_readSeaSondeRAPMFile(tmp), silent = TRUE) 

if(inherits(apm_object, "try-error")) {
    
    return(list(status = "error", message = "Error reading the APM file."))
}
    # Definir la ruta de destino para el archivo
    destination <- file.path(uploads_dir, file$filename)
    

    file.copy(tmp, destination)
    # Mover el archivo desde el datapath temporal a la ruta de destino
   
    
    
    update_configuration("measpattern_path", destination)



    return(list(status = "success"))

}