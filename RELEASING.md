# Add-on Release Workflow (Single Folder)

By using a single folder (`ipmi-server`), you manage the "Environment" (Edge vs. Stable) purely through **GitHub Releases** and the **version** field in `config.yaml`.

---

## 1. Development Phase (Edge/Dev)

- **Config:** Set `version: "dev"` in `ipmi-server/config.yaml`.
- **Action:** Push code changes to the `main` branch.
- **Result:** GitHub Actions builds images tagged as `:dev`.
- **User Impact:** Only users who have manually installed the "dev" version see these updates. No notifications are sent to stable users.

---

## 2. Release Phase (Stable)

When the code is ready for all users:

### Step A: Update the Configuration

1. Open `ipmi-server/config.yaml`.
2. Change `version: "dev"` to a specific version number (e.g., `version: "2.1.0"`).
3. **Commit and Push** this change to your `main` branch.

### Step B: Create a GitHub Release

1. Go to your repository on GitHub and click **Releases** > **Draft a new release**.
2. **Tag:** Enter `v2.1.0` (must match the version in your config).
3. **Title:** `Version 2.1.0`.
4. **Pre-release Checkbox:**
   - **Leave UNCHECKED** for a **Stable** release (notifies everyone).
   - **Check it** for a **Beta** release (notifies only Advanced Mode users).
5. Click **Publish release**.

### Step C: Automation

The **Deploy** workflow triggers automatically. It builds the images and tags them as `:2.1.0` and `:latest`.

---

## 3. Post-Release (Reset to Dev)

To continue development without affecting your new release:

1. Open `ipmi-server/config.yaml`.
2. Change the version back to `version: "dev"`.
3. **Commit and Push** to `main`.

---

## Summary of Release Tiers

| Version in Config | GitHub Release Type | User Experience                                     |
| :---------------- | :------------------ | :-------------------------------------------------- |
| **"dev"**         | Push to `main`      | Edge/Dev users only. No notifications.              |
| **"2.1.0b1"**     | **Pre-release**     | Notifies users with **Advanced Mode** enabled.      |
| **"2.1.0"**       | **Latest Release**  | **Notifies all users** that an update is available. |
