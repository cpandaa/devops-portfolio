---
{{- define "demo.name" -}}
{{ include "demo.chart" . }}
{{- end -}}

{{- define "demo.fullname" -}}
{{ printf "%s-%s" (include "demo.name" .) .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "demo.chart" -}}
{{ .Chart.Name }}
{{- end -}}

