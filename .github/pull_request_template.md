<!-- PR title = squash-merge commit message → drives automated versioning.
     Format:   type: short description          (e.g. feat: add contact search)
     Breaking: feat!: short description         (→ major release)
     No release: chore: / ci: / test: / build:

     Allowed types: feat · fix · perf · refactor · docs · chore · ci · test · build -->

## What changed and why

<!-- Briefly describe what this PR does and the motivation behind it. Link the related issue. -->

Closes #

## Breaking changes

<!-- Required when the PR title uses ! (e.g. feat!:) or the body contains BREAKING CHANGE:.
     Describe exactly what breaks and how consumers need to migrate. -->

N/A

## Checklist

### Code quality
- [ ] Every function has an explicit return type (`explicit-function-return-type`)
- [ ] Every class member has an explicit access modifier (`explicit-member-accessibility`)
- [ ] No non-null assertions (`!`) outside of `*.test.ts` files
- [ ] No floating promises (every `Promise` is awaited or explicitly handled)

### Tests
- [ ] New functionality is covered by unit tests (colocated `*.test.ts`)
- [ ] `npm test` passes locally (build + jest + coverage)

### Linting
- [ ] `npm run lint:eslint` passes
- [ ] `npm run lint:prettier` passes
- [ ] `npm run lint:types` passes

### Release
- [ ] README.md updated if public API changed
