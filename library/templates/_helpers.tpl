{{- define "default.image" -}}
{{- printf "%s:%s" .Values.image.repository .Values.image.version }}
{{- end -}}

{{- define "template.merge" -}}
{{- $merged := mergeOverwrite (dict) (default dict .Values) (default dict .Optional) }}
{{- toYaml $merged | trimSuffix "\n" }}
{{- end -}}

{{- define "template.field" -}}
  {{- $name := .Name }}
  {{- $default := .Default }}
  {{- $optional := .Optional }}
  {{- $type := .Type | default dict }}
  {{- $merged := default (default $type $optional) $default }}
  {{- if not (empty $merged) }}
  {{- if eq (kindOf $merged) "string" }}
{{ $name }}: "{{ $merged }}"
  {{- else if or (eq (kindOf $merged) "int") (eq (kindOf $merged) "float64") (eq (kindOf $merged) "bool" ) }}
{{ $name }}: {{ $merged }}
  {{- else }}
{{ $name }}: {{ toYaml $merged | nindent 2 }}
  {{- end }}
  {{- end }}
{{- end }}

{{- define "template.volumes" -}}
{{- $defaultVolumes := .Values.volumes }}
{{- $objectVolumes := .Object.volumes }}
{{- include "volumes.merge" (list $defaultVolumes $objectVolumes) }}
{{- end }}

{{- define "template.volumeMounts" -}}
{{- $defaultVolumeMounts := .Values.volumeMounts }}
{{- $containerVolumeMounts := .Container.volumeMounts }}
{{- include "volumeMounts.merge" (list $defaultVolumeMounts $containerVolumeMounts) }}
{{- end }}

{{- define "volumes.merge" -}}
{{- $map := dict -}}
{{- range $list := . }}
  {{- if $list }}
    {{- range $item := $list }}
      {{- $map = set $map $item.name $item }}
    {{- end }}
  {{- end }}
{{- end }}
{{- $result := list -}}
{{- range $key, $value := $map }}
  {{- $result = append $result $value }}
{{- end }}
{{- if not (empty $result) -}}
{{- printf "volumes" }}:{{ toYaml $result | nindent 2 }}
{{- end }}
{{- end }}

{{- define "volumeMounts.merge" -}}
{{- $map := dict -}}
{{- range $list := . }}
  {{- if $list }}
    {{- range $item := $list }}
      {{- $map = set $map $item.mountPath $item }}
    {{- end }}
  {{- end }}
{{- end }}
{{- $result := list -}}
{{- range $key, $value := $map }}
  {{- $result = append $result $value }}
{{- end }}
{{- if not (empty $result) -}}
{{- printf "volumeMounts"}}:{{ toYaml $result | nindent 2 }}
{{- end }}
{{- end }}
