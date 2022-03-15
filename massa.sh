#!/bin/bash
# Version 0.0.1

curl -s https://raw.githubusercontent.com/testnets-io/core/main/logo.sh | bash # grab testnets.io ascii logo

sleep 1

CHOICE=$(
whiptail --title "Massa Manager" --menu "Make a Choice" 25 78 16 \
	"1" "Node Installation."   \
	"2" "Start Client." \
   	"3" "Start Node Service." \
   	"4" "Stop Node Service." \
   	"5" "Create Wallet. - Only run once" \
   	"6" "View wallet." \
    	"7" "Check Journalctl." \
	"8" "End script"  3>&2 2>&1 1>&3	
)

clear 

curl -s https://raw.githubusercontent.com/testnets-io/core/main/logo.sh | bash # grab testnets.io ascii logo

case $CHOICE in

1) # 1 - NODE INSTALLATION
sudo apt update -y && sudo apt upgrade -y < "/dev/null"
sudo apt install curl make clang pkg-config libssl-dev build-essential git mc jq unzip wget -y
sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
source "$HOME"/.cargo/env
sleep 1
rustup toolchain install nightly
rustup default nightly
cd "$HOME" || exit
wget https://github.com/massalabs/massa/releases/download/TEST.8.0/massa_TEST.8.0_release_linux.tar.gz
tar -xvf massa_TEST*

sudo tee <<EOF >/dev/null /etc/systemd/system/massa.service
[Unit]
Description=Massa Node Service
After=network-online.target
[Service]
Environment=RUST_BACKTRACE=full
User=$USER
Restart=always
RestartSec=3
LimitNOFILE=65535
WorkingDirectory=$HOME/massa/massa-node
ExecStart=$HOME/massa/massa-node/massa-node
[Install]
WantedBy=multi-user.target
EOF

sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF

sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable massa
sudo systemctl start massa
echo "Starting Massa Node"

echo "Adding firewall rules"  
sudo ufw allow 31244  
sudo ufw allow 31245 
sudo ufw allow 22
sudo ufw --force enable

sudo tee <<EOF >/dev/null "$HOME"/massa/massa-node/config/config.toml
[network]
# replace the ip with yours
routable_ip ="$(hostname -I | cut -d " " -f 2)"
max_ping = 10000
# target number of non bootstrap outgoing connections
target_out_nonbootstrap_connections = 6
# max number of inbound non bootstrap connections
max_in_nonbootstrap_connections = 9

[bootstrap]
# list of bootstrap (ip, node id)
bootstrap_list = [
        ["149.202.86.103:31245", "5GcSNukkKePWpNSjx9STyoEZniJAN4U4EUzdsQyqhuP3WYf6nj"],
        ["149.202.89.125:31245", "5wDwi2GYPniGLzpDfKjXJrmHV3p1rLRmm4bQ9TUWNVkpYmd4Zm"],
        ["158.69.120.215:31245", "5QbsTjSoKzYc8uBbwPCap392CoMQfZ2jviyq492LZPpijctb9c"],
        ["158.69.23.120:31245", "8139kbee951YJdwK99odM7e6V3eW7XShCfX5E2ovG3b9qxqqrq"],
        ["217.160.193.14:31245",  "5pWAtd3L9KJuZ6WRidWthaaXMn9yFqZ98iPEEoQQWynJhQ769y"],
        ["209.145.63.209:31245", "8ksH2p3epiKrPosxGmZKyZWKUiiNHFFWPnHjPfd6AZPgfX7K47"],
        ["207.180.244.44:31245", "6cLr2Eygy58HQyB2roZjutodwFw7hmPGVvYwdCCxsBGwDg3W4Q"],
        ["198.100.148.20:31245", "5wu5HtCJyAxXsJCQ6NzsahV1ZuWfHK3Wt1j3vjU2L2iUbrX62A"],
        ["194.233.84.224:31245",  "87kJjGam2JqL84seerUpQmkxSjinzufkKyt7wFyLeqp5nxS8MA"],
        ["194.163.177.63:31245", "7BSDkwagQBvJZgj2R2voekTXbxuwEHAJp8F8bfr7LLeXAmxvXC"],
        ["194.156.79.23:31245",  "6uscLLig9FnKqL8vHpSJMNLPH3Ud6EAWLs4zvNduP2uwihPHLb"],
        ["188.166.211.233:31245",  "8JuEW2nZzoDGTisEzt3sg8u7LZaG32nTDutCEC3VaE8YHv5uaS"],
        ["188.166.39.154:31245",  "8DSjrbSuueaAmCtBPae1BwQH7zRM9xUHyigQGLwLKFbaxSbSVp"],
        ["185.234.247.227:31245", "8fpJu7iHdcQqRWqUs5KHDvbnLpGEwphm9A517q9eowWa17vXZ8"],
        ["185.213.209.35:31245",  "73TgqG6cbE4FkjGPr2hKwgYE5KuVNu7THseNmoKUwXx5HTzCbD"],
        ["185.161.122.193:31245",  "7oaYZLAgnmSHjJFeitBJiTMhNu4XzEi8XJKqp6n5pcQcbq2ZJR"],
        ["185.154.15.142:31245",  "8hpHsLgwY5L2bpea7LzivNGuKp3LLSwtAFpddqvjeQknucdV13"],
        ["178.170.47.165:31245",  "6ggMGsVSJsu6L4TbXNZE97bohcsepBhS1xbFjbfYGPLa6U3ouk"],
        ["167.86.116.184:31245", "8FLfdPh2jar65fY5wZz6c7DLebcSG4mj6a9oyoq6pmAU3dT2rs"],
        ["164.92.244.67:31245", "8EEcLP6byqzexWs3qC3z86Q6WrYdABE2M2L2fyj8s7jV1kHWZq"],
        ["164.92.240.96:31245",  "7jSPwCx5PdhEoaUzvkJarce5wtGJMe3JFa7VgFRDNzLfS7dk3t"],
        ["164.90.207.65:31245", "4yGpNwuaZzEicJSSTgufAHjMt8vSbFeaf4PpFg5CYyJzTTa1qq"],
        ["162.55.43.22:31245", "63JykGL5rezUyNzY6ECCMDzAmc7mkSUsa2VgwcAZyajcWnphRN"],
        ["161.97.139.195:31245", "7wAETpRBAgoTqC7BLigG6ecTkAg3h16SGc7eJ4kmKYQH458ibW"],
        ["158.69.120.215:31245",  "5QbsTjSoKzYc8uBbwPCap392CoMQfZ2jviyq492LZPpijctb9c"],
        ["154.53.59.87:31245", "4whDwLUi6KyXKt4ngisMup2YFKtxCs2AZgxsKww8mic5Pu6orz"],
        ["144.126.144.224:31245", "5CF1XQKM2FAQUjF4sLgfYft5sKth1GWfdLfhkK4nz2dcFpXHuJ"],
        ["144.126.143.157:31245", "7mqQAucHAJ4GhwozW2K6TsU1mHw8q4vnVbFMAnpBjmwwE63PWu"],
        ["144.91.94.187:31245", "6qDDf9CkePvZnLCeW7FdArrNz6nLPERKx1oXDtXZZB3gYqAzbp"],
        ["142.132.198.118:31245",  "6wDx3Fk9mNXUbys3TqGBMuPK8NHQRRJgrXpXJU1r8Yxv7MsR1o"],
        ["142.132.190.91:31245", "6rkvs6PA4nfxfjaz5EyCNvp2W6WEJEaHJkdUSudZLAMcWCVZue"],
        ["141.94.218.103:31245",  "5Vxoyjj9KwKudjgTzFg7SWDKpAh2ENsHwovaTgGQwxhcQD2958"],
        ["139.99.134.252:31245",  "6nY7Uj9AgnsVodfWKTutzbFCiecpc8EXZ8Z4FLHhBRowBQMPeh"],
        ["135.181.204.42:31245", "7kKRFLxgKCmCiYfZk51rj8Ba5DtFcyXUXaMYo9L4odgNN2KriF"],
        ["135.181.112.215:31245", "6jeAcQYVTjiJnw4eyr8SMWAsAaMtWLN6HutNfVvB9TfV8EZEep"],
        ["128.199.64.126:31245",  "4wJ4xcotfbd2SVCEDYDnUJS8TfntGUiEk1cxT8EhAngDz4qf5g"],
        ["109.238.14.37:31245",  "5rrZiaW5kaRRriv6fwDafQhJMQB2GGpjJ8MgmU4Zzygjnio9jd"],
        ["109.206.131.213:31245",  "5rSBNC5L1ce8nCcWuVFHtncXXxGXUggmEhUbWvMXHGgCJAPdhS"],
        ["95.217.118.121:31245",  "74CFJ3oF49fsMvLmaRvgf8Ydff6Rfnq96aitQTfoXvzN3pDFNU"],
        ["95.216.223.62:31245",  "8FmceEnYKfRPiPvXXHCvytmafgJHXGLityRPmf3iFs2VYAq1d7"],
        ["95.216.199.60:31245", "6riN7Rx2fttDqM8DixqMVSnwqFhbG74Xu4FtGLKnN8Zqr53adN"],
        ["95.216.194.8:31245",  "5Kn8XJ46aMd194iSn1kLcSNU9uHtqjFggigSmtUT49QueXw2vk"],
        ["95.216.27.164:31245",  "5wRuE64kSDj97bhar9fGsky8jMZnGuSiYmkmAT3yCeTHWsgDsu"],
        ["95.111.229.73:31245", "5Y8vHcHjEzHJzRRhUwHxr6kkbWgrYn95YT9Jxwf1sPLdrRfGxV"],
        ["94.130.55.152:31245", "7jhhkkPqVESLdWWyMU3ypjMDL9jX43eYZWUTH5cpWHCMmqaVC1"],
        ["94.103.92.218:31245", "5ew33KQcWFMA5KoMXQRsgLqQWQww35RuNt8Rb6CPtyWuGfareT"],
        ["93.29.134.115:31245", "7hx5EnXjTBWUvqDtVuEzyiQQTdNY6zycDi7GVxr7AqZ19Rzg9o"],
        ["93.10.109.43:31245",  "6Kz4Cc2jjBcNtJtKDaDZFM73KmxHT9cXpw3XeTEoKPoHncQ2CY"],
        ["90.8.60.107:31245", "7xqUr16C1YU9LahTotohg7mJS4HXqPpMmGJ43acDw4FhnvbC1E"],
        ["89.163.143.90:31245", "87jCJCqy3TRZouUELYHsTpFWF5z6y9BTbXLD8WvrXYUTT8wJK9"],
        ["88.99.186.187:31245", "8HEon7rdVFrnJbQSFM38x74mx3UAsBPnc1BKduHwhNTBLu6zZS"],
        ["88.198.6.229:31245",  "64t2Reyne4TtcscSLrUnp4iF6bZGR2BHvj5Gpg288eEmF7KTGN"],
        ["83.220.171.192:31245", "6HWa9Knn9XrZryuh6xsfqCcKZGabtMsWz4fPhWFUrCwoDo5cZF"],
        ["82.223.21.200:31245",  "6HuG1zJLbqycQgPUwFaYZddJiyQP6D9QMEhNwPeHKn3XjHQ3Na"],
        ["82.64.216.7:31245", "65Gx8ikMQLAJSrDNDhsWREjf4QjuPFYjGPmGVrjzBVPKi9giE1"],
        ["77.204.36.213:31245", "5nW8tSNNz5DhHQiMXYAYuNMyWKanqVkni2M3BEnn5byQtngioA"],
        ["77.68.81.61:31245", "64pZvYnWkMLGMFmCJriiVBkXKr6a7WWufGm3uW8qt17mHe6AY2"],
        ["77.51.200.79:31245",  "6ybdUb3ZoYoXmoSmhRB3WdBrQ4B3XQ64G2qJrjfSzbQBEPuRjC"],
        ["68.183.204.9:31245", "84ELHsXq8begPGiQ3naTaGjMhZWK563NPe4SHqHY4TnT2ae7sF"],
        ["65.108.216.142:31245", "51VMLaQSP3UAYRpfAKfi9a7qnxM1jz2fpAZaTtMbbFAefWiweY"],
        ["65.108.208.80:31245", "8J2bpCHfxwtSTZsaZQQAC86aqXwdZ79mhY73dZpeXFSSTrEP4i"],
        ["65.108.158.119:31245", "6QYwxSuqjfAEWGbJnj4LTjj59JCAEDbQ5ignJnQGmWbaTtwW8o"],
        ["65.108.156.197:31245", "8gxUKF4Rhi3MdhLpnDx5FbGzcDYNqthCzei5Dwkkh76ybLRUVj"],
        ["65.108.91.181:31245", "7vAdSYEQ3MPXpJy5LqLKaY7bu3535J9qGUSJ3NJ83TrikLFVTs"],
        ["65.108.90.16:31245",  "7Jt9AK6xgXw1Rs8fxfC155GqQqb8nsfoUVuTU6vsF2Ttru4Jaq"],
        ["65.108.79.224:31245",  "6kWMnEzSBAVxPSrSwmRtLYx3KWgMQTYnysMuDheNaHuJuBo1Mm"],
        ["65.108.59.25:31245",  "8FYpHvFb6x4Z7jUhpUbEmMgDLXULCQVXnE6MkZV23YrhVikWZV"],
        ["65.108.0.87:31245", "8gxw3WcxqYYks8yxJ5tEynw5acbMYPMASiwiAwSj9BsqeiNpJh"],
        ["65.21.244.17:31245",  "51N1Etf3VfjZXJND43d2ipgNfhj2xwHjmr8kMjfGhhZrTwaxUc"],
        ["65.21.237.85:31245", "7sxJgrwv1F5hmMACJd9ELvJU2y91wSiSJidgLSPQ2TsypiVJJX"],
        ["65.21.235.110:31245", "6RyJwp2guzxJirmC13wKx1QgLguekMmk7sSgHJLPpc14S6BN3d"],
        ["62.171.152.26:31245", "7BQo5xrAfS5xWiRGo8a5KJrUEpfn58r6btcgibLeKazsBCoTMV"],
        ["62.35.189.33:31245", "4zrk2uhdM39rK3VASyQNRLsXZS4CqHExiB6T4bNs3Rg1tuyaWg"],
        ["51.255.92.184:31245", "7QSHPsGmtPfvYs545XPctHftYUL8X3SpNJRRfqEGr9TpptPSdD"],
        ["45.76.84.174:31245", "5LfQsyHCU2NZGn6VfcmYTCJ3KaBVwmgUGVGScg3YcLME1qDMWN"],
        ["38.242.201.169:31245",  "776BHaBr4b983pZeKgCkzwDkZQF3dTwYeb1rcUK5nLMMz9rCkF"],
        ["34.78.72.253:31245",  "5P2KY5ChC8bYv42Fj282yabRhRsP6Us15fkA5y6h3fqyxTm3CG"],
        ["23.88.104.65:31245", "5USYjHgEb9KGqFApTYTzbnpYp3fzAuSacP9ieiTHxFi5DfYDE2"],
        ["23.88.59.110:31245", "56nUe87AZjvTs57QnqYUQxH4wubbyU6pjG8tU9U48sMKyPx1gk"],
        ["23.88.2.214:31245", "53MtxL1gjnkT51dKDftzeyVQ3hHw6iXGcddhqUAXXx49wrxYsS"],
        ["5.161.73.191:31245", "8meQLjxGaom1nKifWd69UBhbnmwjpuqkdKF7wfDgqvJGyQUbRx"],
    ]
# refuse consecutive bootstrap attempts from a given IP when the interval between them is lower than per_ip_min_interval milliseconds
per_ip_min_interval = 3600000
EOF
echo "Community bootstrap ip addresses added"
;;

2) # 2 - START CLIENT
cd $HOME/massa/massa-client/ || exit
./massa-client
;;

3) # 3 - START NODE SERVICE
sudo systemctl start massa
;;

4) # 4 - STOP NODE SERVICE
sudo systemctl stop massa
;;

5) # 5 - CREATE WALLET 
cd $HOME/massa/massa-client/ || exit
./massa-client --wallet wallet.dat wallet_generate_private_key
;;

6) # 6 - VIEW WALLET
cd $HOME/massa/massa-client/ || exit
./massa-client -- wallet_info
;;

7) # 7 - CHECK JOURNALCTL
sudo journalctl -eu massa.service
;;

8) # 8 - EXIT
exit
;;



*) echo "Not an option";;
esac
