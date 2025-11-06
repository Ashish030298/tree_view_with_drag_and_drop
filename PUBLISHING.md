# Publishing Guide

This guide will help you publish the `tree_view_with_drag_and_drop` package to pub.dev.

## Prerequisites

1. **Dart SDK**: Ensure you have the Dart SDK installed (comes with Flutter)
2. **pub.dev Account**: Create an account at [pub.dev](https://pub.dev)
3. **Google Account**: You'll need a Google account to sign in to pub.dev

## Pre-Publication Checklist

### 1. Update Package Information

Before publishing, update these files:

#### `pubspec.yaml`
```yaml
name: tree_view_with_drag_and_drop
description: A customizable Flutter tree view widget with drag-and-drop support
version: 1.0.0
homepage: https://github.com/ashish030298/tree_view_with_drag_and_drop
repository: https://github.com/ashish030298/tree_view_with_drag_and_drop
```

**Replace:**
- `ashish030298` with your GitHub username
- Update the `homepage` and `repository` URLs

#### `LICENSE`
```
Copyright (c) 2025 ashish030298
```

**Replace:**
- `YOUR_NAME` with your actual name or organization

### 2. Create GitHub Repository

1. Create a new repository on GitHub
2. Initialize git in your package directory:
   ```bash
   cd tree_view_with_drag_and_drop
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/tree_view_with_drag_and_drop.git
   git push -u origin main
   ```

### 3. Validate Your Package

Run the following command to check for issues:

```bash
dart pub publish --dry-run
```

This will validate your package without actually publishing it. Fix any errors or warnings that appear.

### 4. Run Tests (Optional but Recommended)

Create tests in the `test/` directory and run:

```bash
flutter test
```

### 5. Check Package Score

The package will be scored based on:
- Documentation
- Platform support
- Code style
- Null safety
- Dependencies

Make sure your package follows best practices.

## Publishing Steps

### Step 1: Login to pub.dev

```bash
dart pub login
```

This will open a browser window. Sign in with your Google account and authorize the Dart client.

### Step 2: Publish the Package

```bash
dart pub publish
```

You'll be asked to confirm. Type `y` to proceed.

### Step 3: Verify Publication

After publishing, your package will be available at:
```
https://pub.dev/packages/tree_view_with_drag_and_drop
```

## Post-Publication

### 1. Add Package Badge to README

Update your README.md with the pub.dev badge:

```markdown
[![pub package](https://img.shields.io/pub/v/tree_view_with_drag_and_drop.svg)](https://pub.dev/packages/tree_view_with_drag_and_drop)
```

### 2. Add Screenshots (Recommended)

Add screenshots or GIFs to improve your package presentation:

1. Create a `screenshots` directory
2. Add images showing your package in action
3. Update `pubspec.yaml`:
   ```yaml
   screenshots:
     - description: 'Tree view with drag and drop'
       path: screenshots/demo.gif
   ```

### 3. Create Documentation

Consider adding:
- API documentation (using `///` comments in your code)
- More examples
- Video tutorials
- Blog posts

## Updating Your Package

When you need to release a new version:

### 1. Update Version Number

Update `version` in `pubspec.yaml` following [semantic versioning](https://semver.org/):

- **Major** (1.0.0 -> 2.0.0): Breaking changes
- **Minor** (1.0.0 -> 1.1.0): New features, backward compatible
- **Patch** (1.0.0 -> 1.0.1): Bug fixes, backward compatible

### 2. Update CHANGELOG.md

Add your changes to `CHANGELOG.md`:

```markdown
## 1.0.1

* Fixed drag and drop issue with nested nodes
* Improved documentation
* Added new example

## 1.0.0

* Initial release
```

### 3. Commit and Tag

```bash
git add .
git commit -m "Release version 1.0.1"
git tag v1.0.1
git push origin main --tags
```

### 4. Publish Update

```bash
dart pub publish
```

## Common Issues

### Issue: Package name already taken

**Solution**: Choose a different package name in `pubspec.yaml`

### Issue: Score is too low

**Solution**: 
- Add more documentation
- Write tests
- Fix linter warnings
- Add example code

### Issue: Publication failed

**Solution**:
- Check your internet connection
- Ensure you're logged in: `dart pub login`
- Verify all files are included and formatted correctly

## Best Practices

1. **Semantic Versioning**: Always follow semantic versioning
2. **Documentation**: Document all public APIs with `///` comments
3. **Examples**: Provide clear, working examples
4. **Tests**: Write tests for your code
5. **CHANGELOG**: Keep changelog updated
6. **Breaking Changes**: Clearly document breaking changes
7. **Backward Compatibility**: Maintain backward compatibility when possible
8. **License**: Include a clear license file
9. **Code Quality**: Follow Dart style guidelines
10. **Responsive**: Respond to issues and pull requests promptly

## Resources

- [Publishing packages](https://dart.dev/tools/pub/publishing)
- [Package layout conventions](https://dart.dev/tools/pub/package-layout)
- [Verified publishers](https://dart.dev/tools/pub/verified-publishers)
- [Package scoring](https://pub.dev/help/scoring)
- [Semantic versioning](https://semver.org/)

## Support

If you encounter any issues during publication:

1. Check the [pub.dev help](https://pub.dev/help)
2. Visit [Dart community](https://dart.dev/community)
3. Ask on [Stack Overflow](https://stackoverflow.com/questions/tagged/dart) with the `dart` tag

Good luck with your publication! 🚀