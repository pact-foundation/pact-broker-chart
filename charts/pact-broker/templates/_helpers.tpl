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
{{- if kindIs "string" .Values.broker.image -}}
{{- .Values.broker.image -}}
{{- else -}}
{{- printf "%s:%s" .Values.broker.image.repository .Values.broker.image.tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the Database Secret Name
*/}}
{{- define "broker.databaseSecretName" -}}
{{- if .Values.database.auth.existingSecret }}
    {{- .Values.database.auth.existingSecret -}}
{{- end -}}
{{- end -}}

{{/*
Return the databaseSecret key to retrieve credentials for database
*/}}
{{- define "broker.databaseSecretKey" -}}
{{- if .Values.database.auth.existingSecret -}}
    {{- .Values.database.auth.existingSecretPasswordKey -}}
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
  value: {{ .Values.database.adapter | default "postgres" | quote }}
- name: PACT_BROKER_DATABASE_HOST
  value: {{ .Values.database.host }}
- name: PACT_BROKER_DATABASE_PORT
  value: {{ .Values.database.port | default "5432" | quote }}
- name: PACT_BROKER_DATABASE_NAME
  value: {{ .Values.database.databaseName | quote }}
- name: PACT_BROKER_DATABASE_USERNAME
  value: {{ .Values.database.auth.username | quote }}
- name: PACT_BROKER_DATABASE_PASSWORD
  {{- if .Values.database.auth.password }}
  value: {{ .Values.database.auth.password | quote }}
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