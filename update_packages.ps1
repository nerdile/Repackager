Param(
  [string]$PackageDir,
  [string[]]$updates
)

if (!$g_RepackagedFeed) {
  throw "g_RepackagedFeed was not set";
}

foreach ($pkg in $updates) {
  & $PackageDir\$pkg\make_package_from_upstream.ps1
  $outputs = (gci "$g_StagingDir\$pkg\*.nupkg");
  if ($outputs.Count -eq 0) { throw "$pkg`: Did not produce a nupkg in $g_StagingDir\$pkg" };
  if ($outputs.Count -ne 1) { throw "$pkg`: Produced more than 1 nupkg in $g_StagingDir\$pkg" };
}

foreach ($pkg in $updates) {
  $nupkg = (gci $g_StagingDir\$pkg\*.nupkg)[0]
  & $g_NugetExe push $nupkg -Source $g_RepackagedFeed -ApiKey AwesomeRepackager
}
