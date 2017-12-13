load("//liferay:liferay.bzl", "liferay_jar")

java_library(
    name = "authenticator_shiro_lib",
    srcs = (glob(["src/main/java/**/*.java"])),
    deps = [
        "@portal_kernel//jar",
        "@shiro_core//jar",
        "@osgi_service_component_annotations//jar",
    ],
)

liferay_jar(
    name = "authenticator-shiro",
    bnd = "bnd.bnd",
    classes = ":authenticator_shiro_lib",
    deps = [
        "@portal_kernel//jar",
        "@shiro_core//jar",
        "@osgi_service_component_annotations//jar",
    ],
)

