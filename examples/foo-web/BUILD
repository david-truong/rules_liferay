load("//liferay:liferay.bzl", "liferay_application", "sass_binary", "sass_library")

liferay_application(
    name = "foo-web",
    srcs = (glob(["src/main/java/**/*.java"])),
    resources = glob(["src/main/resources/*"]) + [":main_css"],
    deps = [
        "//examples/foo-api",
        "//third_party:portal_kernel_artifact",
        "//third_party:portlet_api_artifact",
        "//third_party:servlet_api_artifact",
        "//third_party:osgi_service_component_annotations_artifact",
    ],
)

sass_library(
    name = "partials",
    srcs = [
        "src/main/resources/META-INF/resources/css/_partial.scss",
    ],
    deps = [
	    "//examples/sass_libraries:liferay_common_css",
    ]
)

sass_binary(
    name = "main_css",
    src = "src/main/resources/META-INF/resources/css/main.scss",
    deps = [
    	":partials",
    ],
)