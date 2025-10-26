# Renovate Configuration for Pact Broker Double Versioning

## The Challenge: Compound Version Numbers

The Pact Broker Docker images use a compound versioning scheme that includes two separate version numbers:

```
2.124.0-pactbroker2.112.0
│       │          │
│       │          └── Pact Broker Ruby Gem version
│       └──────────────── Hyphen separator with "pactbroker" prefix
└──────────────────────── Docker image version
```

### Version Progression Example

Here's how the versions have progressed:
- `2.120.0-pactbroker2.110.0`
- `2.124.0-pactbroker2.112.0` (current)
- `2.125.0-pactbroker2.113.0` (both parts updated)
- `2.126.0-pactbroker2.113.0` (only Docker version updated)
- `2.127.0-pactbroker2.113.2` (gem patch version update)
- `2.128.0-pactbroker2.114.0` (both parts updated)
- `2.133.0-pactbroker2.116.0` (latest)

## The Problem

Standard semantic versioning (semver) doesn't handle this dual-version format well because:
1. The version contains two independent version numbers
2. Either part can be updated independently
3. Version comparison needs to consider both parts hierarchically

## The Solution: Loose Versioning

We've configured Renovate to use **"loose" versioning** instead of strict regex versioning. This approach:

1. **More Flexible Parsing**: Loose versioning can handle non-standard version formats
2. **Natural Ordering**: It understands that `2.125.0-pactbroker2.113.0` > `2.124.0-pactbroker2.112.0`
3. **Handles Both Components**: Properly compares the full version string

### Configuration

```json
{
  "packageRules": [
    {
      "description": "Configure versioning for Pact Broker Docker image",
      "matchPackageNames": [
        "ghcr.io/pact-foundation/pact-broker"
      ],
      "matchDatasources": ["docker"],
      "versioning": "loose"  // ← Key change: using "loose" instead of regex
    }
  ],
  "customManagers": [
    {
      "customType": "regex",
      "matchStrings": [
        "image: ghcr\\.io/pact-foundation/pact-broker:(?<currentValue>[0-9]+\\.[0-9]+\\.[0-9]+-pactbroker[0-9]+\\.[0-9]+\\.[0-9]+)"
      ],
      "versioningTemplate": "loose"  // ← Also using "loose" here
    }
  ]
}
```

## How Loose Versioning Works

Loose versioning:
1. Splits the version string into comparable segments
2. Compares numeric parts numerically
3. Compares string parts alphabetically
4. Handles pre-release identifiers correctly

For `2.124.0-pactbroker2.112.0` vs `2.125.0-pactbroker2.113.0`:
1. First compares `2.124.0` vs `2.125.0` → 2.125.0 is newer
2. If equal, would then compare the suffix parts

## Testing the Configuration

### Local Testing (Limited)
```bash
# Run renovate locally (won't fetch remote versions)
renovate --platform=local

# With debug output
LOG_LEVEL=debug renovate --platform=local
```

### Full Testing (Requires GitHub Token)
```bash
# Set your GitHub token
export GITHUB_TOKEN=your_github_token_here

# Run against the repository
renovate --platform=github --repository=your-org/pact-broker-chart
```

## Expected Behavior

With this configuration, Renovate should:
1. ✅ Detect the current version: `2.124.0-pactbroker2.112.0`
2. ✅ Fetch available versions from GitHub Container Registry
3. ✅ Recognize `2.133.0-pactbroker2.116.0` as newer
4. ✅ Create a PR to update the image version

## Alternative Approaches (If Loose Versioning Fails)

### Option 1: Custom Regex with Explicit Version Parts
```json
{
  "versioning": "regex:^(?<major>\\d+)\\.(?<minor>\\d+)\\.(?<patch>\\d+)-pactbroker(?<compatibility>\\d+\\.\\d+\\.\\d+)$",
  "extractVersion": "^(?<version>\\d+\\.\\d+\\.\\d+-pactbroker\\d+\\.\\d+\\.\\d+)$"
}
```

### Option 2: Docker Versioning
```json
{
  "versioning": "docker"
}
```
Docker versioning understands tags with hyphens and might handle this format.

### Option 3: Treat Entire String as Version
```json
{
  "versioning": "regex:^(?<version>.+)$"
}
```
This treats the entire string as an opaque version for string comparison.

## Monitoring Updates

To verify Renovate is working:
1. Check the Renovate dashboard/logs after deployment
2. Look for created PRs with title like "Update ghcr.io/pact-foundation/pact-broker"
3. Verify the PR updates both version components correctly

## References

- [Renovate Versioning Schemes](https://docs.renovatebot.com/modules/versioning/)
- [Loose Versioning Documentation](https://docs.renovatebot.com/modules/versioning/#loose)
- [Pact Broker Releases](https://github.com/pact-foundation/pact-broker-docker/releases)