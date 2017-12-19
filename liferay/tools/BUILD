package(default_visibility = ["//visibility:public"])

java_binary(
    name = "osgi_bundle_builder",
    runtime_deps = ["//third_party:osgi_bundle_builder_artifact"],
    main_class = "com.liferay.osgi.bundle.builder.OSGiBundleBuilder"
)

java_binary(
    name = "sass_compiler",
    runtime_deps = [
    	"//third_party:sass_compiler_api_artifact",
    	"//third_party:sass_compiler_jni_artifact",
	],
    main_class = "com.liferay.sass.compiler.jni.internal.JniSassCompiler"
)