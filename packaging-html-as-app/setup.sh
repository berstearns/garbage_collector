#!/bin/bash

# Set the project name and directory
PROJECT_NAME="MyHTMLApp"
PROJECT_DIR="/path/to/$PROJECT_NAME"

# Create the project directory
mkdir -p "$PROJECT_DIR"

# Create the Android project directory structure
mkdir -p "$PROJECT_DIR/app"
mkdir -p "$PROJECT_DIR/app/src/main"
mkdir -p "$PROJECT_DIR/app/src/main/java"
mkdir -p "$PROJECT_DIR/app/src/main/res"
mkdir -p "$PROJECT_DIR/app/src/main/assets"

# Create the HTML, CSS, and JavaScript files
mkdir -p "$PROJECT_DIR/app/src/main/assets/html"
mkdir -p "$PROJECT_DIR/app/src/main/assets/css"
mkdir -p "$PROJECT_DIR/app/src/main/assets/js"

# Copy the HTML files
cp -r /path/to/html/files/*.html "$PROJECT_DIR/app/src/main/assets/html/"

# Copy the CSS files
cp -r /path/to/css/files/*.css "$PROJECT_DIR/app/src/main/assets/css/"

# Copy the JavaScript files
cp -r /path/to/js/files/*.js "$PROJECT_DIR/app/src/main/assets/js/"

# Create the AndroidManifest.xml file
echo "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\"
    package=\"com.example.$PROJECT_NAME\">
    <application
        android:icon=\"@mipmap/ic_launcher\"
        android:label=\"@string/app_name\">
        <activity
            android:name=\".MainActivity\"
            android:theme=\"@style/AppTheme\">
            <intent-filter>
                <action android:name=\"android.intent.action.MAIN\" />
                <category android:name=\"android.intent.category.LAUNCHER\" />
            </intent-filter>
        </activity>
    </application>
</manifest>" > "$PROJECT_DIR/app/src/main/AndroidManifest.xml"

# Create the MainActivity.java file
echo "package com.example.$PROJECT_NAME;

import android.os.Bundle;
import android.webkit.WebView;

public class MainActivity extends AppCompatActivity {
    private WebView webView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        webView = findViewById(R.id.webview);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.loadUrl(\"file:///android_asset/html/index.html\");
    }
}" > "$PROJECT_DIR/app/src/main/java/com/example/$PROJECT_NAME/MainActivity.java"

# Create the activity_main.xml file
echo "<LinearLayout xmlns:android=\"http://schemas.android.com/apk/res/android\"
    android:layout_width=\"match_parent\"
    android:layout_height=\"match_parent\"
    android:orientation=\"vertical\">
    <WebView
        android:id=\"@+id/webview\"
        android:layout_width=\"match_parent\"
        android:layout_height=\"match_parent\" />
</LinearLayout>" > "$PROJECT_DIR/app/src/main/res/layout/activity_main.xml"

# Create the styles.xml file
echo "<resources>
    <style name=\"AppTheme\" parent=\"Theme.AppCompat.Light.DarkActionBar\">
        <item name=\"colorPrimary\">#3F51B5</item>
        <item name=\"colorPrimaryDark\">#2E3F5F</item>
        <item name=\"colorAccent\">#FF4081</item>
    </style>
</resources>" > "$PROJECT_DIR/app/src/main/res/values/styles.xml"

# Create the strings.xml file
echo "<resources>
    <string name=\"app_name\">$PROJECT_NAME</string>
</resources>" > "$PROJECT_DIR/app/src/main/res/values/strings.xml"

# Create the ic_launcher.png file
echo "This is the app icon" > "$PROJECT_DIR/app/src/main/res/mipmap/ic_launcher.png"

# Build the project
cd "$PROJECT_DIR"
./gradlew assembleRelease

# Package the APK
cd "$PROJECT_DIR/app/build/outputs/apk/release"
zip -r "$PROJECT_NAME-release.apk" *

# Clean up
rm -rf "$PROJECT_DIR/app/build"
rm -rf "$PROJECT_DIR/app/src/main/res/mipmap/ic_launcher.png"
