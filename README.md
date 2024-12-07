# Установка через docker + zabbix отдельно
1. В докер устанавилвается speedtest-cli и с помощью systemd он будет делать замеры скорости скриптом zbx-speedtest.sh

    Расшифровка:
    zbx-speedtest.sh запускает строку:
    
   `speedtest --server-id 36998 --accept-license --accept-gdpr -f json > "$DATA_FILE" 2> /tmp/error.log; then`

2. устанавливаем zabbix templates:


# Установим руками все последовательно

Установим необходимые пакеты

`apt-get install -y curl jq bc`

`curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash`

`apt-get install -y speedtest`



Создадим папку куда положим скрипт.

`mkdir -p /etc/zabbix/bin`


клонируем репозиторий

`git clone https://github.com/morkvk/zabbix-template-speedtest`


переходим в репозиторий

`cd zabbix-template-speedtest`


копируем sh скрипт в папку

`cp zbx-speedtest.sh /etc/zabbix/bin/`


выдаем права скрипту

`chmod +x /etc/zabbix/bin/zbx-speedtest.sh`



Копируем файлы systemd

`cp systemd/zabbix-speedtest.service /etc/systemd/system/`

`cp systemd/zabbix-speedtest.timer /etc/systemd/system/`


добавляем в systemd

`systemctl enable zabbix-speedtest.timer`
# Обновить скрипт с использованием sed

`FILE="/etc/zabbix/bin/zbx-speedtest.sh"`

`sed -i.bak 's/\(if speedtest\)/\1 --server-id 36998/' "$FILE"`
