package(default_visibility = ["//visibility:public"])

load("//liferay:liferay.bzl", "sass_library")

sass_library(
	name = "bourbon_sass_library",
	srcs = (glob(["bourbon/**/*.scss"]))
)

sass_library(
	name = "liferay_sass_library",
	srcs = (glob(["liferay/**/*.scss"]))
)


sass_library(
    name = "liferay_common_css",
    srcs = [
    	"_bourbon.scss",
    	"_mixins.scss",
    ],
    deps = [
    	"//examples/sass_libraries:bourbon_sass_library",
    	"//examples/sass_libraries:liferay_sass_library",
    ]
)