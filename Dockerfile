FROM eclipse-temurin:17-jdk-jammy

# Adding Labels to identify repository for github
LABEL org.opencontainers.image.source=https://github.com/moyito2604/Prom2-docker
LABEL org.opencontainers.image.description="Containerized Version of Prominence 2 Modpack"

#Sets up the workspace
VOLUME ["/data"]
WORKDIR /

#Updates the container and installs dependencies
RUN apt update
RUN apt install -y zip unzip wget bash curl

#Exposes the port and copies scripts
EXPOSE 25565/tcp
EXPOSE 25575/tcp
COPY prep.sh .

#Sets default java arguments
ENV JAVA_ARGS="-Xms4096m -Xmx6144m"
ENV RCON_PASS="changeme"

#Sets permissions for scripts and runs prep.sh
RUN chmod +x prep.sh
CMD ["./prep.sh"]