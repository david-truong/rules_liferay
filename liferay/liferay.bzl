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

  ctx.actions.run(
    arguments = [args],
    executable = ctx.executable._obb,
    mnemonic = "LiferayJar",
    inputs = inputs,
    outputs = [ctx.outputs.liferay_jar],
    progress_message = "Liferay is building an osgi jar ",
    use_default_shell_env = True,
  )

  deps =[]

  if java_common.provider in ctx.attr.classes:
    deps.append(ctx.attr.classes[java_common.provider])

  deps_provider = java_common.merge(deps)

  return struct(providers = [deps_provider])

_jar = rule(
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

def liferay_application(name, srcs, resources = [], bnd = "bnd.bnd", deps = []):
  native.java_library(
    name = name + "-compiled",
    srcs = srcs,
    resources = resources,
    deps = deps,
  ) 

  _jar(
    name = name,
    bnd = bnd,
    classes = ":" + name + "-compiled",
    deps = deps,
  )


SASS_FILETYPES = FileType([
    ".sass",
    ".scss",
])

def collect_transitive_sources(ctx):
    source_files = depset(order="postorder")

    for dep in ctx.attr.deps:
        source_files += dep.transitive_sass_files
    
    return source_files

def _sass_library_impl(ctx):
    transitive_sources = collect_transitive_sources(ctx)
    transitive_sources += SASS_FILETYPES.filter(ctx.files.srcs)

    return struct(
        files = depset(),
        transitive_sass_files = transitive_sources)

def _sass_binary_impl(ctx):
    css_filename = ctx.file.src.basename[:-len(ctx.file.src.extension)]

    css_file = ctx.actions.declare_file(css_filename + "css", sibling = ctx.file.src)

    css_map_file = ctx.actions.declare_file(css_file.basename + ".map", sibling = ctx.file.src)

    sass_compiler = ctx.executable._sass_compiler
    
    options = [
        "--file",
        ctx.file.src.path,
        "--sourcemap",
        "--output",
        css_file.path,
        "--sourcemap-output",
        css_map_file.path,
    ]

    transitive_sources = collect_transitive_sources(ctx)

    imports = ""

    for src in transitive_sources:
      imports += src.path[:-len(src.basename)] + ":"

    options += ["--include-dir", imports]

    ctx.actions.run(
        inputs = [ctx.file.src] + list(transitive_sources),
        executable = sass_compiler,
        arguments = options,
        mnemonic = "SassCompiler",
        outputs = [css_file, css_map_file],
    )

    return DefaultInfo(files=depset([css_file, css_map_file]))

sass_deps_attr = attr.label_list(
    providers = ["transitive_sass_files"],
    allow_files = False,
)

sass_library = rule(
    attrs = {
        "srcs": attr.label_list(
            allow_files = SASS_FILETYPES,
            non_empty = True,
            mandatory = True,
        ),
        "deps": sass_deps_attr,
    },
    implementation = _sass_library_impl,
)

sass_binary = rule(
    attrs = {
        "src": attr.label(
            allow_files = SASS_FILETYPES,
            mandatory = True,
            single_file = True,
        ),
        "deps": sass_deps_attr,
        "_sass_compiler": attr.label(
            default = Label("//liferay/tools:sass_compiler"),
            executable = True,
            cfg = "host",
        ),
    },
    implementation = _sass_binary_impl,
)