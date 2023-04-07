{{/*
Expand the name of the chart.
*/}}
{{- define "chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "chart.fullname" -}}
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
This allows us to not have image: .Values.xxxx.ssss/.Values.xxx.xxx:.Values.ssss
in every single template.
*/}}
{{- define "broker.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $imageName := .Values.image.repository -}}
{{- $tag := .Values.image.tag -}}
{{- printf "%s/%s:%s" $registryName $imageName $tag -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "broker.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Return the Database hostname
*/}}
{{- define "broker.databaseHost" -}}
{{- if eq .Values.postgresql.architecture "replication" }}
{{- ternary (include "broker.postgresql.fullname" .) .Values.externalDatabase.config.host .Values.postgresql.enabled -}}-primary
{{- else -}}
{{- ternary (include "broker.postgresql.fullname" .) .Values.externalDatabase.config.host .Values.postgresql.enabled -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database port
*/}}
{{- define "broker.databasePort" -}}
{{- ternary "5432" .Values.externalDatabase.config.port .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Return the databaseAdapter configured
*/}}
{{- define "broker.databaseAdapter" -}}
{{- ternary "postgres" .Values.externalDatabase.config.adapter .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Return the database name
*/}}
{{- define "broker.databaseName" -}}
{{- ternary .Values.postgresql.auth.database .Values.externalDatabase.config.databaseName .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Return the Database username
*/}}
{{- define "broker.databaseUser" -}}
{{- ternary .Values.postgresql.auth.username .Values.externalDatabase.config.auth.username .Values.postgresql.enabled | quote -}}
{{- end -}}


{{/*
Return the Database Secret Name
*/}}
{{- define "broker.databaseSecretName" -}}
{{- if .Values.postgresql.enabled }}
    {{- if .Values.postgresql.auth.existingSecret }}
        {{- tpl .Values.postgresql.auth.existingSecret $ -}}
    {{- else -}}
        {{- default (include "broker.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.externalDatabase.enabled }}
        {{- .Values.externalDatabase.config.auth.existingSecret -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the databaseSecret key to retrieve credentials for database
*/}}
{{- define "broker.databaseSecretKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.postgresql.auth.existingSecret -}}
        {{- .Values.postgresql.auth.secretKeys.userPasswordKey  -}}
    {{- else -}}
        {{- print "password" -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.externalDatabase.enabled }}
        {{- if .Values.externalDatabase.config.auth.existingSecret -}}
            {{- .Values.externalDatabase.config.auth.existingSecretPasswordKey -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}


{{/*
 Create the name of the service account to use
*/}}
{{- define "broker.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Logging ENV Vars
*/}}
{{ define "envVars.logging" }}
- name: PACT_BROKER_LOG_LEVEL
  value: {{ .Values.broker.config.logLevel | quote }}
- name: PACT_BROKER_LOG_FORMAT
  value: {{ .Values.broker.config.logFormat | quote }}
- name: PACT_BROKER_HTTP_DEBUG_LOGGING_ENABLED
  value: {{ .Values.broker.config.httpDebugLoggingEnabled | quote }}
- name: PACT_BROKER_HIDE_PACTFLOW_MESSAGES
  value: {{ .Values.broker.config.hidePactflowMessages | quote }}
{{- end -}}

{{/*
Database ENV Vars
*/}}
{{- define "envVars.db" -}}
- name: PACT_BROKER_DATABASE_ADAPTER
  value: {{ include "broker.databaseAdapter" . }}
- name: PACT_BROKER_DATABASE_HOST
  value: {{ include "broker.databaseHost" . }}
- name: PACT_BROKER_DATABASE_PORT
  value: {{ include "broker.databasePort" . }}
- name: PACT_BROKER_DATABASE_NAME
  value: {{ include "broker.databaseName" . }}
- name: PACT_BROKER_DATABASE_USERNAME
  value: {{ include "broker.databaseUser" . }}
- name: PACT_BROKER_DATABASE_PASSWORD
  {{- if and .Values.postgresql.enabled .Values.postgresql.auth.password }}
  value: {{ .Values.postgresql.auth.password | quote }}
  {{- else if and .Values.externalDatabase.enabled .Values.externalDatabase.config.auth.password }}
  value: {{ .Values.externalDatabase.config.auth.password | quote }}
  {{- else }}
  valueFrom:
    secretKeyRef:
      name: {{ include "broker.databaseSecretName" . }}
      key: {{ include "broker.databaseSecretKey" . }}
  {{- end }}
- name: PACT_BROKER_DATABASE_SSLMODE
  value: {{ .Values.broker.config.databaseSslmode | quote }}
- name: PACT_BROKER_SQL_LOG_LEVEL
  value: {{ .Values.broker.config.sqlLogLevel | quote }}
- name: PACT_BROKER_SQL_LOG_WARN_DURATION
  value: {{ .Values.broker.config.sqlLogWarnDuration | quote }}
- name: PACT_BROKER_SQL_ENABLE_CALLER_LOGGING
  value: {{ .Values.broker.config.sqlEnableCallerLogging | quote }}
- name: PACT_BROKER_DATABASE_MAX_CONNECTIONS
  value: {{ .Values.broker.config.databaseMaxConnections | quote }}
- name: PACT_BROKER_DATABASE_POOL_TIMEOUT
  value: {{ .Values.broker.config.databasePoolTimeout | quote }}
- name: PACT_BROKER_DATABASE_CONNECT_MAX_RETRIES
  value: {{ .Values.broker.config.databaseConnectMaxRetries | quote }}
- name: PACT_BROKER_AUTO_MIGRATE_DB
  value: {{ .Values.broker.config.autoMigrateDb | quote }}
- name: PACT_BROKER_AUTO_MIGRATE_DB_DATA
  value: {{ .Values.broker.config.autoMigrateDbData | quote }}
- name: PACT_BROKER_ALLOW_MISSING_MIGRATION_FILES
  value: {{ .Values.broker.config.allowMissingMigrationFiles | quote }}
- name: PACT_BROKER_DATABASE_STATEMENT_TIMEOUT
  value: {{ .Values.broker.config.databaseStatementTimeout | quote }}
- name: PACT_BROKER_METRICS_SQL_STATEMENT_TIMEOUT
  value: {{ .Values.broker.config.metricsSqlStatementTimeout | quote }}
- name: PACT_BROKER_DATABASE_CONNECTION_VALIDATION_TIMEOUT
  value: {{ .Values.broker.config.databaseConnectionValidationTimeout | quote }}
{{- end -}}

{{/*
Database Cleanup ENV Vars
*/}}
{{- define "envVars.dbCleanup" -}}
- name: PACT_BROKER_DATABASE_CLEAN_DELETION_LIMIT
  value: {{ .Values.broker.config.databaseClean.deletionLimit | quote }}
- name: PACT_BROKER_DATABASE_CLEAN_OVERWRITTEN_DATA_MAX_AGE
  value: {{ .Values.broker.config.databaseClean.overwrittenDataMaxAge | quote }}
- name: PACT_BROKER_DATABASE_CLEAN_KEEP_VERSION_SELECTORS
  value: {{ .Values.broker.config.databaseClean.keepVersionSelectors | quote }}
- name: PACT_BROKER_DATABASE_CLEAN_DRY_RUN
  value: {{ .Values.broker.config.databaseClean.dryRun | quote }}
{{- end -}}