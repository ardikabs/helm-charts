{{/*
  Return a Job specification used for Job and CronJob object
*/}}
{{- define "common-app.jobSpec" -}}
{{- $root := .Values.job -}}
{{- if and ($root.enabled) -}}
backoffLimit: {{ $root.backoffLimit }}
completionMode: {{ $root.completionMode }}
completions: {{ $root.completions }}
parallelism: {{ $root.parallelism }}
suspend: false
template:
  metadata:
    annotations:
      {{- with $root.podAnnotations }}
      {{- toYaml . | nindent 6 }}
      {{- end }}
    labels: {{- include "common-app.labels" . | nindent 6 }}
      {{- with $root.podLabels }}
      {{- toYaml . | nindent 6 }}
      {{- end }}
  spec:
    serviceAccountName: {{ include "common-app.serviceAccountName" . }}
    {{- if not (.Values.global.serviceAccount.create) }}
    {{- with .Values.global.imagePullSecrets }}
    imagePullSecrets: {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- end }}
    restartPolicy: {{ $root.restartPolicy }}
    containers:
      - name: main
        {{- include "common-app.jobCmdArgs" . | indent 8 }}
        {{- include "common-app.containerImage" . | nindent 8 }}
        {{- with $root.env }}
        env: {{- toYaml . | nindent 10 }}
        {{- end }}
        envFrom:
          {{- with $root.envFrom }}
          {{- toYaml . | nindent 10 }}
          {{- end }}
          {{- if and (.Values.configmap.enabled) (not .Values.configmap.injectAsConfig.enabled) }}
          - configMapRef:
              name: {{ include "common-app.name" . }}
          {{- end }}
          {{- if and (.Values.secret.enabled) (not .Values.secret.injectAsConfig.enabled) }}
          - secretRef:
              name: {{ include "common-app.name" . }}
          {{- end }}
        resources: {{- toYaml $root.resources | nindent 10 }}
        volumeMounts:
          {{- with $root.extraVolumeMounts }}
          {{- toYaml . | nindent 10 }}
          {{- end }}
          {{- if and (.Values.configmap.enabled) (.Values.configmap.injectAsConfig.enabled) }}
          - name: app-config-file
            mountPath: /usr/share/app-config-file
          {{- end }}
          {{- if and (.Values.secret.enabled) (.Values.secret.injectAsConfig.enabled) }}
          - name: app-secret-file
            mountPath: /usr/share/app-secret-file
          {{- end }}
    {{- with $root.initContainers }}
    initContainers:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $root.nodeSelector }}
    nodeSelector: {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $root.affinity }}
    affinity: {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $root.tolerations }}
    tolerations: {{- toYaml . | nindent 6 }}
    {{- end }}
    volumes:
      {{- with $root.extraVolumes }}
      {{- toYaml . | nindent 6 }}
      {{- end }}
      {{- if and (.Values.configmap.enabled) (.Values.configmap.injectAsConfig.enabled) }}
      - name: app-config-file
        configMap:
          name: {{ include "common-app.name" . }}
          {{- if .Values.configmap.injectAsConfig.keys }}
          items:
          {{- range $key := .Values.configmap.injectAsConfig.keys }}
            key: {{ $key }}
            path: {{ $key }}
            mode: 0644
          {{- end }}
          {{- end}}
      {{- end }}
      {{- if and (.Values.secret.enabled) (.Values.secret.injectAsConfig.enabled) }}
      - name: app-secret-file
        secret:
          secretName: {{ include "common-app.name" . }}
          {{- if .Values.secret.injectAsConfig.keys }}
          items:
          {{- range $key := .Values.secret.injectAsConfig.keys }}
            key: {{ $key }}
            path: {{ $key }}
            mode: 0644
          {{- end }}
          {{- end}}
      {{- end }}
    securityContext: {{- toYaml $root.securityContext | nindent 6 }}
    {{- if $root.terminationGracePeriodSeconds }}
    terminationGracePeriodSeconds: {{ $root.terminationGracePeriodSeconds }}
    {{- end }}
{{- end }}
{{- end -}}