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

Skylark rules for building [Liferay](http://www.liferay.com/) applications
using Bazel.
"""


def _jar_impl(ctx):
    all_deps = ''

    for dep in ctx.files.deps:
        all_deps += dep.path + ","

    all_resources = ''

    for resource in ctx.files.resources:
        all_resources += resource.path + ","

    args = ctx.actions.args()
    args.add(all_resources)
    args.add(ctx.file._css_common)
    args.add(ctx.file.classes.path)
    args.add(all_deps)
    args.add(ctx.file.bnd.path)
    args.add(ctx.outputs.liferay_jar.path)

    ctx.actions.run(
        arguments=[args],
        executable=ctx.executable._osgi_bundle_builder,
        mnemonic="LiferayJar",
        inputs=ctx.files.deps + ctx.files.resources + [
            ctx.file.bnd, ctx.file.classes, ctx.file._css_common],
        outputs=[ctx.outputs.liferay_jar],
        progress_message="Liferay is building an osgi jar ",
        use_default_shell_env=True,
    )

    deps = []

    if java_common.provider in ctx.attr.classes:
        deps.append(ctx.attr.classes[java_common.provider])

    deps_provider = java_common.merge(deps)

    return struct(providers=[deps_provider])

_jar = rule(
    attrs={
        "bnd": attr.label(allow_single_file=FileType([".bnd"])),
        "classes": attr.label(allow_single_file=FileType([".jar"])),
        "deps": attr.label_list(allow_files=FileType([".jar"])),
        "resources": attr.label_list(allow_files=True),
        "_css_common": attr.label(
            single_file=True,
            default=Label("@css_common_artifact//jar"),
        ),
        "_osgi_bundle_builder": attr.label(
            default=Label("//liferay/tools:osgi_bundle_builder"),
            executable=True,
            cfg="target",
        )
    },
    implementation=_jar_impl,
    outputs={
        "liferay_jar": "%{name}.jar",
    },
  )


def liferay_application(name, srcs, resources=[], bnd="bnd.bnd", deps=[]):
    native.java_library(
        name=name + "-compiled",
        srcs=srcs,
        deps=deps,
    ) 

    _jar(
        name=name,
        bnd=bnd,
        resources=resources,
        classes=":" + name + "-compiled",
        deps=deps,
    )


def _liferay_theme_impl(ctx):
    all_srcs = ''

    for src in ctx.files.srcs:
        all_srcs += src.path + ","

    theme_builder_args = ctx.actions.args()
    theme_builder_args.add(all_srcs)
    theme_builder_args.add(ctx.attr.parent_name)
    theme_builder_args.add(ctx.file.parent_theme)
    theme_builder_args.add(ctx.file._unstyled_theme)
    theme_builder_args.add(ctx.file._css_common)
    theme_builder_args.add(ctx.outputs.liferay_theme.path)

    ctx.actions.run(
        arguments=[theme_builder_args],
        executable=ctx.executable._theme_builder,
        inputs=ctx.files.srcs + [ctx.file.parent_theme, ctx.file._unstyled_theme, ctx.file._css_common],
        mnemonic="BuildTheme",
        outputs=[ctx.outputs.liferay_theme],
        progress_message="Liferay is building your theme",
        use_default_shell_env=True,
    )

liferay_theme = rule(
    attrs={
        "parent_name": attr.string(default="_styled"),
        "parent_theme": attr.label(
            single_file=True,
            default=Label("@styled_theme_artifact//jar"),
        ),
        "srcs": attr.label_list(allow_files=True),
        "_css_common": attr.label(
            single_file=True,
            default=Label("@css_common_artifact//jar"),
        ),
        "_theme_builder": attr.label(
            default=Label("//liferay/tools:theme_builder"),
            executable=True,
            cfg="target",
        ),
        "_unstyled_theme": attr.label(
            single_file=True,
            default=Label("@unstyled_theme_artifact//jar"),
        ),
    },
    implementation=_liferay_theme_impl,
    outputs={
        "liferay_theme": "%{name}.war"
    },
  )


def liferay_repositories():
    native.maven_jar(
      name="css_builder_artifact",
      artifact="com.liferay:com.liferay.css.builder:2.1.0",
    )

    native.maven_jar(
      name="css_common_artifact",
      artifact="com.liferay:com.liferay.frontend.css.common:2.0.4",
    )

    native.maven_jar(
      name="osgi_bundle_builder_artifact",
      artifact="com.liferay:com.liferay.osgi.bundle.builder:2.0.0",
    )

    native.maven_jar(
      name="styled_theme_artifact",
      artifact="com.liferay:com.liferay.frontend.theme.styled:2.1.1",
    )

    native.maven_jar(
      name="theme_builder_artifact",
      artifact="com.liferay:com.liferay.portal.tools.theme.builder:1.1.4",
    )

    native.maven_jar(
      name="unstyled_theme_artifact",
      artifact="com.liferay:com.liferay.frontend.theme.unstyled:2.2.9",
    )
