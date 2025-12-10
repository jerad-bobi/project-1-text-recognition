FROM ubuntu:22.04

WORKDIR /app

# Install prerequisites (including git + Java for Gradle)
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa openjdk-11-jdk-headless ca-certificates

# Install Flutter (stable)
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Create non-root user and make /app writable
RUN useradd -m flutter && mkdir -p /app && chown -R flutter: /app

# Ensure Flutter SDK is writable by the non-root user
RUN chown -R flutter:flutter /usr/local/flutter

USER flutter
ENV HOME=/home/flutter
ENV PUB_CACHE=/home/flutter/.pub-cache
RUN mkdir -p /home/flutter/.pub-cache && chmod -R 700 /home/flutter/.pub-cache

# Copy pubspec files and get dependencies as non-root
COPY pubspec.yaml pubspec.lock ./
RUN flutter --version
RUN flutter pub get

# Copy project
COPY --chown=flutter:flutter . .

# Run tests only if test directory exists
RUN if [ -d "test" ]; then flutter test; else echo "no tests to run"; fi

# Build APK/AppBundle (ensure Android SDK setup if you need these in CI)
# RUN flutter build apk --release --split-per-abi
# RUN flutter build appbundle --release

# Collect outputs
RUN mkdir -p /app/build/outputs || true
RUN cp build/app/outputs/apk/release/*.apk /app/build/outputs/ || true
RUN cp build/app/outputs/bundle/release/*.aab /app/build/outputs/ || true

ENTRYPOINT ["flutter"]
CMD ["--version"]
