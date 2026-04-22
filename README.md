# Duoduo Bootstrap

This is the public bootstrap helper for the private Duoduo vault.

## One-command restore

After authenticating to GitHub, run:

```bash
git clone https://github.com/kurisu12h/duoduo-bootstrap.git && cd duoduo-bootstrap && bash bootstrap.sh
```

The script will:
1. Clone the private vault repo: `kurisu12h/duoduo-vault`
2. Verify checksum files
3. Restore `~/.hermes/` and the Hermes framework snapshot
4. Leave a timestamped backup of any existing `~/.hermes/` directory

## Security model

- The public repo contains only a tiny bootstrapper.
- The real state stays in the private repo.
- The private backup package is verified with SHA256 before restoration.
