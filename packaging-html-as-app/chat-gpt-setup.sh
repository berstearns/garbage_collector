#!/bin/bash

# Exit script on error
set -e

# Project configuration
PROJECT_NAME="ArtJourneyApp"
PACKAGE_NAME="com.example.artjourney"
MAIN_ACTIVITY="MainActivity"

echo "Setting up Android project: $PROJECT_NAME"

# Create project folder structure
mkdir -p $PROJECT_NAME/{app/src/{main/{assets,java,libs,res/layout},test},gradle/wrapper}
cd $PROJECT_NAME

# Create Gradle Wrapper files
cat > gradle/wrapper/gradle-wrapper.properties <<EOL
distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-bin.zip
EOL

# Create Gradle build scripts
cat > build.gradle <<EOL
// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath "com.android.tools.build:gradle:8.0.2"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
EOL

cat > app/build.gradle <<EOL
apply plugin: 'com.android.application'

android {
    compileSdkVersion 33
    defaultConfig {
        applicationId "$PACKAGE_NAME"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0"
    }
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    implementation 'com.google.android.material:material:1.8.0'
}
EOL

# Create settings.gradle
cat > settings.gradle <<EOL
rootProject.name = "$PROJECT_NAME"
include ':app'
EOL

# Create AndroidManifest.xml
mkdir -p app/src/main/java/com/example/artjourney
cat > app/src/main/AndroidManifest.xml <<EOL
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="$PACKAGE_NAME">

    <application
        android:label="Art Journey"
        android:theme="@style/Theme.AppCompat.Light.DarkActionBar">
        <activity android:name=".${MAIN_ACTIVITY}">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
EOL

# Create MainActivity Java file
cat > app/src/main/java/com/example/artjourney/${MAIN_ACTIVITY}.java <<EOL
package $PACKAGE_NAME;

import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import androidx.appcompat.app.AppCompatActivity;

public class ${MAIN_ACTIVITY} extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        WebView webView = findViewById(R.id.webView);

        // Enable JavaScript and settings
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setDomStorageEnabled(true);

        // Load the HTML file from assets
        webView.setWebViewClient(new WebViewClient());
        webView.loadUrl("file:///android_asset/art_journey.html");
    }
}
EOL

# Create XML Layout
cat > app/src/main/res/layout/activity_main.xml <<EOL
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <WebView
        android:id="@+id/webView"
        android:layout_width="match_parent"
        android:layout_height="match_parent" />
</RelativeLayout>
EOL

# Create art_journey.html in assets
cat > app/src/main/assets/art_journey.html <<EOL
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Art Journey</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/redux/4.1.1/redux.min.js"></script>
    <script src="https://unpkg.com/vis-network@9.1.2/dist/vis-network.min.js"></script>
    <link href="https://unpkg.com/vis-network@9.1.2/styles/vis-network.min.css" rel="stylesheet" />
</head>
<body class="bg-gray-100">
    <div id="app"></div>
    <script>
        // Your JavaScript here (as per the code you provided earlier)
    </script>
</body>
</html>
EOL

# Create proguard-rules.pro
cat > app/proguard-rules.pro <<EOL
# Proguard rules file
EOL

# Create compile script
cat > compile.sh <<'EOL'
#!/bin/bash
# Exit on error
set -e

# Clean previous builds
./gradlew clean

# Build APK
./gradlew assembleDebug

# Output path
echo "APK generated at:"
echo "$(pwd)/app/build/outputs/apk/debug/app-debug.apk"
EOL

chmod +x compile.sh

# Initialize Git and Gradle Wrapper
git init
gradle wrapper

echo "Setup complete. To compile the project, run:"
echo "  cd $PROJECT_NAME && ./compile.sh"
