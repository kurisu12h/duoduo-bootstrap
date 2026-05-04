# Duoduo Bootstrap

This is the public one-command entry repo for restoring Duoduo on a new server.

## Restore command

After authenticating to GitHub, run:

```bash
git clone https://github.com/kurisu12h/duoduo-bootstrap.git && cd duoduo-bootstrap && bash bootstrap.sh
```

## What this script does

1. clone or update the private vault repo: `kurisu12h/duoduo-vault`
2. verify `SHA256SUMS`
3. run the private vault restore entrypoint

The private vault restore then:

1. restores `~/.hermes/`
2. restores helper scripts under `/root/`
3. restores the Hermes framework snapshot
4. rebuilds the Hermes runtime and CLI link with `setup-hermes.sh`

## Auth requirements

Before running the command above, the new server needs GitHub access to the private repo.
Either:

```bash
gh auth login && gh auth setup-git
```

or:

```bash
export GITHUB_TOKEN=...   # token with private repo read access
```

## Security model

- this public repo contains only a tiny bootstrapper
- the real state stays in the private repo
- the private backup archives are verified with SHA256 before restoration
