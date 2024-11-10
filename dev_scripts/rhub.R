install.packages("rhub")
Sys.setenv(GITHUB_PAT = "my_pat")
rhub::rhub_setup()
rhub::rhub_doctor()


#full check
rhub::rhub_check(
  platforms = c(
    "valgrind"
  )
)

#leak summary
==1670== LEAK SUMMARY:
  ==1670==    definitely lost: 186,720 bytes in 24 blocks
==1670==    indirectly lost: 0 bytes in 0 blocks
==1670==      possibly lost: 196,131 bytes in 6,398 blocks
==1670==    still reachable: 205,758,906 bytes in 46,371 blocks
==1670==                       of which reachable via heuristic:
  ==1670==                         newarray           : 4,264 bytes in 1 blocks
==1670==         suppressed: 0 bytes in 0 blocks
==1670== Reachable blocks (those to which a pointer was found) are not shown.
==1670== To see them, rerun with: --leak-check=full --show-leak-kinds=all
==1670==
  ==1670== For lists of detected and suppressed errors, rerun with: -s
==1670== ERROR SUMMARY: 307 errors from 307 contexts (suppressed: 0 from 0)

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
    "nosuggests",
    "ubuntu-clang",
    "ubuntu-gcc12",
    "ubuntu-next",
    "ubuntu-release"
  )
)
