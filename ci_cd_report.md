# CI/CD Pipeline for Node.js Project on GitHub Actions

## Key Steps
1. **Checkout** – Retrieve the repository.
2. **Set up Node.js** – Use `actions/setup-node` to install the required version.
3. **Cache Dependencies** – Cache `node_modules` or `pnpm-store` to speed up builds.
4. **Install Dependencies** – Run `npm ci` (or `pnpm install`).
5. **Run Lint & Tests** – Execute ESLint, unit tests (Jest, Mocha), and type checks.
6. **Build** – Run `npm run build` (or appropriate script).
7. **Deploy to Staging** – Use a deployment action (e.g., `appleboy/ssh-action` for SSH, `azure/webapps-deploy`, or `netlify/actions`).
8. **Post-Deployment Checks** – Verify health endpoints, run smoke tests.
9. **Notify** – Post status to Slack, Teams, or GitHub comment.

## Example Workflow YAML
```yaml
name: CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Run tests
        run: npm test

      - name: Build
        run: npm run build

  deploy-staging:
    needs: build-test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build

      - name: Deploy to Staging
        uses: appleboy/ssh-action@v0.1.5
        with:
          host: ${{ secrets.STAGING_HOST }}
          username: ${{ secrets.STAGING_USER }}
          key: ${{ secrets.STAGING_KEY }}
          script: |
            cd /var/www/app
            git pull origin main
            npm ci --production
            pm2 restart app

      - name: Health Check
        run: curl -f http://staging.example.com/health

      - name: Notify
        uses: slackapi/slack-github-action@v1.23.0
        with:
          payload: |
            {
              "text": "Deployment to staging succeeded!"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

## Tips & Best Practices
- **Separate Environments** – Use distinct branches or tags for production vs. staging.
- **Cache wisely** – Cache `node_modules` but invalidate on `package-lock.json` changes.
- **Parallel jobs** – Run lint, test, and build in parallel if they don’t share state.
- **Secure secrets** – Store all credentials in GitHub Secrets, not in the repo.
- **Fail fast** – Abort the workflow on first failure (`continue-on-error: false`).
- **Use matrix builds** – Test across multiple Node.js versions.

---

**References**
- GitHub Actions Documentation: https://docs.github.com/en/actions
- Node.js CI/CD Best Practices: https://nodejs.org/en/docs/guides/ci-cd/