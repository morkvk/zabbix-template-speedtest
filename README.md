##################################### SPEEDTEST #################################################
# Установить необходимые пакеты
apt-get install -y curl jq bc

curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash

apt-get install -y speedtest
# Создать директорию и клонировать репозиторий
mkdir -p /etc/zabbix/bin

rm -rf zabbix-template-speedtest  # Удалить, если существует

git clone https://github.com/morkvk/zabbix-template-speedtest

cd zabbix-template-speedtest


# Копировать и настроить скрипт
cp zbx-speedtest.sh /etc/zabbix/bin/

chmod +x /etc/zabbix/bin/zbx-speedtest.sh

# Копировать файлы systemd

cp systemd/zabbix-speedtest.service /etc/systemd/system/

cp systemd/zabbix-speedtest.timer /etc/systemd/system/

systemctl enable zabbix-speedtest.timer

# Обновить скрипт с использованием sed

FILE="/etc/zabbix/bin/zbx-speedtest.sh"

sed -i.bak 's/\(if speedtest\)/\1 --server-id 36998/' "$FILE"
