load("//liferay:liferay.bzl", "liferay_application")

liferay_application(
    name = "authenticator-shiro",
    srcs = (glob(["src/main/java/**/*.java"])),
    resources = (glob(["src/main/resources/*"])),
    deps = [
        "//third_party:portal_kernel_artifact",
        "//third_party:shiro_core_artifact",
        "//third_party:osgi_service_component_annotations_artifact",
    ],
)