# Welcome!
The following steps will guide you to setup an Ubuntu live USB to mine Ethereum.

## Features

I have tried my best to keep things as simple as possible with only the most useful packages installed on top of the base operating system. Downloads/Documentation are provided in the list below.

- Ubuntu 16.04.3 LTS [Download page](https://www.ubuntu.com/download/desktop)
- Claymore's Dual Miner [Thread post](https://bitcointalk.org/index.php?topic=1433925.0)
- Ethminer [Git](https://github.com/ethereum-mining/ethminer)
- Screen [Documentation](https://help.ubuntu.com/community/Screen)
- OpenSSHServer [Documentation](https://help.ubuntu.com/lts/serverguide/openssh-server.html)
- Nvidia CUDA & Nvidia Video Driver [Download](https://developer.nvidia.com/cuda-downloads?target_os=Linux)

## My Test Environment

I have tested this build on my evironment with the following hardware setup:

- ASRock AB350 Pro4
- Ryzen 3 1200
- GTX 1060 6GB
- TP-Link USB Wireless Network Adapter

I will not be using direct ethernet since I will be using a **wifi** connection.

## Troubleshooting

***Wifi is not connecting at login***

Allow the network to be connected by all users. The UI method will need you to go your Network Manager and edit the connection to enable all users to connect to the network.

[More info](https://askubuntu.com/questions/16376/connect-to-network-before-user-login)
