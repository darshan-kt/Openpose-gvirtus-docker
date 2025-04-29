## Openpose-gvirtus-docker

### GVirtuS + OpenPose in Docker (with GUI Support)

This guide provides step-by-step instructions to set up a Dockerized environment for running OpenPose with GVirtuS, utilizing GPU acceleration and GUI output through X11 forwarding.

It is divided into two parts:

  1. Running OpenPose in Docker with real-time video streaming

  2. Using the GVirtuS simple application with OpenPose


## 1.Running OpenPose in Docker with real-time video streaming
### Docker Run Command
To launch the container with all required permissions and capabilities:
```bash
docker run -it --name openpose_gvirtus_env \
  --network=host \
  --privileged \
  --gpus all \
  --env DISPLAY=$DISPLAY \
  --env QT_X11_NO_MITSHM=1 \
  --volume /tmp/.X11-unix:/tmp/.X11-unix:rw \
  --volume /dev:/dev \
  openpose-gvirtus-image
```
    ✅ Important: -it
    ➤ Interactive terminal (run with keyboard input and output)
    
    --name openpose_gvirtus_env
    ➤ Sets the container name to openpose_gvirtus_env
    
    --network=host
    ➤ Shares the host's network (useful for streaming, real-time apps)
    
    --privileged
    ➤ Grants full device access (e.g., /dev, USB, webcam)
    
    --gpus all
    ➤ Enables access to all NVIDIA GPUs
    
    --env DISPLAY=$DISPLAY
    ➤ Allows GUI apps in the container to display on the host
    
    --env QT_X11_NO_MITSHM=1
    ➤ Prevents Qt GUI display issues with shared memory
    
    --volume /tmp/.X11-unix:/tmp/.X11-unix:rw
    ➤ Mounts X11 socket for GUI display forwarding
    
    --volume /dev:/dev
    ➤ Gives access to host hardware devices (e.g., camera, USB)
    
    openpose-gvirtus-image
    ➤ Docker image to run (replace with your actual image name)
    
### Enable GUI Access from Docker
To allow the Docker container to access your X server:
```bash
xhost +local:root
```
This grants GUI display access for the container to your host’s X server.

### Enter the Docker Container
Once the container is running:
```bash
docker exec -it openpose_gvirtus_env bash
```

### Running OpenPose on a Video
Before running OpenPose, disable MIT-SHM if using GUI in Docker:
```bash
export MIT_SHM_DISABLE=1
./build/examples/openpose/openpose.binS
```
[![Alt text]()](https://github.com/darshan-kt/Openpose-gvirtus-docker/blob/master/openpose_git.gif)

### Common Issue & Fix

If you encounter shared memory errors (MIT-SHM related), see this OpenPose GitHub issue for the solution:
📎 https://github.com/CMU-Perceptual-Computing-Lab/openpose/issues/2321


##  2. Using the GVirtuS simple application with OpenPose
Coming soon....
