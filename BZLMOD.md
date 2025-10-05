# Bzlmod Support in TensorFlow

TensorFlow now supports Bazel's new module system (bzlmod) alongside the traditional WORKSPACE setup.

## Requirements

- Bazel version 7.6.1 or higher (but not 8.x)

## Using Bzlmod (Default)

As of this update, bzlmod is enabled by default in `.bazelrc`. You can build TensorFlow using the standard Bazel commands:

```bash
bazel build //tensorflow/...
```

## Using WORKSPACE (Legacy)

If you need to use the traditional WORKSPACE system instead of bzlmod, you can disable bzlmod by adding the flag to your build command:

```bash
bazel build --noenable_bzlmod //tensorflow/...
```

Or you can add `common --noenable_bzlmod` to your local `.bazelrc.user` file.

## Module Dependencies

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

## Troubleshooting

If you encounter issues with bzlmod:

1. Ensure you're using Bazel 7.6.1 (check with `bazel version`)
2. Try cleaning the build: `bazel clean --expunge`
3. Try using WORKSPACE mode: `bazel build --noenable_bzlmod //tensorflow/...`
4. Check the MODULE.bazel.lock file is up to date: `bazel mod deps`

For issues specific to WORKSPACE mode, use the `--noenable_bzlmod` flag as described above.
