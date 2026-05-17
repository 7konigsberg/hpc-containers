pkgload::load_all("/work/ciftiTools", quiet = FALSE)

if (!file.exists("/opt/workbench/bin_rh_linux64/wb_command")) {
  stop("Expected bundled Workbench at /opt/workbench/bin_rh_linux64/wb_command")
}

ciftiTools.setOption("wb_path", "/opt/workbench/bin_rh_linux64/wb_command")

xii <- read_cifti(ciftiTools.files()$cifti["dscalar"])

out_png <- "ciftitools_example.png"

view_xifti_surface(
  xii,
  idx = 1,
  title = "ciftiTools example",
  fname = out_png
)

cat(normalizePath(out_png), "\n")
