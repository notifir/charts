{{/*
Expand the name of the chart.
*/}}
{{- define "notifir.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "notifir.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "notifir.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "notifir.labels" -}}
helm.sh/chart: {{ include "notifir.chart" . }}
{{ include "notifir.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "notifir.selectorLabels" -}}
app.kubernetes.io/name: {{ include "notifir.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "notifir.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "notifir.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Renders a value that contains template.
Usage:
{{ include "common.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "common.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/*
Create a default fully qualified app name for the postgres requirement.
*/}}
{{- define "notifir.postgresql.fullname" -}}
{{- $postgresContext := dict "Values" .Values.postgresql "Release" .Release "Chart" (dict "Name" "postgresql") -}}
{{ include "postgresql.primary.fullname" $postgresContext }}
{{- end -}}

{{/*
Create the name for the Notifir secret.
*/}}
{{- define "notifir.secret" -}}
{{- if .Values.postgresql.enabled }}
  {{- if .Values.postgresql.auth.existingSecret -}}
    {{- tpl .Values.postgresql.auth.existingSecret $ -}}
  {{- else -}}
    {{- include "notifir.postgresql.fullname" . -}}
  {{- end -}}
{{- else -}}
  {{- if .Values.externalDatabase.existingSecret -}}
    {{- tpl .Values.externalDatabase.existingSecret $ -}}
  {{- else -}}
    {{- include "notifir.fullname" . -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the name for the password secret key.
*/}}
{{- define "notifir.secretPasswordKey" -}}
{{- if .Values.externalDatabase.existingSecret -}}
  {{- .Values.externalDatabase.existingSecretPasswordKey -}}
{{- else -}}
  password
{{- end -}}
{{- end -}}

{{/*
Create the name for the postgres password secret key.
*/}}
{{- define "notifir.secretPostgresPasswordKey" -}}
{{- if .Values.externalDatabase.existingSecret -}}
  {{- .Values.externalDatabase.existingSecretPostgresPasswordKey -}}
{{- else -}}
  postgres-password
{{- end -}}
{{- end -}}

{{/*
Create the database password.
*/}}
{{- define "notifir.password" -}}
{{- if .Values.externalDatabase.password -}}
  {{- .Values.externalDatabase.password | b64enc | quote -}}
{{- else -}}
  {{- if .Values.postgresql.auth.password -}}
    {{- .Values.postgresql.auth.password | b64enc | quote -}}
  {{- else -}}
    {{- randAlphaNum 16 | b64enc | quote -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the database postgres password.
*/}}
{{- define "notifir.postgresPassword" -}}
{{- if .Values.externalDatabase.postgresPassword -}}
  {{- .Values.externalDatabase.postgresPassword | b64enc | quote -}}
{{- else -}}
  {{- if .Values.postgresql.auth.postgresPassword -}}
    {{- .Values.postgresql.auth.postgresPassword | b64enc | quote -}}
  {{- else -}}
    {{- randAlphaNum 16 | b64enc | quote -}}
  {{- end -}}
{{- end -}}
{{- end -}}