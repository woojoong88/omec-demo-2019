{{- /*
# Copyright 2018-present Open Networking Foundation
# Copyright 2018 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/ -}}

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mcord-services.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mcord-services.fullname" -}}
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
{{- define "mcord-services.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Render the given template.
*/}}
{{- define "mcord-services.template" -}}
{{- $name := index . 0 -}}
{{- $context := index . 1 -}}
{{- $last := base $context.Template.Name }}
{{- $wtf := $context.Template.Name | replace $last $name -}}
{{ include $wtf $context }}
{{- end -}}

{{/*
Return identity, realm, and hostname of the first pod of the given statefulset.
*/}}
{{- define "mcord-services.endpoint_lookup" -}}
{{- $service := index . 0 -}}
{{- $type := index . 1 -}}
{{- $context := index . 2 -}}
{{- $serviceContext := index $context.Values $service -}}
{{- $serviceName := $serviceContext.name -}}
{{- if eq $type "identity" -}}
{{- printf "%s-0.%s.%s.svc.%s" $serviceName $serviceName $context.Release.Namespace "cluster.local" -}}
{{- else if eq $type "realm" -}}
{{- printf "%s.%s.svc.%s" $serviceName $context.Release.Namespace "cluster.local" -}}
{{- else if eq $type "host" -}}
{{- printf "%s-0" $serviceName -}}
{{- end -}}
{{- end -}}
