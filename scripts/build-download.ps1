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
<p><a href="/privacy.html">Privacy policy</a> · <a href="/support.html">Support</a> · <a href="/license.txt">License</a></p>
</main>
</html>
'@
$html.Replace('__VERSION__', [System.Net.WebUtility]::HtmlEncode($manifest.version)) | Set-Content (Join-Path $output 'index.html') -Encoding UTF8
Copy-Item -LiteralPath (Join-Path $projectRoot 'PRIVACY.md') -Destination (Join-Path $output 'privacy.txt')
Copy-Item -LiteralPath (Join-Path $projectRoot 'LICENSE') -Destination (Join-Path $output 'license.txt')
$privacyText = [System.Net.WebUtility]::HtmlEncode((Get-Content (Join-Path $projectRoot 'PRIVACY.md') -Raw -Encoding UTF8))
$privacyHtml = '<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Privacy policy - UNDERSCORE</title><style>body{max-width:850px;margin:40px auto;padding:24px;font:17px/1.7 system-ui;color:#202332}pre{white-space:pre-wrap;font:inherit;overflow-wrap:anywhere}</style><a href="/">Home</a> | <a href="/support.html">Support</a><pre>' + $privacyText + '</pre></html>'
$privacyHtml | Set-Content (Join-Path $output 'privacy.html') -Encoding UTF8
@'
<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Support - UNDERSCORE</title><style>body{max-width:750px;margin:40px auto;padding:24px;font:18px/1.7 system-ui;color:#202332}a{color:#4338ca}</style><main><a href="/">Home</a><h1>Extension support</h1><p>For help with Discord Web Auto Quest Extension, use the project's support community.</p><p><a href="https://discord.gg/peachygang">Open Discord support community</a></p><h2>What to include</h2><p>Your browser version, extension version, a description of the problem, and any relevant error message. Remove personal information from screenshots. Never send passwords, authentication tokens, or private messages.</p><h2>Installation help</h2><p>Extract the downloaded ZIP, open your browser's extensions page, enable Developer mode, then select Load unpacked and choose the folder containing manifest.json.</p><p><a href="/privacy.html">Privacy policy</a></p></main></html>
'@ | Set-Content (Join-Path $output 'support.html') -Encoding UTF8
Write-Output "Built download site and extension v$($manifest.version) in $output"
