package com.exercism.plugin;

import com.exercism.runner.TestRunner;
import org.gradle.api.DefaultTask;
import org.gradle.api.tasks.TaskAction;

public class TestTask extends DefaultTask {
    @TaskAction
    public void greet() throws Exception {
        TestPluginExtension extension = getProject().getExtensions().findByType(TestPluginExtension.class);
        if (extension == null) {
            extension = new TestPluginExtension();
        }

        String[] args = { "0" };
        TestRunner.main(args);
    }
}
