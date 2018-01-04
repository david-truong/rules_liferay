load("//liferay:liferay.bzl", "liferay_application")

liferay_application(
    name = "foo-web",
    srcs = (glob(["src/main/java/**/*.java"])),
    resources = glob(["src/main/resources/**/*"]),
    deps = [
        "//examples/foo-api",
        "//third_party:portal_kernel_artifact",
        "//third_party:portlet_api_artifact",
        "//third_party:servlet_api_artifact",
        "//third_party:osgi_service_component_annotations_artifact",
    ],
)