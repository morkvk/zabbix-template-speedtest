# Используйте базовый образ Debian
FROM debian:bookworm

# Установить необходимые пакеты
RUN apt-get update && \
    apt-get install -y \
        curl \
        nano \
        git \
        systemd \
        locales \
        && \
    locale-gen en_US.UTF-8 && \
    apt-get clean

# Установить speedtest
RUN curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash && \
    apt-get install -y speedtest && \
    apt-get clean

# Создать директорию и клонировать репозиторий
RUN mkdir -p /etc/zabbix/bin && \
    git clone https://github.com/morkvk/zabbix-template-speedtest /tmp/zabbix-template-speedtest && \
    cp /tmp/zabbix-template-speedtest/zbx-speedtest.sh /etc/zabbix/bin/ && \
    chmod +x /etc/zabbix/bin/zbx-speedtest.sh && \
    rm -rf /tmp/zabbix-template-speedtest

# Копировать файлы systemd
COPY systemd/zabbix-speedtest.service /etc/systemd/system/zabbix-speedtest.service
COPY systemd/zabbix-speedtest.timer /etc/systemd/system/zabbix-speedtest.timer

# Включить и активировать службу и таймер
RUN systemctl enable zabbix-speedtest.service && \
    systemctl enable zabbix-speedtest.timer

# Настроить запуск systemd
CMD ["/lib/systemd/systemd"]
