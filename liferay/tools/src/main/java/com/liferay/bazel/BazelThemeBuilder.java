package com.liferay.bazel;

import com.liferay.css.builder.CSSBuilder;
import com.liferay.css.builder.CSSBuilderArgs;
import com.liferay.portal.tools.theme.builder.ThemeBuilder;
import com.liferay.portal.tools.theme.builder.ThemeBuilderArgs;

import java.io.*;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.FileTime;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class BazelThemeBuilder {
    public static void main(String[] args) throws Exception {
        Path tempFolder = Files.createTempDirectory("bazel-theme-builder");
        File tempDir = tempFolder.toFile();

        String srcs = args[0];
        String parentName = args[1];
        String parentPath = args[2];
        String unstyledPath = args[3];
        String cssCommonPath = args[4];
        String outputFileName = args[5];

        File diffsDir = _getDiffs(srcs);
        File outputFile = new File(outputFileName);

        ThemeBuilderArgs themeBuilderArgs = new ThemeBuilderArgs();

        themeBuilderArgs.setDiffsDir(diffsDir);
        themeBuilderArgs.setOutputDir(tempDir);
        themeBuilderArgs.setParentName(parentName);
        themeBuilderArgs.setParentDir(new File(parentPath));
        themeBuilderArgs.setUnstyledDir(new File(unstyledPath));

        ThemeBuilder themeBuilder = new ThemeBuilder(themeBuilderArgs);

        themeBuilder.build();

        CSSBuilderArgs cssBuilderArgs = new CSSBuilderArgs();

        cssBuilderArgs.setBaseDir(tempDir);
        cssBuilderArgs.setImportDir(new File(cssCommonPath));
        cssBuilderArgs.setOutputDirName("./");
        cssBuilderArgs.setPrecision(5);

        CSSBuilder cssBuilder = new CSSBuilder(cssBuilderArgs);

        cssBuilder.execute();

        _writeOutputFile(tempDir, outputFile);
    }

    private static File _getDiffs(String sourceFiles) throws Exception {
        if (sourceFiles == null || sourceFiles.equals("")) {
            throw new FileNotFoundException();
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

    private static void _writeOutputFile(File inputDir, File outputFile)
        throws IOException {

        Path outputPath = Files.createFile(outputFile.toPath());

        try (ZipOutputStream zipOutputStream = new ZipOutputStream(
                Files.newOutputStream(outputPath))) {

            Path inputPath = inputDir.toPath();

            Files.walk(inputPath)
                .filter(path -> !Files.isDirectory(path))
                .forEach(path -> {
                    Path relativePath = inputPath.relativize(path);

                    ZipEntry zipEntry =
                            new ZipEntry(relativePath.toString());
                    try {
                        zipOutputStream.putNextEntry(zipEntry);

                        Files.copy(path, zipOutputStream);

                        zipOutputStream.closeEntry();
                    }
                    catch (IOException e) {
                        System.err.println(e);
                    }
                });
        }
    }


}
