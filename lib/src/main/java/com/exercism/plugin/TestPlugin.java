package com.exercism.plugin;

import org.gradle.api.Plugin;
import org.gradle.api.Project;

public class TestPlugin implements Plugin<Project> {
    @Override
    public void apply(Project project) {
        project.getExtensions().create("exercismSetting", TestPluginExtension.class);
        project.getTasks().create("exercism", TestTask.class);
    }
}
