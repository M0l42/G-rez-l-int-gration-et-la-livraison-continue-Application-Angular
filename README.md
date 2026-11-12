# Olympic Participation Tracker

## Context

The **Olympic Participation Tracker** is an application designed to record and analyze countries' participation in the Olympic Games. It provides statistics on medals obtained by each country, helping users gain insights into historical performance. Although the application is currently in its early development stages, we aim to create a robust and user-friendly tool for Olympic enthusiasts.

## Technical Context

The application is built using **Angular 14.1** and relies on **npm** for package management. Angular offers a powerful framework for creating dynamic web applications, and npm simplifies the process of managing dependencies and scripts.

Summary:

- **NodeJS**: Tested with version 20.11.0
- **NPM**: Tested with version 10.2.4
- **NGINX**: Tested with version 1.27

## Getting Started

### Install dependencies

Run `npm i` in local development to install NodeJS dependencies. If you are installing the app on a CI environment prefer to use `npm ci`. you can also change npm cache directory to your working directory as following

```bash
npm ci --cache .npm --prefer-offline
```

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The application will automatically reload if you change any of the source files.

### Build

Run `npm run build` to build the project. The build artifacts will be stored in the `dist/` directory.

### Test

To run tests and ensure the application's functionality, use the following command:

```bash
npm test
```

Our test suite covers critical components, ensuring stability and reliability.

You can also use the unified test script (same script as the Java API), which copies the JUnit XML reports into `test-results/`:

```bash
./run-tests.sh
```

### Packaging

To package the application for distribution, run:

```bash
npm pack
```

This will create a distributable package containing the compiled code and necessary assets.

### Deploy on nginx

To deploy application on nginx web server with docker you can use nginx config located in the `nginx` folder. This one configure the root application folder in the `/app` folder.

After building the app copy the `dist/olympic-games-starter/browser` folder to the root application folder in the docker image.

The provided multi-stage `Dockerfile` does this for you:

```bash
docker compose up -d --build
# the app is served on http://localhost
```

### Publishing to GitLab Registry

To publish the application to a GitLab registry, follow these steps:

1. **Change Application Scope**:
   - Change the application scope for your new gitlab group. For example, if your repository url is `https://gitlab.com/your-gitlab-group-slug/olympic-games-starter` change the application name to `@your-gitlab-group-slug/olympic-games-starter`
   ```json
   {
      "name": "@your-gitlab-group-slug/olympic-games-starter",
      ...
   }
   ```
2. To publish, you need to create a file named `.npmrc` with the following content :

   ```ini
   @your-gitlab-group-slug:registry=https://gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}/packages/npm/
   //gitlab.com/api/v4/projects/${GITLAB_PROJECT_ID}/packages/npm/:_authToken="${GITLAB_TOKEN}"
   ```

3. **Set Environment Variables**:
   - Ensure that the following environment variables are specified:
     - `GITLAB_PROJECT_ID`: The ID of your GitLab project.
     - `GITLAB_TOKEN`: Your GitLab deploy token.
4. **Execute the Publish Command**:
   ```bash
   npm publish
   ```
   This will publish the package to your GitLab registry.

## Continuous Integration

The pipeline is defined in `.github/workflows/ci.yml`. The same file is used, unchanged, in the Angular and Java repositories: a first `detect` job finds the project type (`package.json` or `build.gradle`) and the other jobs adapt with conditions.

| Job | What it does |
|---|---|
| `detect` | Detects the project type (`node` or `gradle`) |
| `test` | Installs the toolchain (with dependency cache), runs `./run-tests.sh`, uploads `test-results/` as an artifact and publishes the JUnit report in the run summary, even when tests fail |
| `build` | Builds the Docker image, smoke-tests it (the container must really answer), then pushes it to `ghcr.io` |
| `release` | On `main` only: [semantic-release](https://semantic-release.gitbook.io/) creates the version tag and the GitHub Release from the commit messages, then tags the tested image with that version |

It runs on every push to `main` and `ci/**` branches, and on pull requests targeting `main` (pull requests are built and tested, never pushed).

### Image tags

Images are published to `ghcr.io/m0l42/<repository>`:

- `<branch>-<short sha>` for every push, e.g. `ci-workflow-1a2b3c4` or `main-1a2b3c4`
- `X.Y.Z` and `latest` for each release on `main`

### Versioning

Versions come from [Conventional Commits](https://www.conventionalcommits.org/): `fix:` bumps the patch, `feat:` the minor, `BREAKING CHANGE:` the major. The git tag is the source of truth; the version field in the build file is not updated.
