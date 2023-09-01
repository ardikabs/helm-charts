{{/*
  Return a template of container commands and args on main container
  for Deployment object.
*/}}
{{- define "common-app.appCmdArgs" -}}
{{- if .Values.app.command }}
command:
{{ tpl (toYaml .Values.app.command) . | indent 2 }}
{{- end }}
{{- if .Values.app.args }}
args:
{{ tpl (toYaml .Values.app.args) . | indent 2 }}
{{- end }}
{{- end -}}

{{/*
  Return a template of container commands and args on main container
  for Job object.
*/}}
{{- define "common-app.jobCmdArgs" -}}
{{- if .Values.job.command }}
command:
{{ tpl (toYaml .Values.job.command) . | indent 2 }}
{{- end }}
{{- if .Values.job.args }}
args:
{{ tpl (toYaml .Values.job.args) . | indent 2 }}
{{- end }}
{{- end -}}

{{/*
  Return a template of container image and its pull policy
*/}}
{{- define "common-app.containerImage" -}}
{{- $root := .Values.global.image -}}
image: "{{ $root.repository }}:{{ $root.tag }}"
imagePullPolicy: {{ $root.pullPolicy }}
{{- end -}}
