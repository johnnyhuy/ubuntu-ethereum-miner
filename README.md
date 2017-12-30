# Welcome!
The following steps will guide you to setup an Ubuntu operating system. This will have portability mind to run the operating system on a **USB** with a **wifi** connection.

## Features

I have tried my best to keep things as simple as possible with only the most useful packages installed on top of the base operating system. Downloads/Documentation are provided in the list below.

- Ubuntu 16.04.3 LTS [Download page](https://www.ubuntu.com/download/desktop)
- Claymore's Dual Miner [Thread post](https://bitcointalk.org/index.php?topic=1433925.0)
- Ethminer [Git](https://github.com/ethereum-mining/ethminer)
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

*** Step 2: Update & upgrade packages***

Keep the system up to date by running the following commands:

```shell
sudo apt-get update
sudo apt-get upgrade -y
```

*** Step 3: Prepare for Nvidia CUDA toolkit & driver installation***

Disable nouveau by adding a configuration at `/etc/modprobe.d/blacklist-nouveau.conf`:

```shell
blacklist nouveau
options nouveau modeset=0
```

Once you have added configuration file **reboot** the system. 

*** Step 4: Install Nvidia Drivers & Nvidia CUDA***

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

## Troubleshooting

***Wifi is not connecting at login***

Allow the network to be connected by all users. The UI method will need you to go your Network Manager and edit the connection to enable all users to connect to the network.

[More info](https://askubuntu.com/questions/16376/connect-to-network-before-user-login)
