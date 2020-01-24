{{/* vim: set filetype=mustache: */}}
{{- define "akeneo.image" -}}
{{- .Values.akeneo.image | default(printf "clickandmortar/akeneo:%s-demo" .Values.akeneo.version) -}}
{{- end -}}
