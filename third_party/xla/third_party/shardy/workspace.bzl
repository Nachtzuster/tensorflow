"""Provides the repository macro to import Shardy."""

load("//third_party:repo.bzl", "tf_http_archive", "tf_mirror_urls")

def repo():
    SHARDY_COMMIT = "4c96a2b63afb3b32cfc3446955f2132fcb00d249"
    SHARDY_SHA256 = "3c90123251a7e2cc6a54a8ac82b99fb82d4efc51f8a1dd10e2311bb9a9a328d3"

    tf_http_archive(
        name = "shardy",
        sha256 = SHARDY_SHA256,
        strip_prefix = "shardy-{commit}".format(commit = SHARDY_COMMIT),
        urls = tf_mirror_urls("https://github.com/openxla/shardy/archive/{commit}.zip".format(commit = SHARDY_COMMIT)),
        patch_file = ["//third_party/shardy:temporary.patch"],
    )
