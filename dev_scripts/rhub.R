install.packages("rhub")
Sys.setenv(GITHUB_PAT = "my_pat")
rhub::rhub_setup()
rhub::rhub_doctor()

#full check
rhub::rhub_check(
  platforms = c(
    "linux",
    "macos",
    "macos-arm64",
    "windows",
    "atlas",
    "c23",
    "clang-asan",
    "clang16",
    "clang17",
    "clang18",
    "clang19",
    "gcc13",
    "gcc14",
    "intel",
    "mkl",
    "nold",
    "ubuntu-clang",
    "ubuntu-gcc12",
    "ubuntu-next",
    "ubuntu-release"
  )
)
