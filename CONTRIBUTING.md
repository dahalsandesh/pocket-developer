# Contributing to The Pocket Developer (PocketDev)

Thank you for your interest in contributing to **The Pocket Developer**!

Our mission is to prove and teach how modern smartphones can function as first-class software engineering, networking, and home automation workstations.

---

## 🌟 1. Submitting Your Project to the Showcase

Have you built a mobile app, website, terminal bot, network utility, or home server entirely on your phone? We would love to feature it in [**`docs/06-showcase.md`**](docs/06-showcase.md)!

### How to Submit:
Open a Pull Request updating `docs/06-showcase.md` with:
- **Project Name & GitHub Link:** Direct link to your repository.
- **Creator Attribution:** Your name, website, and GitHub handle.
- **Device & Specs:** Host phone model, processor (SoC), RAM, and Linux environment used.
- **What It Does:** 2–3 sentence high-signal summary of the application.
- **Compilation/Runtime Stats:** Build time on device, APK/binary size, memory footprint.

---

## 🛠️ 2. Contributing Scripts, Guides, or Templates

We welcome PRs that optimize build pipelines, add PRoot distribution guides, or provide useful micro-tools.

### Contribution Standards:
1. **ARM64 Native:** Every script or tool must execute cleanly inside unprivileged Linux (PRoot or chroot) on an ARM64 (`aarch64`) architecture.
2. **Zero Bloat Policy:** Prefer standard Linux tools (`curl`, `grep`, `awk`, `python3`, `bash`, `openjdk`) over heavy package ecosystems or complex container daemons whenever possible.
3. **Clean UI/UX Standard:** Documentation must be clean, structured, and free of hype, carnival emojis, or exaggerated marketing claims. Keep diagrams crisp (Mermaid) and typography readable.
4. **No Binary Bloat in Git:** Never commit compiled APKs (`*.apk`), Dalvik DEX files (`*.dex`), or large Android SDK `.jar` binaries directly to Git. Use dynamic download scripts or GitHub Releases for binary distribution.

---

## 📋 3. Pull Request Workflow

1. Fork the repository on GitHub.
2. Create a clean feature branch:
   ```bash
   git checkout -b feat/my-enhancement
   ```
3. Commit your changes with clear, descriptive commit messages:
   ```bash
   git commit -m "docs: add Alpine Linux PRoot setup instructions"
   ```
4. Push to your fork and submit a Pull Request targeting `master`.
5. Clearly describe what changed and how you tested it on your mobile device.

---

## 📄 License

By contributing to PocketDev, you agree that your contributions will be licensed under the project's [MIT License](LICENSE).
