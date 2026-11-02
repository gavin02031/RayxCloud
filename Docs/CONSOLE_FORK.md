# RayxCloud console dashboard fork

This branch adds a console-inspired SwiftUI home to the existing native RayxCloud client.

## Included in this first milestone

- A featured cloud game hero based on the real authenticated Xbox catalog. It prefers a recently played game.
- Working shortcuts into all cloud games, recent games, and Xbox's discovery shelves.
- Dark, high-contrast console chrome and a green accent.
- The existing native WebRTC launch path and Game Pass sign-in are left intact.
- A GitHub Actions pipeline builds the iOS application on a hosted macOS 26 runner and uploads an **unsigned** IPA.

This is a community-made Xbox-inspired experience. It is not an official Microsoft or Xbox application.

## IPA build instructions

1. Open the GitHub Actions tab for this repository.
2. Select **Build iOS IPA**. On the default branch, select **Run workflow**. Pushes and pull requests also build automatically.
3. Download the **RayxCloud-unsigned-ipa** artifact after a successful run.
4. **Sign the IPA for your device before installing.** An unsigned IPA is not directly installable on a stock iPhone. Use your own legitimate Apple signing workflow (such as Xcode signing or a trusted personal sideloading method). Do not upload your Apple ID password, signing certificate, or Microsoft credentials to this repository.
5. Pair a physical Xbox, PlayStation, or compatible game controller. Upstream RayxCloud currently does not implement on-screen controls.

The action does not contain Apple secrets, does not disable runtime protections, and does not make a claim that Microsoft authorizes this client. Signed release automation can be added separately after an Apple signing setup has been chosen.

## Streaming library: what is possible

- **Cloud Gaming**: only titles Microsoft makes cloud-playable for the account, region, and current subscription are launchable. Owning a game alone does not automatically make it cloud-enabled.
- **Stream your own game**: Microsoft supports selected purchased titles outside the Game Pass catalog; their cloud eligibility still depends on Microsoft's servers. We should verify how the upstream library API presents those titles before adding a dedicated Owned section.
- **Remote Play**: a future separate feature can stream compatible games installed on the user's own Xbox console. The underlying packages include some remote console API work, but the app does not expose a production Remote Play UI yet.
- **PC streaming**: a separate future mode can stream installed PC games from a user-controlled host. It is not Xbox Cloud Gaming and must not be portrayed as Microsoft-hosted cloud gaming.

Do not attempt to spoof game ownership, bypass Microsoft's service entitlements, or claim unsupported games are on Xbox Cloud Gaming.

## Next milestones

1. Build and sign an IPA on an Apple device-signing setup, then test Microsoft login and WebRTC gameplay on an iPhone.
2. Verify actual cloud shelf data and improve focus navigation with physical controllers throughout the dashboard.
3. Add a genuine Owned Cloud Games view based on authenticated eligibility data, never by inventing titles.
4. Add Remote Play with a clear source selector and robust session shutdown, keeping it separate from cloud sessions.
5. Implement configurable on-screen controls as an independent input layer.

## Upstream and license

RayxCloud and the Stratix packages are GPL-3.0. Keep copyright, license, attribution, and protocol packages intact. Any distributed fork remains under the applicable GPL terms.
