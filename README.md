# Welcome!
The following steps will guide you to setup an Ubuntu operating system. This will have portability mind to run the operating system on a **USB** with a **wifi** connection.

## Disclaimers

I am not the creator of Claymore's Miner (miner zip stored in /miner/*.gz).

This is an installation guide to install an Nvidia miner and I will not be responsible/liable for any damages once in use.

## Automated Installation

This script requires **root** to update/create files and configure Nvidia drivers. This method also assumes that you have a **fresh** installation of Ubuntu LTS.

1. Gain access to your Ubuntu instance

    Be sure to have the following prerequisites:

    - Git installed
    - An Internet connection on the device

2. Get this Git repository

    ```shell
    cd ~ && git clone --depth=1 https://github.com/johnnyhuy/ubuntu-ethereum-miner.git ~/miner-installer
    ```

3. Run the install bash script and follow the prompts

    ```shell
    cd ~/miner-installer/scripts && sudo bash ./install.sh
    ```

4. Edit miner settings at `~/miner.sh`

5. Unlock overclocking on Nvida drivers by running the following script **after reboot**.

    ```shell
    cd ~/miner-installer/scripts && sudo bash ./nvidia_unlock_overclock.sh
    ```

## Manual Installation

Follow the manual method of installing the miner at `MANUAL_INSTALL.md` in this repository.

## Troubleshooting

Here are some solutions to some issues/gotchas that may occur when setting up the system.

### I cannot set my overclock settings to new GPUs installed

You will need to run the Nvidia overclock unlock command again to detect new devices. Thankfully I've created that script here:

```shell
cd ~/miner-installer/scripts && sudo bash ./nvidia_unlock_overclock.sh
```

### Reset files from installation script

If you need a clean installation of files from the installation script, run the following command:

```shell
cd ~ && sudo bash ./miner-installer/scripts/reset.sh
```

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

When there is no Xorg server attached to the devices the following error appears when running `nvidia-settings` commands.

```shell
Failed to connect to Mir: Failed to connect to server socket: No such file or directory.
```

Make sure the Grub configuration is not set to `runlevel 3` (text mode). To see if Xorg is running on GPUs, run `nvidia-smi` and under each GPU there should be a process called `/usr/lib/xorg/Xorg`.

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
