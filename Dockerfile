FROM arm32v7/ubuntu:23.10
MAINTAINER jjvdgeer <jjvdgeer@yahoo.com>

# Jenkins version
ENV JENKINS_VERSION 2.426.1

# Other env variables
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000

# Install dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends curl openjdk-11-jdk gnupg2 docker.io git subversion \
  && rm -rf /var/lib/apt/lists/*

# Good idea to switch back to the jenkins user.
#USER jenkins

# Get Jenkins
RUN curl -fL -o /opt/jenkins.war https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/{$JENKINS_VERSION}/jenkins-war-{$JENKINS_VERSION}.war

# Expose volume
VOLUME ${JENKINS_HOME}

# Working dir
WORKDIR ${JENKINS_HOME}

# Expose ports
EXPOSE 8080 ${JENKINS_SLAVE_AGENT_PORT}

# Start Jenkins
CMD ["sh", "-c", "java -jar /opt/jenkins.war"]
