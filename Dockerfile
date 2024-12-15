# Используйте базовый образ Debian
FROM debian:bookworm

# Установить необходимые пакеты
RUN apt-get update && \
    apt-get install -y \
        curl \
        jq \
        bc \
        nano \
        git \
        systemd \
        locales \
        && \
    locale-gen en_US.UTF-8 && \
    apt-get clean

# Создать директорию copy
RUN mkdir /copy

# Установить speedtest
RUN curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash && \
    apt-get install -y speedtest && \
    apt-get clean

# Перейти в директорию /copy, клонировать репозиторий и скопировать скрипт
WORKDIR /copy
RUN git clone https://github.com/morkvk/zabbix-template-speedtest && \
    cp zabbix-template-speedtest/zbx-speedtest.sh /copy/zbx-speedtest.sh && \
    chmod +x /copy/zbx-speedtest.sh

# Копировать файлы systemd
COPY systemd/zabbix-speedtest.service /etc/systemd/system/zabbix-speedtest.service
COPY systemd/zabbix-speedtest.timer /etc/systemd/system/zabbix-speedtest.timer

# Включить и активировать службу и таймер
RUN systemctl enable zabbix-speedtest.service && \
    systemctl enable zabbix-speedtest.timer

# Настроить запуск systemd
CMD ["/lib/systemd/systemd"] 
