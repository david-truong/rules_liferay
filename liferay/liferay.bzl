"""Liferay Rules

Skylark rules for building [Liferay](http://www.liferay.com/) applications using
Bazel.
"""

def _jar_impl(ctx):
  output_dir = ctx.outputs.output_dir
  
  # Run the OSGi bundle builder
  cmd = "%s -jar @osgi_bundle_builder" % (
    ctx.executable._java.path,
  )

  # Execute the command
  ctx.action(
    inputs = ctx.files.pubs + ctx.files._jdk + ctx.files._zip,
    output = [output_dir],
    mnemonic = "OSGiJar",
    progress_message = "Liferay build osgi jar ",
    command = "set -e\n" + cmd,
  )


_jar = rule(
    implementation = _jar_impl,
    attrs = {
        "bnd": attr.string(mandatory = True),
        "deps": attr.label_list(),
        "src": attr.string(mandatory = True)
    }
  )

def liferay_application(
    bnd="bnd.bnd",
    srcs=["src/main/java"],
    resources=["src/main/resources"],
    output=["src/main/resources"],
    deps=[]):

  all_deps = deps + [
    "//external:osgi_bundle_builder"
  ]
  
  _jar(
    bnd = bnd,
    deps = all_deps
  )


def liferay_repositories():
  native.maven_jar(
    name = "osgi_bundle_builder_artifact",
    artifact = "com.liferay:com.liferay.osgi.bundle.builder:1.0.0",
    sha1 = "90f37e8746616d0973b1bf6d29fbd460f3b613da",
  )

  native.bind(
    name = "osgi_bundle_builder",
    actual = "@osgi_bundle_builder_artifact//jar",
  )
