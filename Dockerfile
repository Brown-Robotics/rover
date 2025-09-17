# ROS 2 base image
FROM ros:jazzy-perception-noble

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    python-is-python3 \
    python3-argcomplete \
    python3-venv \
    python3-serial \
    ros-dev-tools \
    ros-${ROS_DISTRO}-teleop-twist-joy \
    raspi-config \
    usbutils \
    && rm -rf /var/lib/apt/lists/*

# Set up workspace
WORKDIR /osr_ws/src

# Clone rover code
COPY . osr-rover-code

# https://github.com/nasa-jpl/osr-rover-code/blob/master/setup/rpi.md#clone-and-build-the-rover-code
WORKDIR /osr_ws
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    python3 -m venv venv --system-site-packages && \
    . ./venv/bin/activate && \
    touch ./venv/COLCON_IGNORE && \
    rosdep install --from-paths src --ignore-src --rosdistro=$ROS_DISTRO -y && \
    python3 -m pip install adafruit-circuitpython-servokit ina260 RPi.GPIO smbus && \
    python3 -m colcon build --symlink-install

# Customizable settings
WORKDIR /osr_ws/src/osr-rover-code/ROS/osr_bringup/config
RUN touch osr_params_mod.yaml roboclaw_params_mod.yaml

# ROS config scripts
RUN echo ". /osr_ws/venv/bin/activate" >> ~/.bashrc && \
    echo ". /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc && \
    echo ". /osr_ws/install/setup.bash" >> ~/.bashrc

WORKDIR /osr_ws/src/osr-rover-code