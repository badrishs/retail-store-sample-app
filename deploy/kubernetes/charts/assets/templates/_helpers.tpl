{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "assets.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "assets.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "assets.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "assets.labels" -}}
helm.sh/chart: {{ include "assets.chart" . }}
{{ include "assets.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "assets.selectorLabels" -}}
app.kubernetes.io/name: {{ include "assets.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: service
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "assets.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "assets.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the config map to use
*/}}
{{- define "assets.configMapName" -}}
{{- if .Values.configMap.create }}
{{- default (include "assets.fullname" .) .Values.configMap.name }}
{{- else }}
{{- default "default" .Values.configMap.name }}
{{- end }}
{{- end }}


{{/* podAnnotations */}}
{{- define "assets.podAnnotations" -}}
{{- if or .Values.metrics.enabled .Values.traces.enabled .Values.podAnnotations }}
{{- $podAnnotations := .Values.podAnnotations}}
{{- $metricsAnnotations := .Values.metrics.podAnnotations}}
{{- $tracessAnnotations := .Values.traces.podAnnotations}}
{{- $allAnnotations := merge $podAnnotations $metricsAnnotations $tracessAnnotations }}
{{- toYaml $allAnnotations }}
{{- end }}
{{- end -}}