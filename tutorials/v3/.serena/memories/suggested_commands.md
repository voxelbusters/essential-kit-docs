# Suggested Commands for Essential Kit v3 Documentation

## Git Operations
```bash
git status                    # Check repository status
git add .                     # Stage all changes
git commit -m "message"       # Commit changes
git push origin main          # Push to main branch
git pull origin main          # Pull latest changes
```

## File Operations (macOS/Darwin)
```bash
ls -la                        # List files with details
find . -name "*.md"           # Find markdown files
grep -r "pattern" .           # Search for text patterns
head -20 file.md              # Show first 20 lines
tail -20 file.md              # Show last 20 lines
```

## Documentation Validation
```bash
# Check for broken internal links
find . -name "*.md" -exec grep -l "\[.*\](.*\.md)" {} \;

# Find all GitBook specific syntax
grep -r "{% " . --include="*.md"

# Check for consistent feature structure
ls features/*/README.md
ls features/*/usage.md
ls features/*/testing.md
```

## Content Analysis
```bash
# Count documentation files
find . -name "*.md" | wc -l

# Find large files that might need review
find . -name "*.md" -exec wc -l {} \; | sort -nr | head -10

# Check for TODO or FIXME markers
grep -r -i "todo\|fixme" . --include="*.md"
```

## Directory Navigation
```bash
cd features/address-book      # Navigate to specific feature
cd plugin-overview           # Navigate to settings docs
cd AllTutorialsRawData       # Navigate to source content
```

## Content Search
```bash
# Find references to specific features
grep -r "BillingServices" . --include="*.md"
grep -r "Game Services" . --include="*.md"
grep -r "Unity" . --include="*.md"

# Search for code examples
grep -r "```csharp" . --include="*.md"
```

## Quality Checks
```bash
# Check for consistent header levels
grep -r "^#" . --include="*.md" | head -20

# Find files with platform-specific content
grep -r -l "iOS\|Android" . --include="*.md"

# Check for broken image references
grep -r "!\[.*\](" . --include="*.md"
```

Note: This is a documentation-only repository. No build, test, or compilation commands are applicable as this contains GitBook-style markdown content for Unity plugin documentation.