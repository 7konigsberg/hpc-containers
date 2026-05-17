FROM rocker/r-ver:4.5.1

ENV DEBIAN_FRONTEND=noninteractive \
    R_LIBS_USER=/opt/R/libs

COPY workbench /opt/workbench

RUN mkdir -p "${R_LIBS_USER}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    xauth \
    pkg-config \
    libglapi-mesa \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libgl1-mesa-dri \
    libuv1-dev \
    libpng-dev \
    libx11-dev \
    libfreetype6-dev \
    libfontconfig1-dev \
    libxml2-dev \
    fonts-dejavu-core \
 && rm -rf /var/lib/apt/lists/*

RUN test -x /opt/workbench/bin_rh_linux64/wb_command \
 && /opt/workbench/bin_rh_linux64/wb_command -version

RUN EXTRA_CXXFLAGS='-Wno-overloaded-virtual' \
    R -q -e ".libPaths(c(Sys.getenv('R_LIBS_USER'), .libPaths())); install.packages('sass', lib = Sys.getenv('R_LIBS_USER'), repos = 'https://cloud.r-project.org', type = 'source'); library(sass); print(packageVersion('sass'))"

RUN R -q -e ".libPaths(c(Sys.getenv('R_LIBS_USER'), .libPaths())); \
      install.packages(c('pkgload', 'fields', 'gifti', 'oro.nifti', 'RNifti', 'RColorBrewer', 'viridisLite', 'xml2'), lib = Sys.getenv('R_LIBS_USER'), repos = 'https://cloud.r-project.org', type = 'source')"

RUN xvfb-run -s "-screen 0 1024x768x24" \
    R -q -e "\
      .libPaths(c(Sys.getenv('R_LIBS_USER'), .libPaths())); \
      install.packages('rgl', lib = Sys.getenv('R_LIBS_USER'), repos = 'https://cloud.r-project.org', type = 'source')"

CMD ["bash"]
