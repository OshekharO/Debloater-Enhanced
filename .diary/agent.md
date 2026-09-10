## 2026-04-05 - ADB Package Query Optimization

**Learning:** Batch package uninstallation/disabling in shell and batch scripts suffers from severe O(N) ADB subprocess overhead when querying `adb shell pm list packages` for every target package individually. Caching the package list in an in-memory variable (`debloat.sh`) or a temporary file (`debloat.bat`) reduces query overhead from O(N) to O(1) ADB calls per session/category run.

**Action:** Lazy-initialize an installed package cache on the first check and invalidate/remove individual entries upon successful uninstallation.
