# Migration Guide: Image Settings Changes in v5.0.0

## Overview

Version 5.0.0 of the Pact Broker Helm Chart reorganizes the image configuration settings. The image-related values have been moved from the top-level `image` object into the `broker` object for better logical organization of chart values.

This is a **breaking change** that requires updating your values files when upgrading from v4.x to v5.0.0.

## What Changed

### Previous Structure (v4.x and earlier)

```yaml
# Top-level image configuration
image:
  registry: docker.io
  repository: pactfoundation/pact-broker
  tag: 2.124.0-pactbroker2.112.0
  pullPolicy: IfNotPresent
  pullSecrets: []

# Separate broker configuration
broker:
  labels: {}
  annotations: {}
  # ... other broker settings
```

### New Structure (v5.0.0)

```yaml
# All image settings now under broker
broker:
  # Single image URL combining registry, repository, and tag
  image: docker.io/pactfoundation/pact-broker:2.124.0-pactbroker2.112.0

  # Renamed from pullPolicy to imagePullPolicy
  imagePullPolicy: IfNotPresent

  # Renamed from pullSecrets to imagePullSecrets
  imagePullSecrets: []

  # Other broker settings remain the same
  labels: {}
  annotations: {}
  # ... other broker settings
```

## Key Changes

1. **Image URL Format**: The separate `registry`, `repository`, and `tag` fields have been consolidated into a single `image` field containing the full image URL.

2. **Field Renaming**:
   - `pullPolicy` → `imagePullPolicy`
   - `pullSecrets` → `imagePullSecrets`

3. **Location**: All image-related settings are now nested under the `broker` object instead of being at the top level.
