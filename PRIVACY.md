# Privacy Policy for Discord Web Auto Quest Extension

Last updated: October 29, 2026

## Purpose

This extension automates supported Discord quests and displays their progress. It is independent of Discord and is not endorsed by Discord.

## Information used

The extension reads accepted quest identifiers, names, task requirements, enrollment and completion status, and progress from Discord's existing website modules. It also accesses channel identifiers to construct activity heartbeat requests. Quest information is held in browser memory for the progress panel. Clicking Copy JSON copies quest identifiers, names, progress, targets, and completion status to your clipboard.

The extension does not include analytics or a developer-operated data collection endpoint. It does not intentionally read message bodies, passwords, payment details, health information, or location. It uses Discord's existing signed-in API client to make authenticated requests; it does not implement a separate password or token collection feature.

## Requests and recipients

When automation runs, the extension sends quest progress, timestamps, and channel-related stream identifiers to Discord's quest API using the signed-in session. These requests simulate supported quest activity. Discord processes these requests under its own policies. This is not an entirely offline operation.

The panel loads an arrow image from pic.onlinewebfonts.com. That request exposes ordinary network information, such as the user's IP address and browser request headers, to the image host. Links to support services are opened only when users choose to visit them, and those services have their own privacy policies.

The public download website is hosted by Cloudflare. Website hosting involves processing network requests separately from the extension's in-browser operation.

## Storage and sharing

The extension has no persistent browser-storage implementation for quest data. The panel's quest state remains in memory for the page session. Console messages remain in the user's browser. Clipboard contents may remain until replaced or cleared, depending on the operating system.

There is no code in this package that sells user data or sends it to advertising or analytics services. Data is used for the quest functionality described above. Users control any subsequent sharing of copied JSON. Information voluntarily submitted for support is handled through the support service selected by the user.

## Permissions

- Discord host access: runs content scripts and modifies request headers on the allowed Discord websites.
- declarativeNetRequestWithHostAccess: changes the User-Agent header to emulate the Discord desktop client.
- scripting: injects the packaged quest automation script into the Discord page's MAIN world.
- activeTab: present in version 1.2.6, but the current implementation gets the target tab from the sender and already has Discord host access. This permission is redundant in this version.

## Choices

You can stop the page session, disable the extension, or uninstall it in your browser's extension settings. Disabling the extension stops its future operation but does not undo requests already sent to Discord. Clear copied JSON from your clipboard if you no longer want it there. Contact Discord about information retained by Discord.

## Support and changes

For questions about this extension or its data practices, use the support page linked from the download website, which provides the project's existing Discord support invite. Do not share passwords, tokens, or private messages when requesting support.

This policy will be updated when the extension's data practices change.
