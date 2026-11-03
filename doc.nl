
```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <title>agent-desktop</title>

  <meta
    name="description"
    content="A CLI and C library that lets AI agents read and operate desktop apps on macOS, Windows, and Linux through the OS accessibility tree."
  />

  <style>
    :root {
      color-scheme: light dark;

      --background: #ffffff;
      --foreground: #18181b;
      --muted: #71717a;
      --subtle: #a1a1aa;
      --border: #e4e4e7;
      --surface: #fafafa;
      --surface-hover: #f4f4f5;
      --code-background: #18181b;
      --code-foreground: #f4f4f5;
      --accent: #111111;

      --header-height: 64px;
      --sidebar-width: 260px;
      --toc-width: 220px;
      --content-width: 760px;
    }

    @media (prefers-color-scheme: dark) {
      :root {
        --background: #0a0a0a;
        --foreground: #ededed;
        --muted: #a1a1aa;
        --subtle: #71717a;
        --border: #27272a;
        --surface: #111113;
        --surface-hover: #18181b;
        --code-background: #111113;
        --code-foreground: #f4f4f5;
        --accent: #ffffff;
      }
    }

    * {
      box-sizing: border-box;
    }

    html {
      scroll-behavior: smooth;
      scroll-padding-top: calc(var(--header-height) + 24px);
    }

    body {
      min-height: 100vh;
      margin: 0;
      color: var(--foreground);
      background: var(--background);
      font-family:
        Inter,
        ui-sans-serif,
        system-ui,
        -apple-system,
        BlinkMacSystemFont,
        "Segoe UI",
        sans-serif;
      font-size: 15px;
      line-height: 1.7;
      text-rendering: optimizeLegibility;
    }

    a {
      color: inherit;
      text-decoration-color: var(--subtle);
      text-underline-offset: 4px;
    }

    a:hover {
      text-decoration-color: var(--foreground);
    }

    button,
    input {
      font: inherit;
    }

    button {
      color: inherit;
    }

    code,
    pre {
      font-family:
        "SFMono-Regular",
        Consolas,
        "Liberation Mono",
        Menlo,
        monospace;
    }

    .skip-link {
      position: fixed;
      top: 8px;
      left: 8px;
      z-index: 200;
      padding: 8px 12px;
      border-radius: 7px;
      color: var(--background);
      background: var(--foreground);
      transform: translateY(-150%);
      transition: transform 160ms ease;
    }

    .skip-link:focus {
      transform: translateY(0);
    }

    .header {
      position: sticky;
      top: 0;
      z-index: 100;
      height: var(--header-height);
      border-bottom: 1px solid var(--border);
      background: color-mix(in srgb, var(--background) 88%, transparent);
      backdrop-filter: blur(14px);
    }

    .header-inner {
      display: flex;
      align-items: center;
      gap: 24px;
      width: 100%;
      height: 100%;
      padding: 0 24px;
    }

    .brand {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      min-width: calc(var(--sidebar-width) - 24px);
      font-weight: 650;
      letter-spacing: -0.02em;
      text-decoration: none;
    }

    .brand-mark {
      display: grid;
      width: 28px;
      height: 28px;
      place-items: center;
      border-radius: 7px;
      color: var(--background);
      background: var(--foreground);
      font-size: 14px;
      font-weight: 800;
    }

    .header-center {
      display: flex;
      flex: 1;
      justify-content: center;
    }

    .search {
      display: flex;
      align-items: center;
      gap: 10px;
      width: min(100%, 420px);
      height: 36px;
      padding: 0 12px;
      border: 1px solid var(--border);
      border-radius: 8px;
      color: var(--muted);
      background: var(--surface);
    }

    .search svg {
      flex: 0 0 auto;
    }

    .search input {
      width: 100%;
      min-width: 0;
      border: 0;
      outline: none;
      color: var(--foreground);
      background: transparent;
    }

    .search input::placeholder {
      color: var(--muted);
    }

    .header-links {
      display: flex;
      align-items: center;
      gap: 18px;
      font-size: 14px;
    }

    .header-links a {
      text-decoration: none;
    }

    .header-links a:hover {
      color: var(--muted);
    }

    .menu-button {
      display: none;
      width: 38px;
      height: 38px;
      padding: 0;
      border: 1px solid var(--border);
      border-radius: 8px;
      background: var(--surface);
      cursor: pointer;
    }

    .layout {
      display: grid;
      grid-template-columns:
        var(--sidebar-width)
        minmax(0, var(--content-width))
        var(--toc-width);
      justify-content: center;
      gap: 56px;
      max-width: 1440px;
      margin: 0 auto;
      padding: 0 32px;
    }

    .sidebar,
    .toc {
      position: sticky;
      top: var(--header-height);
      align-self: start;
      height: calc(100vh - var(--header-height));
      overflow-y: auto;
      scrollbar-width: thin;
    }

    .sidebar {
      padding: 32px 16px 48px 0;
      border-right: 1px solid var(--border);
    }

    .sidebar-group {
      margin-bottom: 28px;
    }

    .sidebar-heading {
      margin: 0 0 8px;
      padding: 0 10px;
      color: var(--muted);
      font-size: 12px;
      font-weight: 650;
      letter-spacing: 0.08em;
      text-transform: uppercase;
    }

    .sidebar-list {
      display: grid;
      gap: 2px;
      margin: 0;
      padding: 0;
      list-style: none;
    }

    .sidebar-link {
      display: block;
      padding: 7px 10px;
      border-radius: 7px;
      color: var(--muted);
      font-size: 14px;
      text-decoration: none;
    }

    .sidebar-link:hover {
      color: var(--foreground);
      background: var(--surface-hover);
    }

    .sidebar-link.active {
      color: var(--foreground);
      background: var(--surface-hover