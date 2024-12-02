#include <jni.h>
#include <stdlib.h>

extern "C" {
JNIEXPORT jint JNICALL 
Java_com_berstearns_handmade_1simple_1native_1android_MainActivity_getData(JNIEnv *env, jobject obj)
{
    int result = rand();
    return result;
}
}
