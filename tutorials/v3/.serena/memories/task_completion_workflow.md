# Task Completion Workflow

## Post-Task Actions
Since this is a documentation repository with GitBook-style markdown content, there are no traditional build, test, or compilation steps. However, the following workflow should be followed when completing documentation tasks:

## Documentation Quality Checks
1. **Content Validation**: 
   - Verify all internal links work correctly
   - Check that code examples are syntactically correct
   - Ensure consistent formatting and style

2. **Structure Verification**:
   - Confirm feature documentation follows standard pattern (README, setup, usage, testing, FAQ)
   - Validate GitBook table of contents (SUMMARY.md) includes new content
   - Check cross-references and content-ref links

3. **Platform Consistency**:
   - Ensure iOS and Android specific instructions are clearly marked
   - Verify Unity version compatibility notes are accurate
   - Check that tvOS limitations are documented where applicable

## Manual Review Process
```bash
# Check for broken internal links
find . -name "*.md" -exec grep -l "\[.*\](.*\.md)" {} \;

# Validate GitBook syntax
grep -r "{% " . --include="*.md" | grep -v "embed\|hint\|content-ref"

# Review new content structure
ls -la features/[new-feature]/
```

## Git Workflow
```bash
git status                    # Review changes
git add [modified-files]      # Stage specific changes
git commit -m "docs: [description]"  # Use conventional commit format
git push origin main          # Push to main branch
```

## Content Testing
- **Editor Simulation**: Content should reference Unity Editor simulation capabilities
- **Platform Testing**: Documentation should include testing procedures for iOS/Android
- **User Journey**: Verify documentation flows logically from setup to advanced usage

## No Traditional Build Commands
Unlike code repositories, this documentation project has no:
- Compilation or build steps
- Unit tests or test suites
- Linting tools (beyond manual markdown validation)
- Package management beyond git operations

The "testing" here refers to validating documentation accuracy and ensuring the described Unity plugin features work as documented on actual devices and Unity Editor.