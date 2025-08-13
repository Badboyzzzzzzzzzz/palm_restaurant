# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Prevent obfuscation of Flutter's PlatformChannel related classes
-keep class io.flutter.plugin.common.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }

# Keep HTTP/Retrofit classes
-keep class retrofit2.** { *; }
-keep class okhttp3.** { *; }
-dontwarn retrofit2.**
-dontwarn okhttp3.**
-keepclassmembers class * {
    @retrofit2.http.* <methods>;
}

# Keep your model classes - adjust the package name as needed
-keep class com.palm.restaurant.app.** { *; }

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Keep R class
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Keep serialization classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Additional rules for Flutter and Dart models
-keep class ** { *; }
-keepattributes *

# Provider and state management
-keep class ** extends java.lang.Object
-keep class ** implements java.io.Serializable

# Keep all JSON models and data classes
-keepclassmembers class ** {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Disable warnings for missing classes
-dontwarn javax.annotation.**
-dontwarn kotlin.Unit
-dontwarn kotlin.jvm.internal.**
