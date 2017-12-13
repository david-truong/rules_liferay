# Copyright 2015 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Liferay Rules

Skylark rules for building [Liferay](http://www.liferay.com/) applications using
Bazel.
"""

def _jar_impl(ctx):
  output_file = ctx.outputs.liferay_jar

  all_deps = ''
  inputs = []

  for dep in ctx.files.deps:
      all_deps += dep.path + ","
      inputs.append(dep)

  
  args = ctx.actions.args()
  args.add("--classes-dir")
  args.add(ctx.file.classes.path)
  args.add("--classpath")
  args.add(all_deps)
  args.add("--bnd-file")
  args.add(ctx.file.bnd.path)
  args.add("--output")
  args.add(ctx.outputs.liferay_jar.path)
  args.add("jar")

  inputs.append(ctx.file.classes)
  inputs.append(ctx.file.bnd)

  # ctx.actions.run_shell(
  #   outputs = [output_file],
  #   command = "echo %s" % args
  # )

  #Execute the command
  ctx.actions.run(
    arguments = [args],
    executable = ctx.executable._obb,
    mnemonic = "LiferayJar",
    inputs = inputs,
    outputs = [output_file],
    progress_message = "Liferay is building an osgi jar ",
    use_default_shell_env = True,
  )


liferay_jar = rule(
    attrs = {
        "bnd": attr.label(allow_single_file = FileType([".bnd"])),
        "classes": attr.label(allow_single_file = FileType([".jar"])),
        "deps": attr.label_list(allow_files = FileType([".jar"])),
        "_obb": attr.label(
            default = Label("//liferay/tools:osgi_bundle_builder"),
            executable = True,
            cfg = "target",
        )

    },
    implementation = _jar_impl,
    outputs = {
        "liferay_jar": "%{name}-liferay.jar",
    },
  )

# def liferay_repositories():
#   native.maven_jar(
#     name = "osgi_bundle_builder_artifact",
#     artifact = "com.liferay:com.liferay.osgi.bundle.builder:1.0.0",
#     sha1 = "90f37e8746616d0973b1bf6d29fbd460f3b613da",
#   )

#   native.bind(
#     name = "osgi_bundle_builder",
#     actual = "@osgi_bundle_builder_artifact//jar",
#   )

# def liferay_jar(name, srcs, outs):
#   native.genrule(
#       name = name,
#       srcs = srcs,
#       outs = outs,
#       cmd = "$(JAVA) -classpath $< %s $< $@ > $@" % "com.liferay.osgi.bundle.builder.OSGiBundleBuilder"
#   )


