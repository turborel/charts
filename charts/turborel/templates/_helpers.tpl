{{/*
The chart's name, and the release's full name: the release's name, with
the chart's after it unless it already holds it, held to 63 characters as
a DNS label is.
*/}}
{{- define "turborel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "turborel.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else if contains .Chart.Name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
The headless Service a StatefulSet's pods are named under.
*/}}
{{- define "turborel.headless" -}}
{{- printf "%s-headless" (include "turborel.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
The labels of every object, and the ones a selector matches on, which
cannot change once a StatefulSet is made.
*/}}
{{- define "turborel.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "turborel.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "turborel.selectorLabels" -}}
app.kubernetes.io/name: {{ include "turborel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "turborel.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "turborel.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "turborel.image" -}}
{{- printf "%s:%s" .Values.image.repository (default .Chart.AppVersion .Values.image.tag) }}
{{- end }}
