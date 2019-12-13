# You need to set these variables before calling Repackager!

if (!$g_RepackagerLib) {
  $g_RepackagerLib = (Split-Path $script:MyInvocation.MyCommand.Path);
}
if (!$g_StagingDir) {
  $g_StagingDir = "$(Split-Path $script:MyInvocation.MyCommand.Path)\_staging";
}
if (!([System.IO.Directory]::Exists($g_StagingDir))) { [void](mkdir $g_StagingDir); }

if (!$g_NugetExe) {
  $g_NugetExe = "$g_StagingDir\nuget.exe"
  if ([System.IO.File]::Exists($g_NugetExe)) {
    & $g_NugetExe update -self
  } else {
    wget https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile $g_NugetExe
  }
}

if (!$g_RepackagerLoaded) {
  . $g_RepackagerLib\helpers.ps1
  $g_RepackagerLoaded = $True;
}