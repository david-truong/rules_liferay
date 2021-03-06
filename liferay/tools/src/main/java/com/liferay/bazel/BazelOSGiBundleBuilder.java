package com.liferay.bazel;

import com.liferay.css.builder.CSSBuilder;
import com.liferay.css.builder.CSSBuilderArgs;
import com.liferay.osgi.bundle.builder.OSGiBundleBuilderArgs;
import com.liferay.osgi.bundle.builder.commands.JarCommand;

import java.io.File;
import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class BazelOSGiBundleBuilder {
    public static void main(String[] args) throws Exception {
        String resources = args[0];
        String cssCommonPath = args[1];

        File baseDir = _getBaseDir(resources);

        if (baseDir != null) {
            CSSBuilderArgs cssBuilderArgs = new CSSBuilderArgs();

            cssBuilderArgs.setBaseDir(baseDir.getCanonicalFile());
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

        File bndFile = new File(bndPath);

        osgiBundleBuilderArgs.setBaseDir(bndFile.getParentFile());
        osgiBundleBuilderArgs.setClassesDir(new File(classesLib));
        osgiBundleBuilderArgs.setClasspath(_getClasspath(classpath.split(",")));
        osgiBundleBuilderArgs.setBndFile(bndFile);
        osgiBundleBuilderArgs.setOutputFile(outputFile);

        if (baseDir != null) {
            File resourcesDir = new File(baseDir, "main/resources");

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

        Path basePath = Paths.get(fileNames[0]);

        while (!basePath.endsWith("src")) {
            basePath = basePath.getParent();
        }

        return basePath.toFile();
    }

    private static List<File> _getClasspath(String[] fileNames) {
        Stream<String> stream = Stream.of(fileNames);

        return stream.map(
            fileName -> Paths.get(fileName)
        ).map(
            path -> path.toFile()
        ).collect(Collectors.toList());
    }

    private static void copyDirectory(final Path source, final Path target)
            throws IOException {

        Files.walkFileTree(
            source,
            new SimpleFileVisitor<Path>() {
                @Override
                public FileVisitResult visitFile(
                        Path path, BasicFileAttributes attrs)
                    throws IOException {

                    if (attrs.isDirectory()) {
                        return FileVisitResult.CONTINUE;
                    }

                    Path newPath = target.resolve(source.relativize(path));

                    Files.createDirectories(newPath.getParent());

                    Files.copy(
                        path, newPath, StandardCopyOption.REPLACE_EXISTING);

                    return FileVisitResult.CONTINUE;
                }
            });
    }
}
