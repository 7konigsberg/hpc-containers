FROM rocker/r-ver:4.5.1

ENV DEBIAN_FRONTEND=noninteractive \
    R_LIBS_USER=/opt/R/libs

COPY workbench /opt/workbench

RUN mkdir -p "${R_LIBS_USER}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    xauth \
    cmake \
    pkg-config \
    libcurl4-openssl-dev \
    libssl-dev \
    libgit2-dev \
    libnlopt-dev \
    libglapi-mesa \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libgl1-mesa-dri \
    libharfbuzz-dev \
    libfribidi-dev \
    libuv1-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libwebp-dev \
    libx11-dev \
    libfreetype6-dev \
    libfontconfig1-dev \
    libxml2-dev \
    fonts-dejavu-core \
 && rm -rf /var/lib/apt/lists/*

RUN test -x /opt/workbench/bin_rh_linux64/wb_command \
 && /opt/workbench/bin_rh_linux64/wb_command -version

# Dependencies for ciftiTools
RUN R -q -e ".libPaths(c(Sys.getenv('R_LIBS_USER'), .libPaths())); \
      install.packages(c('fields', 'gifti', 'oro.nifti', 'RNifti', 'RColorBrewer', 'viridisLite', 'xml2'), lib = Sys.getenv('R_LIBS_USER'), repos = 'https://cloud.r-project.org', type = 'source'); \
      stopifnot(requireNamespace('fields', quietly = TRUE), requireNamespace('gifti', quietly = TRUE), requireNamespace('oro.nifti', quietly = TRUE), requireNamespace('RNifti', quietly = TRUE), requireNamespace('RColorBrewer', quietly = TRUE), requireNamespace('viridisLite', quietly = TRUE), requireNamespace('xml2', quietly = TRUE))"

RUN EXTRA_CXXFLAGS='-Wno-overloaded-virtual' \
    R -q -e ".libPaths(c(Sys.getenv('R_LIBS_USER'), .libPaths())); install.packages('sass', lib = Sys.getenv('R_LIBS_USER'), repos = 'https://cloud.r-project.org', type = 'source'); library(sass); print(packageVersion('sass'))"

# Dependencies for ciftiTools: rgl
RUN xvfb-run -s "-screen 0 1024x768x24" \
    R -q -e "\
      .libPaths(c(Sys.getenv('R_LIBS_USER'), .libPaths())); \
      install.packages('rgl', lib = Sys.getenv('R_LIBS_USER'), repos = 'https://cloud.r-project.org', type = 'source'); \
      stopifnot(requireNamespace('rgl', quietly = TRUE))"

# Dependencies for hrf
RUN R -q -e ".libPaths(c(Sys.getenv('R_LIBS_USER'), .libPaths())); \
      install.packages(c('car', 'fMRItools', 'matrixStats', 'qs2', 'Rcpp', 'reshape2', 'dplyr', 'magrittr', 'ggplot2', 'gridExtra', 'ggthemes', 'scales'), lib = Sys.getenv('R_LIBS_USER'), repos = 'https://cloud.r-project.org', type = 'source'); \
      stopifnot(requireNamespace('car', quietly = TRUE), requireNamespace('fMRItools', quietly = TRUE), requireNamespace('matrixStats', quietly = TRUE), requireNamespace('qs2', quietly = TRUE), requireNamespace('Rcpp', quietly = TRUE), requireNamespace('reshape2', quietly = TRUE), requireNamespace('dplyr', quietly = TRUE), requireNamespace('magrittr', quietly = TRUE), requireNamespace('ggplot2', quietly = TRUE), requireNamespace('gridExtra', quietly = TRUE), requireNamespace('ggthemes', quietly = TRUE), requireNamespace('scales', quietly = TRUE))"

# Development tooling
RUN R -q -e ".libPaths(c(Sys.getenv('R_LIBS_USER'), .libPaths())); \
      install.packages('devtools', lib = Sys.getenv('R_LIBS_USER'), repos = 'https://cloud.r-project.org', type = 'source'); \
      stopifnot(requireNamespace('devtools', quietly = TRUE))"

CMD ["bash"]
