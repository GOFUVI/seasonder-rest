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