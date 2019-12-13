Param(
  [string]$PackageDir
)
$items = @();
gci $PackageDir -Directory | %{ $_.BaseName } | %{
  $items += (New-Object PackageVersionItem -Property @{
    Name = $_;
    UpstreamVersion = (& $PackageDir\$_\get_upstream_version.ps1);
    FeedVersion = (& $g_RepackagerLib\get_package_nuget_version.ps1 $_);
  });
}
return $items;
