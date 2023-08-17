{{/* vim: set filetype=mustache: */}}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common-app.name" -}}
{{- if .Values.nameOverride }}
{{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "common-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "common-app.labels" -}}
helm.sh/chart: {{ include "common-app.chart" . }}
{{ include "common-app.podSelectorLabels" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.global.image.tag | quote }}
app.kubernetes.io/managed-by: {{ default .Release.Service .Values.global.managedBy }}
{{- with .Values.podLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "common-app.podSelectorLabels" -}}
app.kubernetes.io/name: {{ include "common-app.name" . }}
{{- $validChannels := list "stable" "canary" -}}
{{- if not (has .Values.global.channel $validChannels) }}
{{- fail "Invalid \"global.channel\" value, should be one of the followings: \"stable\", \"canary\". Got \"{{.Values.global.channel}}\"" -}}
{{- end }}
app.kubernetes.io/channel: {{ .Values.global.channel }}
{{- end }}
