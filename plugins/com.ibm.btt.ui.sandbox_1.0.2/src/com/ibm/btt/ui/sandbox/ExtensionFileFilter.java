package com.ibm.btt.ui.sandbox;
import java.io.*;

public class ExtensionFileFilter implements FileFilter {

    private String extension1;
    private String extension2;

    public ExtensionFileFilter(String extension1,String extension2) {
        this.extension1 = extension1;
        this.extension2 = extension2;
    }

    public boolean accept(File file) {
        if(file.isDirectory()) {
            return false;
        }

        String name = file.getName();
        // find the last
        int index = name.lastIndexOf(".");
        if(index == -1) {
            return false;
        } else
        if(index == name.length()- 1) {
            return false;
        } else {
            return (this.extension1.equals(name.substring(index+1)) || this.extension2.equals(name.substring(index+1)));
        }
    }
} 

