$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$output = Join-Path $projectRoot 'dist'
$manifest = Get-Content (Join-Path $projectRoot 'manifest.json') -Raw | ConvertFrom-Json
New-Item -ItemType Directory -Force -Path $output | Out-Null
$files = @('manifest.json', 'background.js', 'quest-code.js', 'quest-home.js', 'rules.json', 'user-agent-check.js', 'user-agent-override.js', 'assets', 'LICENSE', 'PRIVACY.md', 'README.md')
$paths = $files | ForEach-Object { Join-Path $projectRoot $_ }
Compress-Archive -LiteralPath $paths -DestinationPath (Join-Path $output 'quest-extension.zip') -Force
$html = @'
<!doctype html>
<html lang="en">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Download Discord Web Auto Quest Extension</title>
<style>
body{margin:0;background:#10111b;color:#eee;font:18px/1.65 system-ui,sans-serif}main{max-width:720px;margin:8vh auto;padding:28px}h1{line-height:1.15;font-size:clamp(32px,6vw,52px)}a{color:#b9b2ff}.download{display:inline-block;padding:14px 24px;border-radius:12px;background:#b9b2ff;color:#10111b;font-weight:700;text-decoration:none}li{margin:10px 0}small{color:#bbb}
</style>
<main>
<small>UNDERSCORE · Version __VERSION__</small>
<h1>Discord Web Auto Quest Extension</h1>
<p>Download the extension and install it in your desktop Chromium browser.</p>
<p><a class="download" href="/quest-extension.zip" download>Download extension ZIP</a></p>
<h2>Install in Chrome or Edge</h2>
<ol>
<li>Download and extract the ZIP into a folder you will keep.</li>
<li>Open <code>chrome://extensions</code> in Chrome or <code>edge://extensions</code> in Edge.</li>
<li>Enable <strong>Developer mode</strong>.</li>
<li>Click <strong>Load unpacked</strong> and select the extracted folder containing <code>manifest.json</code>.</li>
<li>Open <a href="https://discord.com/quest-home">Discord Quests</a>.</li>
</ol>
<p>Updates require downloading the latest ZIP, replacing the extracted files, and clicking Reload on the browser's extensions page.</p>
<p>This extension automates Discord quests. Use at your own risk; your account may be restricted for violating Discord's terms.</p>
<p><a href="/privacy.txt">Privacy information</a> · <a href="/license.txt">License</a></p>
</main>
</html>
'@
$html.Replace('__VERSION__', [System.Net.WebUtility]::HtmlEncode($manifest.version)) | Set-Content (Join-Path $output 'index.html') -Encoding UTF8
Copy-Item -LiteralPath (Join-Path $projectRoot 'PRIVACY.md') -Destination (Join-Path $output 'privacy.txt')
Copy-Item -LiteralPath (Join-Path $projectRoot 'LICENSE') -Destination (Join-Path $output 'license.txt')
Write-Output "Built download site and extension v$($manifest.version) in $output"
