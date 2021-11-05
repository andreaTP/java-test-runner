# === Build builder image ===

FROM gradle:6.8.3-jdk11 AS build
# Use bash by default
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

WORKDIR /home/builder

# Prepare required project files
COPY lib/src ./src
COPY lib/build.gradle ./

# Install GraalVM
RUN apt-get update -y && apt-get install -y build-essential libz-dev zlib1g-dev
COPY scripts/downloadGraalVM.sh ./
RUN ./downloadGraalVM.sh
ENV GRAALVM_HOME="/home/builder/graalvm"
ENV JAVA_HOME="/home/builder/graalvm"
ENV PATH="$GRAALVM_HOME/bin:$PATH"
RUN gu install native-image

# Build test runner
RUN gradle -i clean build
RUN gradle -i nativeCompile \
    && cp build/native/nativeCompile/autotest-runner .

# Ensure exercise dependencies are downloaded
WORKDIR /opt/exercise
COPY exercise .
RUN gradle build

# === Build runtime image ===

FROM gradle:6.8.3-jdk11
WORKDIR /opt/test-runner

# Copy binary and launcher script
COPY bin/ ./bin/
COPY --from=build /home/builder/autotest-runner ./

# Copy cached dependencies
COPY --from=build /home/gradle /home/gradle

ENTRYPOINT ["sh", "/opt/test-runner/bin/run.sh"]
