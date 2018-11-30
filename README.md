# Serega2780_microservices
Serega2780 microservices repository

Docker - 1

Настроена интеграция travis-ci с репозитарием Serega2780_microservices.
Установлен Docker.
Протестированы различные команды работы с Docker:
запуск контейнера;
запуск приложения в контейнере;
создание образа из контейнера;
Выполнено задание со *;
Протестированы команды удаления контейнера и образа.

Docker - 2

Установлен docker-machine;
Протестирована работа docker-machine; 
Создана структура репозитария с соответствующими файлами;
Собран и запущен образ;
Учетная запись зарегистрирована на Docker hub;
Созданный образ выгружен на Docker hub;
Выполнено задание со *;
Создан шаблон packer, запускающий плейбук ansible для установки docker-ce:
packer build -var-file=variables.json docker_host.json;
Terraform поднимает заданное переменной количество инстансов из шаблона packer;
Создан плейбук ansible, выполняющий доустановку необходимых пакетов на запущенных в GCE машинах и запускающий на них образ из docker hub:
ansible-playbook -i gce.py docker_dynamic.yml.
