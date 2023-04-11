{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ntppool.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ntppool.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ntppool.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "ntppool.chartLabels" -}}
helm.sh/chart: "{{ include "ntppool.chart" . }}"
app.kubernetes.io/version: {{ default .Chart.AppVersion .Values.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
{{- define "ntppool.labels" -}}
{{ include "ntppool.chartLabels" . }}
{{ include "ntppool.selectorLabels" . }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "ntppool.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ntppool.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ include "ntppool.name" . }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "ntppool.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "ntppool.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Standard app container
*/}}
{{- define "ntppool.appContainerDefaults" -}}
securityContext:
  {{- toYaml .Values.securityContext | nindent 2 }}
{{ if .Values.image.image }}
image: "{{ .Values.image.image }}"
{{- else }}
image: "{{ .Values.image.repository }}:{{ default .Chart.AppVersion .Values.image.tag }}"
{{- end }}
imagePullPolicy: {{ .Values.image.pullPolicy }}
env:
- name: CBCONFIG
  value: /var/ntppool/combust.conf
- name: auth0_secret
  valueFrom:
    secretKeyRef:
      key: auth0_secret
      name: {{ include "ntppool.fullname" . }}-secrets
- name: db_pass
  valueFrom:
    secretKeyRef:
      key: db_pass
      name: {{ include "ntppool.fullname" . }}-secrets
- name: db_auth_file
  valueFrom:
    secretKeyRef:
      key: db_auth_file
      name: {{ include "ntppool.fullname" . }}-secrets
- name: account_id_key
  valueFrom:
    secretKeyRef:
      key: account_id_key
      name: {{ include "ntppool.fullname" . }}-secrets
- name: vendor_zone_id_key
  valueFrom:
    secretKeyRef:
      key: vendor_zone_id_key
      name: {{ include "ntppool.fullname" . }}-secrets
- name: geoip_service
  value: {{ .Release.Name }}-geoip
- name: locationcode_service
  value: {{ .Release.Name }}-locationcode
- name: screensnap_service
  value: {{ .Release.Name }}-screensnap
- name: smtp_service
  value: {{ .Release.Name }}-smtp
envFrom:
- configMapRef:
    name: {{ include "ntppool.fullname" . }}-config
volumeMounts:
{{ if (ne .Values.config.deployment_mode "devel") -}}
- mountPath: /ntppool/data
  name: data
{{- end -}}
{{ if and .Values.develPath (eq .Values.config.deployment_mode "devel") -}}
- mountPath: '/ntppool'
  name: 'code'
{{- end -}}
{{- end -}}

{{- define "ntppool.appVolumes" -}}
{{ $values := .Values }}
- emptyDir: {}
  name: data
{{ if (and $values.develPath (eq $values.config.deployment_mode "devel")) }}
- name: code
  hostPath:
    path: {{ $values.develPath }}
{{- end}}
{{- end -}}
