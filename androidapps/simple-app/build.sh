ANDROID_JAR="/opt/android-sdk/platforms/android-33/android.jar"
aapt package -f -m \
    -J __build/gen \
    -S res \
    -M AndroidManifest.xml \
    -I $ANDROID_JAR 

javac \
    -classpath $ANDROID_JAR \
    -d "__build/obj" \
    "__build/gen/com/berstearns/handmade_simple_native_android/R.java" \
    java/com/berstearns/handmade_simple_native_android/MainActivity.java

# __build/obj/**/*.class 
d8 __build/obj/com/berstearns/handmade_simple_native_android/*.class \
    --output __build/apk/my_classes.jar \
    --no-desugaring
