{{/* vim: set filetype=mustache: */}}
{{- define "akeneo.image" -}}
{{- printf "clickandmortar/akeneo:%s-demo" .Values.akeneo.version -}}
{{- end -}}
