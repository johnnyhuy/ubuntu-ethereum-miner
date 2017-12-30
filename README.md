# Welcome!
The following steps will guide you to setup an Ubuntu operating system. This will have portability mind to run the operating system on a **USB** with a **wifi** connection.

## Features

I have tried my best to keep things as simple as possible with only the most useful packages installed on top of the base operating system. Downloads/Documentation are provided in the list below.

- Ubuntu 16.04.3 LTS [Download page](https://www.ubuntu.com/download/desktop)
- Claymore's Dual Miner [Thread post](https://bitcointalk.org/index.php?topic=1433925.0)
- Screen [Documentation](https://help.ubuntu.com/community/Screen)
- OpenSSHServer [Documentation](https://help.ubuntu.com/lts/serverguide/openssh-server.html)
- Nvidia CUDA & Nvidia Video Driver [Download](https://developer.nvidia.com/cuda-downloads?target_os=Linux)
- Vim (optional)

## Tested Environment

I have tested this build on my evironment with the following hardware setup:

- ASRock AB350 Pro4
- Ryzen 3 1200
- GTX 1060 6GB
- TP-Link USB Wireless Network Adapter

I will not be using direct ethernet since I will be using a **wifi** connection.

## Installation

### Step 1: Install the operating system

Installing the operation is as simple as booting to an Ubuntu installed USB and selecting **another device** to install Ubuntu. 

You can use anything from a flash USB to an internal hard drive. In my case, I have used an **external USB 3.0 hard drive** to install the operating system for better W/R speed compared to flash USB.

### Step 2: Update & upgrade packages

Keep the system up to date by running the following commands:

```shell
sudo apt-get update
sudo apt-get upgrade -y
```

### Step 3: Install other packages

Theses packages allow features such as SSH remote or viewing multiple terminals in one terminal.

***Screen - access multiple separate terminal sessions inside a single terminal window or remote terminal session***

```shell
sudo apt-get install screen -y
```

***Open SSH Server - remote SSH into system***

```shell
sudo apt-get install openssh-server -y
```

***Vim (optional) - a powerful terminal text editor***

```shell
sudo apt-get install openssh-server -y
```

### Step 4: Prepare for Nvidia CUDA toolkit & driver installation

Disable nouveau by adding a configuration at `/etc/modprobe.d/blacklist-nouveau.conf`:

```shell
blacklist nouveau
options nouveau modeset=0
```

Once you have added configuration file **reboot** the system. 

### Step 5: Install Nvidia Drivers & Nvidia CUDA

The Linux Nvidia CUDA downloaded `.run` file is packaged with a Nvidia Driver ready for installation with Nvidia CUDA.

Change directory to the location of the `.run` downloaded from the [Nvidia download page](https://developer.nvidia.com/cuda-downloads?target_os=Linux). Run the script as **root user** (replace the Xs with the relevant `.run` file name):

```shell
sudo sh cuda_X.X.XX_XXX.XX_linux.run --override
```

This is a brief example of what should be inputted into the prompts to successfully install the Nvidia CUDA Toolkit and Nvidia Driver.

- Accept EULA after reading: **accept**
- Install NVIDIA Accelerated Graphics Driver? **yes**
- Do you want to install the OpenGL libraries? **yes (press enter for default)**
- Do you want to run nvidia-xconfig? **no (press enter for default)**
- Install the CUDA 9.1 Toolkit? **yes**
- Enter Toolkit Location: /usr/local/cuda-X.X **(press enter for default)**
- Do you want to install a symbolic link at /usr/local/cuda? **yes**
- Install the CUDA 9.1 Samples? **no**

### Step 6: Install & Run Claymore's Dual Miner

**Download** Claymore's Dual Miner from the thread post referenced in the **features** section. 

**Extract** the downloaded contents to a desired location on the system. In my case, I have extracted the files at `~/claymore` or `/home/[USER]/claymore`

I will be using **Nanopool** as an example mining pool so the pool and wallet address may vary depending on the pool. Create a script to **run** the miner:

```shell
#!/bin/bash
~/claymore/ethdcrminer64 -epool [POOL] -ewal [ETH WALLET ADDR].[WORKER NAME]/[EMAIL] -epsw x -mode 1 -ftime 10
```

I have named the script `miner.sh` at `~/` for later use with crontab jobs.

### Step 7: Launch Miner at Boot

To edit crontab jobs run the following command:

```shell
crontab -e
```

Add the following command to run the miner:

```shell
@reboot sleep 3 && screen -dmS claymore sh ~/miner.sh
```

## Overclocking

Once you have installed Nvidia CUDA toolkit & drivers, you can check GPU devices with the following command:

```shell
nvidia-smi
```

To view the status of GPU devices on a user interface run the following command:

```shell
nvidia-settings
```

### Step 1: Unlock Nvidia GPU overclocking

Nvidia disallows GPU overclocking by default so there requires a command to run to unlock overclocking.

```shell
sudo nvidia-xconfig -a --cool-bits=28 --allow-empty-initial-configuration
```

Make sure you **reboot** after running the command to commit changes to `/etc/X11/xorg.conf`, which the command has modified.

### Step 2: Create overclock script

Nvidia overclock **settings do not save upon reboot**, therefore a script must be created to configure the overclock on boot.

```shell
#!/bin/bash

export DISPLAY=0
export XAUTHORITY=/var/run/lightdm/root/:0

# Since all my cards are the same, I'm happy with using the same Memory Transfer Rate Offset
memoryOffset="300"

# Enable nvidia-smi settings so they are persistent the whole time the system is on.
nvidia-smi -pm 1

# Set the power limit for each card (note this value is in watts, not percent!
nvidia-smi -i 0,1 -pl 53

## Apply overclocking settings to each GPU
nvidia-settings -a [gpu:0]/GpuPowerMizerMode=1
nvidia-settings -a [gpu:0]/GPUMemoryTransferRateOffset[2]=$memoryOffset
nvidia-settings -a [gpu:1]/GpuPowerMizerMode=1
nvidia-settings -a [gpu:1]/GPUMemoryTransferRateOffset[2]=$memoryOffset
```

The example script above shows a 2 GPU setup where **0 and 1 are GPU index numbers**. More can be added as long as `/etc/X11/xorg.conf` is updated by running the command from step: 1 upload Nvidia overclocking.

### Step 3: Launch Overclock Settings at Boot

Make sure you execute the `crontab -e` as root with `sudo` since overclock settings can only be changed under root. To edit crontab jobs run the following command:

```shell
sudo crontab -e
```

Add 30 second delay to script in case overclock settings is unstable. Add the following command to run the overclock script:

```shell
@reboot sleep 30 && sh ~/overclock.sh
```

## Troubleshooting

Here are some solutions to some issues/gotchas that may occur when setting up the system.

### How do I see if screen terminal is running

Run the following command to view all screen instances:

```shell
screen -ls
```

### How do I view a screen instance

To access a terminal instance from screen, run the following command:

```shell
screen -x [SCREEN NAME]
```

Replace square brackets with relevant information.

To exit out of an instance press `CTRL+A+D` to exit without closing the terminal instance.

### Wifi is not connecting at login

Allow the network to be connected by all users. The UI method will need you to go your Network Manager and edit the connection to enable all users to connect to the network.

[More info](https://askubuntu.com/questions/16376/connect-to-network-before-user-login)

### Failed to connect to Mir on GPU overclock

Add the following enviroment variables in your overclock script to fix the issue:

```shell
export DISPLAY=0
export XAUTHORITY=/var/run/lightdm/root/:0
```

## Sources

Majority of the information I have found are referenced below:

- [Overclocking Nvidia GPUs on Ubuntu](https://noobminer.xyz/overclocking-multiple-nvidia-graphics-card-linux/)
- [How to install Nvidia CUDA](https://askubuntu.com/questions/799184/how-can-i-install-cuda-on-ubuntu-16-04)
- [Cannot run nvidia-settings](https://askubuntu.com/questions/925368/cannot-run-nvidia-settings/937204)
