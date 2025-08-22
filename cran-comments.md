## R CMD check results

This is a resubmission. The Windows build failed in the previous submission. 
The problematic code has now been replaced with a thread-safe approach using
a readers–writer lock lock which should satisfy the Rust compiler being used for
Windows builds. Confirmed working with Win-builder. 

0 errors | 0 warnings | 0 notes

Please note this package now depends upon Rust code and therefore uses
vendored dependencies. As such, an INFO statement may occur due to installed
file size (5.3Mb total size of which 4.3Mb is attributable to libs on local
machine).

## Test environments 

- windows-latest (R release)
- macOS-15 (R release)
- macOS-15 (R devel)
- ubuntu-24.04 (R release)
- ubuntu-24.04 (R oldrel-1)
- ubuntu-24.04 (R oldrel-2)

via GitHub actions https://github.com/ropensci/datefixR/actions

## Downstream dependencies

This package has no downstream dependencies
