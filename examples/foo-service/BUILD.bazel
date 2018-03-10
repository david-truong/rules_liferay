load("//liferay:liferay.bzl", "liferay_application")

liferay_application(
    name = "foo-service",
    srcs = (glob(["src/main/java/**/*.java"])),
    resources = (glob(["src/main/resources/*"])),
    deps = [
        "//examples/foo-api",
        "//third_party:bndlib_artifact",
        "//third_party:osgi_service_tracker_collections_artifact",
        "//third_party:osgi_util_artifact",
        "//third_party:portal_kernel_artifact",
        "//third_party:portal_spring_extender_artifact",
    ],
)