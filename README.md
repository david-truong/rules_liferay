# Liferay Rules for Bazel

<div class="toc">
  <h2>Rules</h2>
  <ul>
    <li><a href="#liferay_module">liferay_module</a></li>
  </ul>
</div>

## Overview

These build rules are used for building [Liferay](http://www.liferay.com/)
modules and themes with Bazel. Modules are compiled as `.jar` files and themes are compiled as `.war` files.  They can contain Java/Javascript/CSS and other resources.

<a name="setup"></a>
## Setup

To be able to use the Liferay rules, you must provide bindings for the Liferay jars and
everything it depends on. The easiest way to do so is to add the following to
your `WORKSPACE` file, which will give you default versions for Liferay and each
dependency:

```python
http_archive(
  name = "com_liferay_rules_Liferay",
  url = "https://github.com/david-truong/rules_liferay/archive/0.0.1.tar.gz",
  sha256 = "9d467196576448a315110fe8eb5b04ed2aa5e2d67bc2f5822da1dbabb3a92e92",
  strip_prefix = "rules_liferay-0.0.1",
)
load("@com_liferay_rules_liferay//liferay:liferay.bzl", "liferay_repositories")
liferay_repositories()
```
