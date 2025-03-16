load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

# copybara:uncomment package(default_applicable_licenses = ["//tensorflow:license"])

exports_files(["pybind_extension.py.tpl"])

bzl_library(
    name = "pywrap_bzl",
    srcs = [
        "pywrap.bzl",
        # copybara:uncomment "pywrap.google.bzl",
        "pywrap.impl.bzl",
    ],
    # copybara:uncomment parse_tests = False,
    visibility = ["//visibility:public"],
)

# copybara:comment_begin(oss-only)
py_binary(
    name = "def_file_filter_tool",
    srcs = [":def_file_filter_tool.py"],
    visibility = ["//visibility:public"],
)
# copybara:comment_end
