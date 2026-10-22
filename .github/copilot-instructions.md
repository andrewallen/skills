# Repository maintenance

Follow [GOVERNANCE.md](../GOVERNANCE.md) for changes, versioning and publishing, and [docs/adr](../docs/adr/README.md) for significant decisions.

- This repository packages skills; it is not the target workspace. Do not create workspace evidence or governed workspace folders here.
- When changing a name, path or rule, search the whole repository and update all affected plugin references.
- Bundle relevant skill, architecture, template and plugin version changes with the implementation. Check behaviour inherited from shared references, not only edited `SKILL.md` files.
- Keep the marketplace catalogue free of duplicate plugin version fields.
- Do not implement Proposed ADRs without explicit owner acceptance.
- Use the pull request checklist. State validation gaps and migration implications explicitly.
- Do not infer permission to commit, push, merge, publish or move existing user files.
- Keep every committed example and reference public-safe: no employer/customer proprietary material, private links, live inventories or identifiable case narratives. Use fictional examples without weakening real target input contracts.
- Distinguish static repository/parser validation from skill/helper execution; respect the requested scope and record runtime gaps explicitly.
