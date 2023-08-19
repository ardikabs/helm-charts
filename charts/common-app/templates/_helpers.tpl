{{/* vim: set filetype=mustache: */}}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common-app.releaseName" -}}
{{- $releaseName := .Release.Name -}}
{{- if hasSuffix .Values.global.channel $releaseName }}
{{- $releaseName = (trimSuffix .Values.global.channel $releaseName | trimSuffix "-") -}}
{{- end }}
{{- $releaseName | trunc 53 | trimSuffix "-" -}}
{{- end -}}

{{- define "common-app.name" -}}
{{- $releaseName := (include "common-app.releaseName" .) -}}
{{- if ne .Values.global.channel "none" -}}
{{- printf "%s-%s" $releaseName .Values.global.channel | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- $releaseName -}}
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
{{- include "common-app.podSelectorLabels" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.global.image.tag | quote }}
app.kubernetes.io/managed-by: {{ default .Release.Service .Values.global.managedBy }}
app.kubernetes.io/domain: {{ .Values.labels.domain }}
app.kubernetes.io/team: {{ .Values.labels.team }}
helm.sh/chart: {{ include "common-app.chart" . }}
{{- end }}

{{/*
Pod selector labels
*/}}
{{- define "common-app.podSelectorLabels" -}}
app.kubernetes.io/name: {{ include "common-app.releaseName" . }}
{{- $validChannels := list "none" "stable" "canary" -}}
{{- if not (has .Values.global.channel $validChannels) }}
{{- $failmsg := printf "Invalid \"global.channel\" value, should be one of the followings: \"none\", \"stable\", or \"canary\". Got \"%s\"." .Values.global.channel -}}
{{- fail $failmsg -}}
{{- end }}
app.kubernetes.io/channel: {{ .Values.global.channel }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "common-app.serviceAccountName" -}}
{{- if .Values.global.serviceAccount.create -}}
{{ default (include "common-app.name" .) .Values.global.serviceAccount.name }}
{{- else -}}
{{ default "default" .Values.global.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
  Container image
*/}}
{{- define "common-app.containerImage" -}}
{{- $root := .Values.global.image -}}
image: "{{ $root.repository }}:{{ $root.tag }}"
imagePullPolicy: {{ $root.pullPolicy }}
{{- end -}}
