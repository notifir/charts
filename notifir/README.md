# Notifir

Notifir is a notification center for your application. It's created to simplify the development of in-app notifications by providing a skeleton of the notification system. The essential functionality is available out of the box.

[Documentation of Notifir](https://notifir.github.io/docs/)
[Demo of Notifir](https://notifir.github.io/widget/)

Install from this repository

```bash
helm install --name notifir --namespace test .
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release` under namespace `my-namespace` using github repository:

```console
$ helm repo add notifir-charts https://notifir.github.io/charts
$ helm install --namespace my-namespace --name my-release notifir-charts/notifir
```

## Parameters

### Application

| Name        | Description                                                         | Value |
| ----------- | ------------------------------------------------------------------- | ----- |
| environment | a dictionary of pod environment variables for notifir pod container | `{}`  |
| initConfig  | init config to bootstrap projects on the application start          | `{}`  |

### Image

| Name       | Description                           | Value              |
| ---------- | ------------------------------------- | ------------------ |
| repository | your notifir backend image repository | `titenkov/notifir` |
| tag        | your notifir backend image tag        | `latest`           |
