import { defineRailway, github, preserve, project, service } from "railway/iac";

// This repository manages only its own resources in each environment. Postgres
// and its volume are left to the dashboard.
// See https://docs.railway.com/infrastructure-as-code#multi-repo-projects
//
// Environments: production and staging are applied from this file
// (`railway environment <name>` then `railway config plan` / `apply`). PR
// environments are not applied; Railway copies them from the base environment's
// live settings, so apply here first for a change to reach them.
export const partial = "web";

export default defineRailway((ctx) => {
  const production = ctx.isEnvironment("production");

  const web = service("web", {
    // Omitting source/env/domains deletes them on apply; preserve() keeps the
    // values on Railway instead of in git.
    source: github("patrickemuller/blog", { checkSuites: false }),
    // The custom domain belongs to production only.
    domains: production ? ["patrickemuller.tech"] : [],
    env: { DATABASE_URL: preserve(), RAILS_MAX_THREADS: preserve(), SECRET_KEY_BASE: preserve() },
    build: { builder: "DOCKERFILE", dockerfilePath: "Dockerfile" },
    start: "bin/rails server",
    // Runs pending migrations before the new release takes traffic; a failure
    // aborts the deploy and keeps the previous release serving.
    preDeploy: "bin/rails db:prepare",
    // rails/health#show: 200 only once the app boots. assume_ssl keeps force_ssl
    // from redirecting the probe.
    healthcheck: "/up",
    healthcheckTimeout: 60,
    replicas: { "us-west2": 1 },
    deploy: {
      limitOverride: { containers: { cpu: 1, memoryBytes: 3_000_000_000 } },
    },
    // Restart policy (ON_FAILURE, 10 retries) and sleepApplication: false are
    // Railway defaults; declaring them shows as perpetual drift.
  });

  return project("blog", {
    resources: [web],
  });
});
