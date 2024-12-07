##################################### SPEEDTEST #################################################
# Установить необходимые пакеты
apt-get install -y curl jq bc

curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash

apt-get install -y speedtest
# Создать директорию и клонировать репозиторий
mkdir -p /etc/zabbix/bin

rm -rf zabbix-template-speedtest  # Удалить, если существует

git clone https://github.com/pschmitt/zabbix-template-speedtest.git

cd zabbix-template-speedtest


# Копировать и настроить скрипт
cp zbx-speedtest-debian.sh /etc/zabbix/bin/zbx-speedtest.sh

chmod +x /etc/zabbix/bin/zbx-speedtest.sh

# Копировать файлы systemd

cp systemd/zabbix-speedtest-debian.service /etc/systemd/system/zabbix-speedtest.service

cp systemd/zabbix-speedtest.timer /etc/systemd/system/

systemctl restart zabbix-agent2

systemctl enable --now zabbix-speedtest.timer

# Настроить конфигурацию Zabbix

cp zabbix_agentd.d/speedtest.conf /etc/zabbix/zabbix_agent2.d/plugins.d/

# Запланировать выполнение задачи через cron

CRON_JOB="*/30 * * * * /etc/zabbix/bin/zbx-speedtest.sh"

bash -c "(crontab -l; echo \"$CRON_JOB\") | crontab -"

# Обновить скрипт с использованием sed

FILE="/etc/zabbix/bin/zbx-speedtest.sh"

sed -i.bak 's/\(if speedtest\)/\1 --server-id 36998/' "$FILE"

echo "Успешно обновлено: добавлен --server-id 36998"

echo "Сейчас он будет делать замер скорости нужно подождать секунд 40"
      - "./data/speedtest:/data/speedtest:ro"
    environment:
      - ZBX_HOSTNAMEITEM=system.hostname
      - ZBX_SERVER_HOST=zabbix.example.com
