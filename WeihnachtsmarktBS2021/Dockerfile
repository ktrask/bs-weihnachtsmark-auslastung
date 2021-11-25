FROM rocker/tidyverse:4.1
RUN R -e 'install.packages("shiny")'
RUN R -e 'install.packages("anytime")'
RUN R -e 'install.packages("ggthemes")'
COPY app.R /app.R
EXPOSE 3838
CMD R -e 'shiny::runApp("app.R", port = 3838, host = "0.0.0.0")'
