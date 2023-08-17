{{/*
  Return a Job template for Job and CronJob object
*/}}

{{- define "common-app.jobSpec" -}}
{{- if and (.Values.job.enabled) -}}
backoffLimit: {{ .Values.job.backoffLimit }}
completionMode: {{ .Values.job.completionMode }}
completions: {{ .Values.job.completions }}
parallelism: {{ .Values.job.parallelism }}
suspend: false
template:
  metadata:
    annotations:
      {{- with .Values.podAnnotations }}
      {{- toYaml . | nindent 6 }}
      {{- end }}
    labels: {{- include "common-app.labels" . | nindent 6 }}
  spec:
    restartPolicy: OnFailure
    {{- with .Values.global.imagePullSecrets }}
    imagePullSecrets:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    containers:
      - name: {{ .Release.Name }}
        image: "{{ .Values.global.image.repository }}:{{ .Values.global.image.tag }}"
        imagePullPolicy: {{ .Values.global.image.pullPolicy }}
        {{- include "common-app.jobCmdArgs" . | indent 8 }}
        resources: {{- toYaml .Values.job.resources | nindent 10 }}
        {{- with .Values.env }}
        env: {{- toYaml . | nindent 10 }}
        {{- end }}
        {{- with .Values.envFrom }}
        envFrom: {{- toYaml . | nindent 10 }}
        {{- end }}
        {{- with .Values.job.volumeMounts }}
        volumeMounts: {{- toYaml . | nindent 10 }}
        {{- end }}
    {{- if .Values.job.initContainers }}
    initContainers:
    {{- with .Values.job.initContainers }}
      {{- tpl (toYaml .) $ | nindent 6 }}
    {{- end }}
    {{- end }}
    {{- with .Values.nodeSelector }}
    nodeSelector: {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.affinity }}
    affinity: {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.tolerations }}
    tolerations: {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with .Values.extraVolumes }}
    volumes: {{- toYaml . | nindent 6 }}
    {{- end }}
    securityContext: {{- toYaml .Values.securityContext | nindent 6 }}
    {{- if .Values.terminationGracePeriodSeconds }}
    terminationGracePeriodSeconds: {{ .Values.terminationGracePeriodSeconds }}
    {{- end }}
{{- end }}
{{- end -}}