# R-RGL

R container for software-rendered `rgl` work on HPC via Apptainer.

Current public image:

```text
ghcr.io/7konigsberg/rgl-test:latest
```

## Includes

- `R 4.5.1` from `rocker/r-ver`
- `rgl` built from source
- `xvfb`
- Mesa / X11 libraries for software OpenGL rendering
- `bash` shell from the base image

## Pull On HPC

Load Apptainer first:

```bash
module load apptainer
```

Pull the public image:

```bash
apptainer pull rgl-test.sif docker://ghcr.io/7konigsberg/rgl-test:latest
```

Recommended default:

- use `--cleanenv --containall` so host environment variables, home-directory files, and the current working directory do not leak into the container
- use `R --vanilla` or `Rscript --vanilla` so host `.Rprofile` / `.Renviron` are not used even if you later bind specific directories

## Smoke Test On HPC

```bash
apptainer exec --cleanenv --containall --pwd / rgl-test.sif \
  xvfb-run -s "-screen 0 1024x768x24" \
  R --vanilla -q -e "library(rgl); open3d(); plot3d(1:3,1:3,1:3); rgl.snapshot('/tmp/test.png'); print(file.exists('/tmp/test.png'))"
```

Expected output:

```text
[1] TRUE
```

## Open A Shell

Interactive shell:

```bash
module load apptainer
apptainer shell --cleanenv --containall --pwd / rgl-test.sif
```

## Install Extra R Packages

The `.sif` image is read-only. If you need extra packages, bind only a specific library directory instead of your whole home directory:

```bash
mkdir -p ~/R/container-lib

apptainer exec --cleanenv --containall --pwd / \
  -B $HOME/R/container-lib:/r-lib \
  rgl-test.sif \
  R --vanilla -q -e ".libPaths(c('/r-lib', .libPaths())); install.packages(c('devtools'), repos='https://cloud.r-project.org')"
```

Check the library paths:

```bash
apptainer exec --cleanenv --containall --pwd / \
  -B $HOME/R/container-lib:/r-lib \
  rgl-test.sif \
  R --vanilla -q -e ".libPaths(c('/r-lib', .libPaths())); print(.libPaths())"
```

## `devtools::load_all()`

Bind your source tree into the container, then load it from the bound path:

```bash
module load apptainer

apptainer exec --cleanenv --containall --pwd / \
  -B $HOME/Documents/Github:/work \
  -B $HOME/R/container-lib:/r-lib \
  rgl-test.sif \
  xvfb-run -s "-screen 0 1024x768x24" \
  R --vanilla -q -e ".libPaths(c('/r-lib', .libPaths())); devtools::load_all('/work/YOUR_PACKAGE')"
```

Notes:

- replace `YOUR_PACKAGE` with the directory name of the package
- install `devtools` into `~/R/container-lib` first if needed
- `xvfb-run` is only necessary if the package or script actually opens `rgl`

## Run An R Script

If the script needs `rgl` rendering:

```bash
module load apptainer

apptainer exec --cleanenv --containall --pwd / \
  -B $HOME/Documents/Github:/work \
  rgl-test.sif \
  xvfb-run -s "-screen 0 1024x768x24" \
  Rscript --vanilla /work/YOUR_PACKAGE/path/to/script.R
```

If the script does not touch `rgl`, drop `xvfb-run`:

```bash
module load apptainer

apptainer exec --cleanenv --containall --pwd / \
  -B $HOME/Documents/Github:/work \
  rgl-test.sif \
  Rscript --vanilla /work/YOUR_PACKAGE/path/to/script.R
```

## Notes

- `bash` is available in the image.
- The public GHCR image can be pulled without authentication.
- Apptainer bind-mounts host paths by default. This README avoids that by using `--cleanenv --containall` and binding only the directories you explicitly need.
