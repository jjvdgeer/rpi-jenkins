FROM arm32v7/ubuntu:latest
MAINTAINER jjvdgeer <jjvdgeer@yahoo.com>

# Jenkins version
ENV JENKINS_VERSION 2.249.1

# dotnet core download URL
ENV DOTNETCORE_URL https://download.visualstudio.microsoft.com/download/pr/8f0dffe3-18f0-4d32-beb0-dbcb9a0d91a1/abe9a34e3f8916478f0bd80402b01b38/dotnet-sdk-3.1.402-linux-arm.tar.gz

# Other env variables
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000

# Enable cross build
#RUN ["cross-build-start"]

# Install dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends curl openjdk-8-jdk gnupg2 \
  && rm -rf /var/lib/apt/lists/*

# Install dotnet
# Switch to root to install .NET Core SDK
#USER root

# Just for my sanity... Show me this distro information!
RUN uname -a && cat /etc/*release

# Based on instructiions at https://docs.microsoft.com/en-us/dotnet/core/linux-prerequisites?tabs=netcore2x
# Install depency for dotnet core 3.1.
RUN downloadname="$(basename ${DOTNETCORE_URL})" \
  && curl ${DOTNETCORE_URL} --output ${downloadname} \
  && mkdir -p $HOME/dotnet && tar zxf ${downloadname} -C $HOME/dotnet \
  && export DOTNET_ROOT=$HOME/dotnet \
  && export PATH=$PATH:$HOME/dotnet \
  && dotnet --version \
  && rm ${downloadname}

# Good idea to switch back to the jenkins user.
#USER jenkins

# Get Jenkins
RUN curl -fL -o /opt/jenkins.war https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/{$JENKINS_VERSION}/jenkins-war-{$JENKINS_VERSION}.war

# Disable cross build
#RUN ["cross-build-end"]

# Expose volume
VOLUME ${JENKINS_HOME}

# Working dir
WORKDIR ${JENKINS_HOME}

# Expose ports
EXPOSE 8080 ${JENKINS_SLAVE_AGENT_PORT}

# Start Jenkins
CMD ["sh", "-c", "java -jar /opt/jenkins.war"]
