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
"@;
