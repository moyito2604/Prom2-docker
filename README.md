# Prom2-docker
A dockerfile used to build the Prominence II for use in containerized environments

To build the container and run it, use the following commands

To Build:
```
docker build -t imagename .
```
To Run:
```
docker run -p <port>:25565 -v '/path/to/files':'/data':'rw' imagename
```

A prebuilt container can be made and run using the following command
```
docker run -p <port>:25565 -v '/path/to/files':'/data':'rw' moyito2604/prom2-docker:latest
```

Default Java Arguments are set with minimum memory requirements of ```-Xms4096m -Xmx6144m```

To change these arguments and add more, add the following environment variable to the container before the image name
```
-e JAVA_ARGS="New Java Arguments"
```

Memory arguments can be set to either megabytes or gigabytes with ```-Xms4096m``` as Megabytes and ```-Xms4G``` as Gigabytes

RCON can be enabled as well by setting the following two arguments
```
-p <port>:25575 -e RCON_PASS="password"
```

The default password is ```changeme``` if it isn't changed in the argument

The client-side modpack can be found [here](https://www.curseforge.com/minecraft/modpacks/prominence-2-rpg)