
# tRciks - data science scripts - time series

# -----------------------------------------------------------------------
# Generate a random time series based in a original one based in
# random alk models

# GitHub: @jmenblaz

#--------------------------------------------------------------------------

# load packages
library(tidyr)
library(ggplot2)

##  load a temporal serie or create a new for example
# Serie temporal original
# Original time series
set.seed(123)
# rnorm(X, mean= 0, sd = 1) - X number lenght of the time series

original_series <- cumsum(rnorm(100, mean = 0, sd = 1))  # Example of an original series

# 1. Calculate the increments steps of the original series
#    Calcula los incrementos entre pasos de la serie original
increments <- diff(original_series)

# 2. Fit a distribution (assuming normality by default)
#    Ajusta una distribución (por defecto, asumiremos normalidad)
mean_inc <- mean(increments)
sd_inc <- sd(increments)

# 3. Generate new simulated series function() based in randome walk
#    Genera una nueva serie simulada function() basadas in random walk
simulate_random_walk <- function(n, start_value, mean, sd) {
  simulated_increments <- rnorm(n - 1, mean = mean, sd = sd)  # Generate random increments
  series <- cumsum(c(start_value, simulated_increments))      # Cumulative random walk
  return(series)
}


# 4. Number of simulated series
#    Numero de simulaciones para crear
num_simulations <- 25  # Change this value as needed

# lenght of the series and star value (from original serie)
n <- length(original_series)
start_value <- original_series[1]


# 5. Generate simulated series
#    Generar simulaciones
simulated_series <- replicate(num_simulations, simulate_random_walk(n, start_value, mean_inc, sd_inc))

# 6. Convert to data.frame for ggplot
#    convertir a data.frame para visualizar
sim_df <- as.data.frame(simulated_series)
colnames(sim_df) <- paste0("simulated_", 1:num_simulations)
# add time position and original serie
sim_df$time <- 1:n
sim_df$original <- original_series



# 7. Plot -------------------------------------------------------------------- 
# Transform to long format for ggplot
df_long <- pivot_longer(sim_df, cols = -time, names_to = "series", values_to = "value")

# Visualize with ggplot
ggplot(df_long, aes(x = time, y = value, group = series)) +
  # Simulated series in gray with transparency
  geom_line(data = subset(df_long, grepl("simulated_", series)),
            aes(color = "simulated"), alpha = 0.4, size = 0.6) +
  # Original series in sky blue
  geom_line(data = subset(df_long, series == "original"),
            aes(color = "original"), size = 1.2) +
  scale_color_manual(values = c("original" = "skyblue4", "simulated" = "grey")) +
  # Theme
  theme_minimal() +
  labs(title = "Random Walk - Original and Simulated Series",
       x = "Time", y = "Value") +
  theme(legend.position = "none")  # Hide legend if not needed

