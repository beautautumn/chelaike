# Prime Server

## 项目背景

二手车行业面临从之前卖方市场往买方市场的转变，中大型车商迫切的需要全面升级，在这个关键点，Prime项目成立。
Prime以车商利益为重，基于互联网技术，全面提升二车经营者的工作效率，进一步提升其对消费者的服务体验。

## Prime Server的职责

* 提供Prime客户端基于http和json的数据api

> Powered by Autobots.

## PRIME为什么这么做？

    1.我们理解二手车商需要什么。
    2.我们专注解决二手车交易的工作流问题。
    3.我们的团队前后端分离，PRIME作为server端无需关心展示层的问题。

## PRIME的API

  [markdown文档点这里](./API.md)
  [使用更完整的API调试功能点这里](http://docs.autobotsprime.apiary.io/)

## Dependencies
* postgres (>= 9.4.1)
* redis (>= 3.0.0)
* foreman (>= 0.81.0)

## Setup
1. cp config/application.example.yml config/application.yml
2. cp config/database.example.yml config/database.yml
3. cp config/pingpp/rsa_private_key.example.pem config/pingpp/rsa_private_key.pem
4. cp config/pingpp/rsa_public_key.example.pem config/pingpp/rsa_public_key.pem
5. cp config/pingpp/pingpp_rsa_public_key.example.pem config/pingpp/pingpp_rsa_public_key.pem
6. bundle exec rake db:setup
7. gem install foreman

## Start
1. foreman start

## Deploy
1. echo \<branch\> | bundle exec cap staging deploy
2. ssh-add -K ~/.ssh/id_rsa
