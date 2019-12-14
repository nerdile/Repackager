Param(
  [string]$packagename
)

if (!$g_RepackagedFeed) {
  throw "g_RepackagedFeed was not set";
}
if (!$g_RepackagedPrefix) {
  throw "g_RepackagedPrefix was not set";
}

$package = "$g_RepackagedPrefix.$packagename";
Write-Verbose "$g_NugetExe list $package -Source $g_RepackagedFeed -NonInteractive";
$pkgs = (& $g_NugetExe list $package -Source $g_RepackagedFeed -NonInteractive) | ?{ !($_.StartsWith("MSBuild auto-detection")) }
if ($pkgs[0] -eq "No packages found") { return [Version]::Parse("0.0.0.0"); }
$same = $pkgs | ?{ $_.Split(" ")[0] -eq $package }
if ($same.Count -eq 0) { return [Version]::Parse("0.0.0.0"); }
return (Normalize-Version ([Version]::Parse($same.Split(" ")[1])));
