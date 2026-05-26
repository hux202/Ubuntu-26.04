FROM ubuntu:26.04

# Prevent interactive prompts during package setup
ENV DEBIAN_FRONTEND=noninteractive

# Update system and install XFCE desktop, VNC server, noVNC, and web tools
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    novnc \
    websockify \
    curl \
    git \
    && apt-get clean

# Set up the default VNC startup behavior
RUN mkdir -p /root/.vnc \
    && echo "#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nstartxfce4 &" > /root/.vnc/xstartup \
    && chmod +x /root/.vnc/xstartup

EXPOSE 7860

# Fire up the desktop engine and push the screen output over the web port
CMD vncserver :1 -geometry 1280x800 -depth 24 -SecurityTypes None && \
    /usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 7860
