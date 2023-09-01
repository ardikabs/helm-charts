{{/*
  Return a template of ingress http rule, only available if ingress is enabled.
*/}}
{{- define "common-app.ingresshttprule" -}}
{{- $validBackendPorts := list "http" "grpc" -}}
{{- $backendPort := (keys .Values.app.service.ports | first) -}}
{{- if not (mustHas $backendPort $validBackendPorts) }}
{{- fail (printf "ingress: Ingress is enabled, but there were no valid backend port defined (port=%s), it must be one of: %s" $backendPort (join ", " $validBackendPorts)) }}
{{- end -}}
paths:
  - path: {{ .Values.app.ingress.path | default "/" | quote }}
    pathType: {{ .Values.app.ingress.pathType | default "Prefix" | quote }}
    backend:
      service:
        name: {{ include "common-app.name" . }}
        port:
          name: {{ $backendPort }}
{{- end -}}