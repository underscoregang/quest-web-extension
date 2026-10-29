# Cloudflare download hosting

Cloudflare hosts a download page and extension ZIP. The extension runs in each user's browser.

Live site: https://underscore-quest-extension.peachygang.workers.dev

## Build

From the repository root in PowerShell:

```powershell
powershell -NoProfile -File scripts/build-download.ps1
```

Only the generated `dist/` directory is published. The extension ZIP uses an explicit list of files, excluding Git, editor files, credentials, and browser-generated metadata.

## Deploy to Cloudflare Workers

```powershell
npx wrangler login
npx wrangler deploy
```

If your network uses a certificate trusted by Windows but Wrangler reports a certificate mismatch, run `$env:NODE_USE_SYSTEM_CA='1'` in the same PowerShell session and retry (Node 24+).

Wrangler prints the public URL after deployment. Users can download the ZIP from that URL, extract it, enable Developer mode in their browser's extensions page, and choose **Load unpacked**.

For updates, rebuild and run the deploy command again. ZIP installations require manual updates. One-click Chrome installation and managed updates generally require Chrome Web Store distribution.

## Alternative: Cloudflare Pages dashboard

In Workers & Pages, create a Pages project using Direct Upload and upload the contents of `dist/`. Do not upload the repository root or upload `quest-extension.zip` as the site itself: the site must contain `index.html` and the downloadable ZIP.

Documentation: https://developers.cloudflare.com/workers/static-assets/ and https://developers.cloudflare.com/pages/get-started/direct-upload/
