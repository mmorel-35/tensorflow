"""Bazel module extensions for TensorFlow non-module dependencies."""

load("//third_party:repo.bzl", "tf_vendored")

def _non_module_deps_impl(ctx):
    """Implementation of non_module_deps extension."""
    # Local vendored repositories
    tf_vendored(name = "local_xla", path = "third_party/xla")
    tf_vendored(name = "local_tsl", path = "third_party/xla/third_party/tsl")

non_module_deps = module_extension(
    implementation = _non_module_deps_impl,
)
