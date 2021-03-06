{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "tidb-lightning.name" -}}
{{ .Release.Name }}-tidb-lightning
{{- end -}}

{{- define "helm-toolkit.utils.template" -}}
{{- $name := index . 0 -}}
{{- $context := index . 1 -}}
{{- $last := base $context.Template.Name }}
{{- $wtf := $context.Template.Name | replace $last $name -}}
{{ include $wtf $context }}
{{- end -}}

{{/*
Encapsulate config data for consistent digest calculation
*/}}
{{- define "lightning-configmap.data" -}}
config-file: |-
    {{- if .Values.config }}
{{ .Values.config | indent 2 }}
    {{- end -}}
    {{- if and .Values.tlsCluster .Values.tlsCluster.enabled }}
  [security]
  ca-path="/var/lib/lightning-tls/ca.crt"
  cert-path="/var/lib/lightning-tls/tls.crt"
  key-path="/var/lib/lightning-tls/tls.key"
    {{- end }}
    {{- if and .Values.tlsClient .Values.tlsClient.enabled }}
  [tidb.security]
  ca-path="/var/lib/tidb-client-tls/ca.crt"
  cert-path="/var/lib/tidb-client-tls/tls.crt"
  key-path="/var/lib/tidb-client-tls/tls.key"
    {{- end }}
{{- end -}}

{{- define "lightning-configmap.data-digest" -}}
{{ include "lightning-configmap.data" . | sha256sum | trunc 8 }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tidb-lightning.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
