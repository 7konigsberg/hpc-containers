# R-RGL

R container for software-rendered `rgl` work on HPC via Apptainer.

Current public image:

```text
ghcr.io/7konigsberg/rgl-test:latest
```

## Includes

- `R 4.5.1` from `rocker/r-ver`
- `rgl` built from source
- Connectome Workbench at `/opt/workbench/bin_rh_linux64/wb_command`
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

## Add Extra R Packages

This image is intended to carry its own runtime R package set. If the lab needs more packages, add them to the Dockerfile and rebuild the image rather than binding an external R library from the host.

## `pkgload::load_all()`

Bind your source tree into the container, then load it from the bound path:

```bash
module load apptainer

apptainer exec --cleanenv --containall --pwd / \
  -B $HOME/Documents/Github:/work \
  rgl-test.sif \
  xvfb-run -s "-screen 0 1024x768x24" \
  R --vanilla -q -e "pkgload::load_all('/work/YOUR_PACKAGE')"
```

Notes:

- replace `YOUR_PACKAGE` with the directory name of the package
- `pkgload` and the `ciftiTools` import set are already baked into the image, so `ciftiTools` can be loaded from source without interactive installs
- `xvfb-run` is only necessary if the package or script actually opens `rgl`
- for `ciftiTools` development, do not install `ciftiTools` in the image; bind the repo and use `pkgload::load_all()`

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

Example in this folder:

```bash
module load apptainer

mkdir -p $HOME/Documents/Github/hpc-containers/R-RGL/out

apptainer exec --cleanenv --containall --pwd /work/hpc-containers/R-RGL/out \
  -B $HOME/Documents/Github/hpc-containers:/work/hpc-containers \
  -B $HOME/Documents/Github/ciftiTools:/work/ciftiTools \
  $HOME/rgl-test.sif \
  xvfb-run -s "-screen 0 1024x768x24" \
  Rscript --vanilla -e "source('/work/hpc-containers/R-RGL/example_script.R')"
```

This example script does two things internally:

- loads the bound `ciftiTools` source tree from `/work/ciftiTools`
- sets `wb_path` to the bundled container Workbench at `/opt/workbench/bin_rh_linux64/wb_command`
- writes `ciftitools_example.png` into the working directory, so the command above sets `--pwd` to the bound writable folder `/work/hpc-containers/R-RGL/out`

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
