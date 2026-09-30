######################## 20260930. Intro to R ################################

# Installing packages ----
# You only need to install packages once

## Bioconductor:

# Bioconductor is a package repository commonly used fo bio data.
if (!requireNamespace("BiocManager", quietly = TRUE))
install.packages("BiocManager")


## Tidyverse and other misc CRAN packages:
install.packages(c("tidyverse", "readxl","writexl"))


# Loading packages ----

# You have to do this step every time you open R

library(tidyverse)
library(readxl)
library(writexl)


# Wrangling data with tidyverse ----

# Tidyverse is a collection of R packages that share a common design philosophy,
# grammar, and data structures for data science. To learn more visit:
# https://tidyverse.org/


# Tidyverse includes some datasets so you can play around with their functions.
# we're going to be working with the starwars dataset

starwars_data <- starwars
starwars_data

# Check the dimensions of the dataset
dim(starwars_data)

# Remember that for every function you can check its documentation by typing
# ?function in the terminal
?dim

# Check the first 6 rows
head(starwars_data)

# Get the column names, variable names
colnames(starwars_data)

# look at the unique values of homeworld
unique(starwars_data$homeworld)

# How many unique homeworlds do we have in the dataset?
length(unique(starwars_data$homeworld))
# 49

# How many characters from each homeworld does this dataset have?
table(starwars_data$homeworld)


## Dplyr functions ----

### Select function ----
# Select allows you to pick specific variables by column name

starwars_data %>% 
  select(hair_color, skin_color, species)

### Filter function ----
# Filter selects specific rows based on logical statements

starwars_data %>% 
  filter(height > 90,
         eye_color == 'blue')


### Piping functions ----
# We can use the %>% pipe symbol to directly process the results of one function
# into another. ie. Select specific columns and filter the data

starwars_data %>% 
  filter(height > 90,
         eye_color == 'blue') %>%
  select(hair_color, skin_color, species) %>%
  na.omit()


### Mutate function ----
# Mutate lets you change the values of an existing column or create a new column
# in your dataset

starwars_data %>% 
  mutate(height_earth = height - 20) %>%
  select(name, height, height_earth)

# Only change the height_earth of those that belong to Tatooine
starwars_data %>% 
  mutate(height_earth = ifelse(homeworld == 'Tatooine', height - 20, height)) %>%
  select(name, homeworld, height, height_earth)

### group_by + summarise ----
# This combination of functions lets you reduce the dimensions of your dataset and 
# get specific statistics-

# Group by homeworld and count number of people in each homeworld
starwars_data %>% 
  group_by(homeworld) %>%
  summarise(count = n())


# Group by homeworld and count number of eye color types in each
starwars_data %>% 
  group_by(homeworld) %>%
  summarise(count = n_distinct(eye_color)) 



# Data visualization ----

library(ggplot2)

## Dot plot ----

# Basic scatterplot of height and mass
ggplot(starwars_data, aes(x = mass, y = height)) +
  geom_point()


# Basic scatterplot of height and mass colored by sex
ggplot(starwars_data, aes(x = mass, y = height)) +
  geom_point(aes(color = sex)) +
  labs(
    title = "Height and mass measurements",
    x = "Mass",
    y = "Height",
    color = "Sex") + 
  theme_bw()

## Histogram ----
ggplot(starwars_data, aes(x = height)) +
  geom_histogram() +
  theme_bw()

## Bar plot ----
ggplot(starwars_data, aes(x = sex)) +
  geom_bar() +
  theme_bw()

## Violin plot ----
ggplot(starwars_data, aes(x = gender, y = height)) +
  geom_violin(fill = "lightblue", color = "black") +
  geom_jitter(width = 0.2, alpha = 0.6, color = "darkblue") +
  theme_bw() +
  labs(
    title = "Distribution of Height by Gender with Data Points",
    x = "Gender",
    y = "Height"
  )


## Box plot ----
ggplot(starwars_data, aes(x = gender, y = height)) +
  geom_boxplot(fill = "lightgreen", color = "black") +
  theme_bw() +
  labs(title = "Height Distribution by Gender", x = "Gender", y = "Height")


## Density plot ----
ggplot(starwars_data, aes(x = height)) +
  geom_density(fill = "purple", alpha = 0.5) +
  theme_bw() +
  labs(title = "Density Plot of Height", x = "Height", y = "Density")


## Line plot ----
ggplot(starwars_data, aes(x = birth_year, y = height)) +
  geom_line(color = "red") +
  theme_light() +
  labs(title = "Height vs. Birth Year", x = "Birth Year", y = "Height")

## Heatmap ----
ggplot(starwars_data, aes(x = gender, y = species, fill = height)) +
  geom_tile(color = "white") +
  theme_minimal() +
  labs(title = "Heatmap of Height by Gender and Species", x = "Gender", y = "Species", fill = "Height")


## Adding error bars ----

error_data <- starwars_data %>%
  group_by(gender) %>%
  summarize(
    height_mean = mean(height, na.rm = TRUE),
    height_sd = sd(height, na.rm = TRUE)
  )

ggplot(error_data, aes(x = gender, y = height_mean)) +
  geom_point(size = 3) +
  geom_errorbar(aes(ymin = height_mean - height_sd, ymax = height_mean + height_sd), width = 0.2) +
  theme_minimal() +
  labs(title = "Height Mean with Error Bars by Gender", x = "Gender", y = "Mean Height")



## Faceting ----

ggplot(starwars_data, aes(x = height)) +
  geom_histogram(binwidth = 10, fill = "skyblue", color = "black") +
  facet_wrap(~ gender) +
  theme_bw() +
  labs(title = "Height Distribution by Gender", x = "Height", y = "Frequency")



## Piping into ggplot2 ----

starwars_data %>%
  filter(homeworld == "Tatooine") %>%
  mutate(height_earth = height - 20) %>%
  na.omit() %>% 
  ggplot(aes(x = mass, y = height_earth)) +
  geom_point(aes(color = sex)) +
  labs(
    title = "Earth height and mass measurements for Tatooine",
    x = "Mass",
    y = "Height",
    color = "Sex") + 
  theme_bw()


starwars_data %>%
  mutate(height_earth = height - 20) %>%
  na.omit() %>% 
  ggplot(aes(x = mass, y = height_earth)) +
  geom_point(aes(color = sex)) +
  labs(
    title = "Earth height and mass measurements for Tatooine",
    x = "Mass",
    y = "Height",
    color = "Sex") + 
  theme_bw()


# Exercises ----

# Can you create a bar plot showing the eye color of the characters from the 
# planet Tatooine? Can you color each bar plot the same as the eye color?




# Seems like there's an outlier in this plot that is skewing our linear regression,
# how would you remove it?

starwars %>% 
  filter(!is.na(mass), !is.na(height)) %>% 
  ggplot(aes(x = mass, y = height)) +
  geom_point(aes(color = sex), size = 3, alpha = 0.8) +
  geom_smooth(method = "lm", se = TRUE, color = "black", fill = "grey70") +
  labs(x = "Mass (kg)", y = "Height (cm)", color = "Sex") +
  theme_bw(base_size = 18)





# Create a heatmap to identify the percentage of characters that identify with the
# same gender as their sex


