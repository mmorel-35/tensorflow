# Bzlmod Support in TensorFlow

TensorFlow now has experimental support for Bazel's new module system (bzlmod) alongside the traditional WORKSPACE setup.

## Status: Experimental

Bzlmod support in TensorFlow is currently **experimental**. The WORKSPACE-based build system remains the default and recommended approach for production builds.

## Requirements

- Bazel version 7.6.1 (specifically, not 8.x)

## Using WORKSPACE (Default and Recommended)

The traditional WORKSPACE system is still the default and most stable option:

```bash
bazel build //tensorflow/...
```

## Using Bzlmod (Experimental)

To try the experimental bzlmod support, enable it with a flag:

```bash
bazel build --enable_bzlmod //tensorflow/...
```

**Note:** Full bzlmod support requires all dependencies to be available as Bazel modules. TensorFlow has many dependencies that are not yet available in the Bazel Central Registry (BCR), so bzlmod mode may not work for all build targets.

## Current Limitations

As of now, bzlmod support in TensorFlow is experimental due to:

1. **Missing Dependencies**: Many TensorFlow dependencies are not yet available as Bazel modules in the BCR
2. **Custom Repository Rules**: TensorFlow uses custom repository rules (like `tf_vendored`) that require WORKSPACE
3. **Transitive Dependencies**: Complex dependency chains that haven't been fully migrated to bzlmod

The MODULE.bazel file provides a foundation for future migration, declaring core dependencies that are available in the BCR.

The MODULE.bazel file includes the following key dependencies synchronized with WORKSPACE versions:

- **bazel_skylib**: 1.7.1 (same as WORKSPACE)
- **rules_license**: 1.0.0 (updated from WORKSPACE 0.0.7)
- **rules_pkg**: 1.0.1 (updated from WORKSPACE 0.7.1)
- **bazel_features**: 1.25.0 (same as WORKSPACE)
- **platforms**: 0.0.11 (same as WORKSPACE)
- **rules_jvm_external**: 6.8 (updated from WORKSPACE 4.3 for bzlmod compatibility)
- **rules_proto**: 7.1.0 (updated from WORKSPACE commit for bzlmod compatibility)
- **rules_shell**: 0.4.1 (same as WORKSPACE)

## Local Vendored Repositories

TensorFlow uses local vendored copies of XLA and TSL. In bzlmod mode, these are loaded through a custom module extension defined in `tensorflow/extensions.bzl`:

- `@local_xla` → `third_party/xla`
- `@local_tsl` → `third_party/xla/third_party/tsl`

These repositories are automatically available in both WORKSPACE and bzlmod modes.

## Migration Notes

### Updated Versions

Some dependencies have been updated to newer versions that are available in the Bazel Central Registry (BCR):

- `rules_license` was updated from 0.0.7 to 1.0.0 (0.0.7 not available in BCR)
- `rules_pkg` was updated from 0.7.1 to 1.0.1 (0.7.1 not available in BCR)
- `rules_jvm_external` was updated from 4.3 to 6.8 (4.3 not available in BCR)
- `rules_proto` was updated to 7.1.0 (using versioned release instead of commit hash)

These updates maintain backward compatibility while enabling bzlmod support.

### Compatibility

Both WORKSPACE and MODULE.bazel are maintained in parallel to ensure:
- Existing builds continue to work with `--noenable_bzlmod`
- New builds can take advantage of bzlmod's improved dependency resolution
- Dependencies are kept synchronized between both systems

## Future Work

To achieve full bzlmod support, the following work is needed:

1. Wait for more TensorFlow dependencies to become available in the BCR
2. Create Bazel module extensions for custom repository rules
3. Migrate complex third-party dependencies to use modules
4. Test and validate all build targets with bzlmod enabled

The current MODULE.bazel provides a starting point for this gradual migration.

## Troubleshooting

If you encounter issues with bzlmod:

1. Use WORKSPACE mode (default): `bazel build //tensorflow/...`
2. Ensure you're using Bazel 7.6.1 (check with `bazel version`)
3. Try cleaning the build: `bazel clean --expunge`
4. Report issues with bzlmod builds to help improve support

For stable builds, continue using the WORKSPACE-based system (which is the default).
