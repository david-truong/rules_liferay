package(default_visibility = ["//:__subpackages__"])

load("//liferay:liferay.bzl", "liferay_application")

liferay_application(
    name = "foo-api",
    srcs = (glob(["src/main/java/**/*.java"])),
    deps = [
        "//third_party:bndlib_artifact",
        "//third_party:osgi_service_tracker_collections_artifact",
        "//third_party:osgi_util_artifact",
        "//third_party:portal_kernel_artifact",
        "//third_party:osgi_core_artifact",
    ],
)