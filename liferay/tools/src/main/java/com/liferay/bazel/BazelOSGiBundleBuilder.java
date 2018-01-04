package com.liferay.bazel;

import com.liferay.css.builder.CSSBuilder;
import com.liferay.css.builder.CSSBuilderArgs;
import com.liferay.osgi.bundle.builder.OSGiBundleBuilderArgs;
import com.liferay.osgi.bundle.builder.commands.JarCommand;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class BazelOSGiBundleBuilder {
    public static void main(String[] args) throws Exception {
        String resources = args[0];
        String cssCommonPath = args[1];

        File resourcesDir = _getBaseDir(resources);

        if (resourcesDir != null) {
            CSSBuilderArgs cssBuilderArgs = new CSSBuilderArgs();

            cssBuilderArgs.setBaseDir(resourcesDir.getCanonicalFile());
            cssBuilderArgs.setImportDir(new File(cssCommonPath));
            cssBuilderArgs.setOutputDirName("./");

            CSSBuilder cssBuilder = new CSSBuilder(cssBuilderArgs);

            cssBuilder.execute();
        }

        String classesLib = args[2];
        String classpath = args[3];
        String bndPath = args[4];
        String outputFileName = args[5];

        File outputFile = new File(outputFileName);

        OSGiBundleBuilderArgs osgiBundleBuilderArgs =
            new OSGiBundleBuilderArgs();

        osgiBundleBuilderArgs.setClassesDir(new File(classesLib));
        osgiBundleBuilderArgs.setClasspath(_getClasspath(classpath.split(",")));
        osgiBundleBuilderArgs.setBndFile(new File(bndPath));
        osgiBundleBuilderArgs.setOutput(outputFile);

        if (resourcesDir != null) {
            osgiBundleBuilderArgs.setResourcesDir(resourcesDir);
        }

        JarCommand jarCommand = new JarCommand();

        jarCommand.build(osgiBundleBuilderArgs);
    }

    private static File _getBaseDir(String sourceFiles) throws Exception {
        if (sourceFiles == null || sourceFiles.equals("")) {
            return null;
        }

        String[] fileNames = sourceFiles.split(",");

        Path diffsPath = null;

        for (String fileName : fileNames) {

            Path path = Paths.get(fileName);

            Path parentPath = path.getParent();

            if (diffsPath == null) {
                diffsPath = parentPath;
            }
            else {
                while(!parentPath.startsWith(diffsPath)) {
                    diffsPath = diffsPath.getParent();
                }
            }
        }

        return diffsPath.toFile();
    }

    private static List<File> _getClasspath(String[] fileNames) {
        Stream<String> stream = Stream.of(fileNames);

        return stream.map(
            fileName -> Paths.get(fileName)
        ).map(
            path -> path.toFile()
        ).collect(Collectors.toList());
    }
}
