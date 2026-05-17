FROM rocker/r-ver:4.5.1

ENV DEBIAN_FRONTEND=noninteractive \
    R_LIBS_USER=/opt/R/libs

RUN mkdir -p "${R_LIBS_USER}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    xauth \
    pkg-config \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libgl1-mesa-dri \
    libuv1-dev \
    libpng-dev \
    libx11-dev \
    libfreetype6-dev \
    libfontconfig1-dev \
    fonts-dejavu-core \
 && rm -rf /var/lib/apt/lists/*

RUN EXTRA_CXXFLAGS='-Wno-overloaded-virtual' \
    R -q -e ".libPaths(c(Sys.getenv('R_LIBS_USER'), .libPaths())); install.packages('sass', lib = Sys.getenv('R_LIBS_USER'), repos = 'https://cloud.r-project.org', type = 'source'); library(sass); print(packageVersion('sass'))"

RUN xvfb-run -s "-screen 0 1024x768x24" \
    R -q -e "options(warn = 2); \
      .libPaths(c(Sys.getenv('R_LIBS_USER'), .libPaths())); \
      install.packages('rgl', lib = Sys.getenv('R_LIBS_USER'), repos = 'https://cloud.r-project.org', type = 'source'); \
      library(rgl); \
      open3d(); \
      plot3d(1:3, 1:3, 1:3); \
      texts3d(2, 2, 2, 'font-check', family = 'sans'); \
      rgl.snapshot('/tmp/rgl-test.png'); \
      stopifnot(file.exists('/tmp/rgl-test.png')); \
      print(packageVersion('rgl')); \
      print(.libPaths())"

CMD ["bash"]
