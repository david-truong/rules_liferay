package(default_visibility = ["//visibility:public"])

java_binary(
    name = "osgi_bundle_builder",
    srcs = ["src/main/java/com/liferay/bazel/BazelOSGiBundleBuilder.java"],
    deps = [
        "//third_party:osgi_bundle_builder_artifact",
        "//third_party:css_builder_artifact",
    ],
    main_class = "com.liferay.bazel.BazelOSGiBundleBuilder"
)

java_binary(
    name = "theme_builder",
    srcs = ["src/main/java/com/liferay/bazel/BazelThemeBuilder.java"],
    deps = [
    	"//third_party:theme_builder_artifact",
      "//third_party:css_builder_artifact",
	  ],
    main_class = "com.liferay.bazel.BazelThemeBuilder"
)