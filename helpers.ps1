# Process exit helpers
Function Check-LastExitCode ($cmd)
{
  if ($LASTEXITCODE -ne 0) { throw "$cmd failed with $LASTEXITCODE"; }
}

# Version helpers
Function Normalize-Version($ver)
{
  return [Version]::new(
    [Math]::Max($ver.Major, 0),
    [Math]::Max($ver.Minor, 0),
    [Math]::Max($ver.Build, 0),
    [Math]::Max($ver.Revision, 0)
  )
}

# Types
Add-Type -TypeDefinition @"
public class PackageVersionItem {
  public string Name { get; set; }
  public System.Version UpstreamVersion { get; set; }
  public System.Version FeedVersion { get; set; }
}

public class FileAndVersion {
  public string FileName { get; set; }
  public System.Version Version { get; set; }
}
"@;

# Enumerates $folder\$wildcard and then finds the version from
# the file using the VersionRegex with named capture group "version"
# And returns the filename with the highest version
Function Find-LatestVersionByPatternInFolder (
  $Folder,
  $Wildcard,
  $VersionRegex
)
{
  $items = @();
  gci $Folder $Wildcard | %{ $_.Name } | %{ if ($_ -match $VersionRegex) {
    $ver = [Version]::Parse($Matches["version"]);
    $items += (New-Object FileAndVersion -Property @{
      FileName = $_;
      Version = $ver;
    });
    Write-Verbose "$_`: $ver";
  } };
  if ($items.Count -eq 0) { throw "No results found: $Folder\$Wildcard matching $VersionRegex"; }

  $MaxVer = ($items | Measure -Property Version -Maximum).Maximum;
  Write-Verbose "Max version: $MaxVer";
  return ($items | ?{ $_.Version -eq $MaxVer })[0];
}

# Nuspec Helpers
Function Set-NuspecPackageIdentity($templateNuspec, $outputNuspec, $packageName)
{
  $nsmgr = New-Object System.Xml.XmlNamespaceManager (new-object System.Xml.NameTable)
  $nsmgr.AddNamespace("nuspec", "http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd")

  $nuspec = [xml](gc $templateNuspec);
  $nuspec.SelectSingleNode("/nuspec:package/nuspec:metadata/nuspec:id", $nsmgr).'#text' = "$g_RepackagedPrefix.$packageName";
  $nuspec.Save($outputNuspec);
}

