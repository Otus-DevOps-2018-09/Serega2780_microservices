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


Gitlab-CI-2

Pipeline из предыдущего ДЗ расширен путем добавления задач stage и production;
Рассмотрена работа pipeline в режиме с тэгами;
Рассмотрена работа pipeline в режиме с динамическим окружением.

Выполнено  первое задание со *.
Для этого исходный image ruby:2.4.2 дополнен пакетами gcloud, docker-ce, docker-machine. Соответствующий Dockerfile в папке ./gitlab-ci. Полученный образ называется ruby-docker:2.4.2, именно он используется в .gitlab-ci.yml.
При пуше новой ветки с помощью конструкции if then else + средствами gcloud проверяется наличие виртуальной машины в GCE с соответствующим именем. Если она есть об этом выводится соответствующее сообщение, если нет - она создается docker-machine. Выбран именно docker-machine, а не gcloud, так как полученная ВМ уже будет иметь установленный docker. Добавлен новый job branch stop GCE Server с режимом manual. При нажатии на соответствующую кнопку в UI запускается механизм удаления ВМ gcloud.

Выполнено второе задание со **.
На шаге build из исходников в папке ./docker-monolith собирается образ приложения reddit, который затем пушится на docker hub.
На шаге branch review из этого образа средствами gcloud на созданной в GCE ВМ запускается контейнер приложения reddit.


Monitoring-1

На хосте в GCE запущен prometheus из образа prom/prometheus:v2.1.0;
Собраны образы микросервисов приложения Reddit с помощью docker_build.sh;
С помощью docker-compose запущены контейнеры prometheus и приложения reddit; рассмотрено взаимодействие prometheus и  приложения;
Запущен node-exporter для сбора метрик виртуального хоста;
Созданные в процессе выполнения ДЗ образы выгружены на docker hub: https://cloud.docker.com/u/270580/repository/list.

Выполнено первое задание со *.

В качестве экспортера выбран образ eses/mongodb_exporter.

Выполнено второе задание со *.

Запущен образ cloudprober/cloudprober:v0.10.0 для мониторинга (probe PING) состояния ресурсов: UI, COMMENT, POST, а также google.com и mongodb для сравнения.

Выполнено третье задание со *.

Создан файл Makefile, умеющий собирать и пушить на docker hub образы приложения reddit.

Перед запуском команды docker-compose up -d необходимо запустить скрипт pre-script.sh изи папки ./docker.
Данный скрипт копирует файл конфигурации cloudprober.cfg на хост в GCE, а также выполняет на нем команду, необходимую для открытия ICMP datagram sockets - нужно для работы cloudprober probe PING.


Monitoring-2

На хосте в GCE запущен cAdvisor для сбора метрик о состоянии контейнеров и потребляемых ими ресурсов;
Установлен пакет Grafana для визуализации данных из Prometheus;
Импортирован dashboard Docker and system monitoring;
Создан dashboard UI_Service_Monitoring; 
 - создан график, выводящий информацию о скорости увеличения запросов (ui_request_count) со статусом 2**, 3**;
 - создан график, выводящий информацию о скорости увеличения ошибочных запросов (ui_request_count) со статусом 4**, 5**;
 - создан график выводящий гистограмму 95-процентиля времени ответа на запрос;
Создан dashboard Business_Logic_Monitoring;  
 - создан график, выводящий информацию о скорости увеличения количества постов;
 - создан график, выводящий информацию о скорости увеличения количества комментариев;
Установлен Alertmanager;
 - создано правило срабатывания алерта на событие контейнер down в течение 1 минуты;
 - настроена интеграция со slack - https://devops-team-otus.slack.com/messages/CE9HTHZM4;

Выполнено первое задание со *.
 - В Makefile добавлена сборка и push образов Prometheus и Alertmanager; 
 - Docker daemon настроен для отправки метрик в Prometheus. Импортирован и выгружен существующий dashboard 1229 - Docker Engine Metrics-1229.json;
 - Установлены и настроены Telegraf и InfluxDB. Импортирован и выгружен существующий dashboard 3056 - Docker Metrics per container-Telegraf_Infludb.json;
 - Реализован alert на 95-процентиль времени ответа UI превышающий или равный 5 мс в течение 1 минуты;
 - Настроена интеграция Alertmanager с email (помимо skack). Выбран Gmail.

 
Logging-1

На хосте в GCE запущены  Elasticsearch, Fluentd, Kibana;
Рассмотрена работа со структурированными логами (формат JSON);
Рассмотрена работа с неструктурированными логами:
 - разбор с помощью регулярных самописных выражений regexp;
 - разбор с помощью grok шаблона и дополнительного регулярного выражения.
 
Выполнено первое задание со *.
Конфигурация ./logging/fluentd/fluent.conf выполнена таким образом, чтобы одновременно разбирать все типы неструктурированных логов от сервиса UI.
 
Перед командами docker-compose... выполнить bash ./docker/pre-script-logging.sh для увеличения количества выделяемой по умолчанию памяти.

Kubernetes-1

Пройден Kubernetes The Hard Way;
Работоспособность сервисов проверена. Pod-ы запускаются.


Kubernetes-2

Развернуто локульное окружение для работы с Kubernetes - minikube;
В minikube запущено приложение reddit;
Развернуь Kubernetes в GCP - GKE;
Приложение reddit запущено в GKE; screenshot ./kubernetes/reddit/Reddit_GKE.jpg;
Настроен доступ к Dashboard в GKE с локальной машины; переход по ссылке: http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/;

Выполнено задание со *.

Kubernetes-кластер развернут с помощью Terrafrom модуля: ./kubernetes/reddit/gke.tf.


Kubernetes-3

Рассмотрена работа с типом доступа к сервису UI снаружи - LoadBalancer (GC);
Рассмотрена работа с объектом Ingress и плагином Ingress Controller;
Рассмотрена работа с объектом Secret, обеспечивающего доступ к сервису извне по HTTPS;

Выполнено задание со *.
Создан Kubernetes-манифест, описывающий объект Secret - ./kubernetes/reddit/ui-ingress-cert.yml;

Рассмотрен инструмент NetworkPolicy с сетевым плагином Calico;
Рассмотрена работа механизма PersistentVolume;
Рассмотрена работа механизма PersistentVolumeClaim;
Рассмотрено динамиское выделение Volumeс помощью StorageClass;

Kubernetes-4

Установлен Helm;
Приложение запущено с помощью Helm, Charts;
В GKE установлен Gitlab;
Настроен pipeline для ветки master;
Настроен pipeline для ветки feature/3 с возможностью деплоя приложения и его удаления по кновке;

Выполнено задание со *

После релиза образа из ветки мастер запускается деплой новой версии приложения на staging и production.
