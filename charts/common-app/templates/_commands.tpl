{{/*
  Return template that should be used for command and args
  in application Deployment
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
  Return template that should be used for command and args
  in application Job
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
