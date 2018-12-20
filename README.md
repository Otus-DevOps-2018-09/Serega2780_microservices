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

Docker-3

Создна новая структура приложения: src, post-py, coment, ui;
Созданы соответствующие  Dockerfiles, образы собраны, запущены, работоспособность приложение проверена;
Выполнено первое задание со *:
- имя сети изменено на my_reddit;
- в каждой папке - post-py, comment, ui - созданы файлы env.list с переенными нового окружения;
- соответствующие образы запущены с переменными окружения, соответствующими новым сетевым алиасам:
   docker run -d --network=my_reddit --network-alias=my_post_db --network-alias=my_comment_db mongo:latest
   docker run -d --network=my_reddit --env-file ./post-py/env.list --network-alias=my_post 270580/post:1.0
   docker run -d --network=my_reddit --env-file ./comment/env.list --network-alias=my_comment 270580/comment:1.0
   docker run -d --network=my_reddit--env-file ./ui/env.list  -p 9292:9292 270580/ui:1.0

Выполнено второе задание со *:
- образ ui собран на базе ruby:2.4-alpine3.8; размер сократился с 780MB до 246МБ;
- образ comment собран на базе нового ui, так как их Dockerfile отличаются лишь набором переменных окружения;
- образ post-py оставлен без изменений;

Добавлен volume. Проверено, что сообщения теперь сохраняются при перезапуске контейнеров.

Docker-4

Изучались возможности работы с сетью в Docker. Типы рассмотренных сетей:
 - None;
 - Host;
 - Bridge;
Взаимодействие машин, запущенных в разных сетях: back_end b front_end;
Работа с docker-compose;
Переменные окружения в .env файле;
Имя проекта задается либо через флаг -p при запуске docker-compose, либо как переменная COMPOSE_PROJECT_NAME в файле .env, либо переменная окружения - export COMPOSE_PROJECT_NAME;

Выполнено задание со *;
С помощью sshfs, согласно документации Docker, подключил локальную папку ~./src2 (локальная машина) на docker-host (GCE)/home/docker-user/srс. Проверил, что папки синхронизированы, т.е. при изменении локальной папки scr2, изменяется содержимое и удаленной папки;
docker-machine mount docker-host:/home/docker-user/src /home/sss/HW_15/Serega2780_microservices/src2/ 
В файле docker-compose.override.yml добавил volumes для каждого из сервисов:
 - ui, volume: /home/docker-user/src/ui -> /app;
 - post, volume: /home/docker-user/src/post -> /app;
 - comment, volume: /home/docker-user/src/comment -> /app.

Puma запускается в debug режиме с двумя воркерамии. 


Gitlab-CI-1

В GCE создана новая виртуальная машина повышенной мощности (docker-machine create, в ссоответствии с требования ДЗ);
Создан файл docker-compose.yml; Запущен Gitlab CI;
Создана группа, проект и pipeline;
Запущен и зарегистрирован runner (в docker контейнере);
Добавлено приложение reddit; .gitlab.ci.yml изменен для прохождения тестов приложения reddit; Тесты пройдены;
Выполнено задание со *:
- реализована технология Gitlab Runner Autoscaling https://docs.gitlab.com/runner/configuration/autoscale.html;
  с помощью команд:
  docker run -d --name gitlab-runner-autoscale --restart always --env GOOGLE_APPLICATION_CREDENTIALS="/home/gitlab-runner/<GCE _Account>.json" -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest
  docker exec -it gitlab-runner-autoscale gitlab-runner register --non-interactive --executor "docker+machine" --docker-image alpine:latest --url "http://<PUBLIC_IP>" --registration-token "TOKEN" --description "my-autoscale-runner" --tag-list "linux,xenial,ubuntu,docker" --run-untagged --locked="false"
  
  создан и зарегистрирован runner с executor "docker+machine";
  отредактирован файл cоnfig.toml таким образом, чтобы запускалось одновременно 4 задачи по две на каждой виртуальной машине; Виртуальные машины с docker-контейнерами и runner-ами в них поднимаются и удаляются автоматически по мере необходимости;
- настроена интеграция со Slack каналом; ссылка на ветку:
  https://devops-team-otus.slack.com/messages/CDAF28BFC  
