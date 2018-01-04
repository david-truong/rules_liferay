# Liferay Rules for Bazel

<div class="toc">
  <h2>Rules</h2>
  <ul>
    <li><a href="#liferayaapplicaation">liferay_application</a></li>
    <li><a href="#liferay_theme">liferay_theme</a></li>
  </ul>
</div>

## Overview

These build rules are used for building [Liferay](http://www.liferay.com/)
modules and themes with Bazel. Modules are compiled as `.jar` files and themes 
are compiled as `.war` files.  They can contain Java/Javascript/CSS and other 
resources.  Sass files will automatically be compiled into css files.

<a name="liferay_application"></a>
## liferay_application

```python
liferay_application(name, srcs, resources, bnd, deps)
```

`liferay_application` generates a Liferay osgi module. It may depend on 
`java_library` rules.  You may include sass files in your resources and they 
will automatically be compiled into css files.

<table class="table table-condensed table-bordered table-params">
  <colgroup>
    <col class="col-param" />
    <col class="param-description" />
  </colgroup>
  <thead>
    <tr>
      <th colspan="2">Attributes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>name</code></td>
      <td>
        <p><code>Name, required</code></p>
        <p>A unique name for this target</p>
      </td>
    </tr>
      <td><code>srcs</code></td>
      <td>
        <p><code>List of labels, required</code></p>
        <p>List of Java <code>.java</code> source files used to build the
        application</p>
      </td>
    </tr>
    <tr>
      <td><code>resources</code></td>
      <td>
        <p><code>List of labels, optional</code></p>
        <p>A list of data files to be included in the JAR.</p>
      </td>
    </tr>
    <tr>
      <td><code>bnd</code></td>
      <td>
        <p><code>Label, optional (default "bnd.bnd")</code></p>
        <p>Label for bnd file build this application</p>
      </td>
    </tr>
    <tr>
      <td><code>deps</code></td>
      <td>
        <p><code>List of labels, optional</code></p>
        <p>List of other libraries to linked to this application</p>
      </td>
    </tr>
  </tbody>
</table>

<a name="liferay_theme"></a>
## liferay_theme

```python
liferay_theme(name, srcs, parent_name, parent_theme)
```

`liferay_theme` generates a Liferay theme. You may include sass files in your sources and they 
will automatically be compiled into css files.

<table class="table table-condensed table-bordered table-params">
  <colgroup>
    <col class="col-param" />
    <col class="param-description" />
  </colgroup>
  <thead>
    <tr>
      <th colspan="2">Attributes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>name</code></td>
      <td>
        <p><code>Name, required</code></p>
        <p>A unique name for this target</p>
      </td>
    </tr>
      <td><code>srcs</code></td>
      <td>
        <p><code>List of labels, required</code></p>
        <p>List of source files used to build the application</p>
      </td>
    </tr>
    <tr>
      <td><code>parent_name</code></td>
      <td>
        <p><code>String, optional (default "_styled")</code></p>
        <p>Name of the parent theme.</p>
      </td>
    </tr>
    <tr>
      <td><code>parent_theme</code></td>
      <td>
        <p><code>Label, optional (default "//third_party:styled_theme_artifact")</code></p>
        <p>The parent theme source files.</p>
      </td>
    </tr>
    </tbody>
</table>

