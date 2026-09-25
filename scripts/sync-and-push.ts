import { spawnSync } from "child_process";

function run(cmd: string, args: string[], cwd: string = process.cwd(), ignoreError = false): string {
  console.log(`\x1b[36m➜ [${cwd.split(/[\\/]/).pop()}] ${cmd} ${args.join(" ")}\x1b[0m`);
  const res = spawnSync(cmd, args, { cwd, stdio: "inherit", shell: true });
  if (res.status !== 0 && !ignoreError) {
    console.error(`\x1b[31m✖ Command failed with exit code ${res.status}\x1b[0m`);
  }
  return res.status === 0 ? "ok" : "fail";
}

function hasChanges(cwd: string): boolean {
  const res = spawnSync("git", ["status", "--porcelain"], { cwd, encoding: "utf-8", shell: true });
  return (res.stdout || "").trim().length > 0;
}

function getBranch(cwd: string): string {
  const res = spawnSync("git", ["branch", "--show-current"], { cwd, encoding: "utf-8", shell: true });
  return (res.stdout || "").trim() || "main";
}

const customMessage = process.argv.slice(2).join(" ").trim();
const commitMessage = customMessage || `chore: update and sync lume repositories (${new Date().toISOString().slice(0, 10)})`;

console.log("\x1b[35m==================================================================\x1b[0m");
console.log("\x1b[35m       LUME MULTI-REPO SYNCHRONIZATION & AUTO-PUSH TOOL          \x1b[0m");
console.log(`\x1b[35m   Message: "${commitMessage}"\x1b[0m`);
console.log("\x1b[35m==================================================================\x1b[0m\n");

// 1. Backend repository (https://github.com/technopradyumn/lume_backend)
console.log("\x1b[34m[1/3] Processing Backend Repository (lume_backend)...\x1b[0m");
const backendCwd = "./backend";
if (hasChanges(backendCwd)) {
  run("git", ["add", "."], backendCwd);
  run("git", ["commit", "-m", `"${commitMessage}"`], backendCwd);
} else {
  console.log("  No uncommitted changes in backend.");
}
const backendBranch = getBranch(backendCwd);
console.log(`  Pushing branch '${backendBranch}' to origin...`);
run("git", ["push", "origin", "HEAD"], backendCwd);

// 2. Frontend repository (https://github.com/technopradyumn/lume_frontend)
console.log("\n\x1b[34m[2/3] Processing Frontend Repository (lume_frontend)...\x1b[0m");
const frontendCwd = "./frontend";
if (hasChanges(frontendCwd)) {
  run("git", ["add", "."], frontendCwd);
  run("git", ["commit", "-m", `"${commitMessage}"`], frontendCwd);
} else {
  console.log("  No uncommitted changes in frontend.");
}
const frontendBranch = getBranch(frontendCwd);
console.log(`  Pushing branch '${frontendBranch}' to origin...`);
run("git", ["push", "origin", "HEAD"], frontendCwd);

// 3. Monorepo root (https://github.com/technopradyumn/lume)
console.log("\n\x1b[34m[3/3] Processing Monorepo Root (lume)...\x1b[0m");
const rootCwd = ".";
if (hasChanges(rootCwd)) {
  run("git", ["add", "."], rootCwd);
  run("git", ["commit", "-m", `"${commitMessage}"`], rootCwd);
} else {
  console.log("  No uncommitted changes in root monorepo.");
}
const rootBranch = getBranch(rootCwd);
console.log(`  Pushing branch '${rootBranch}' to origin...`);
run("git", ["push", "origin", "HEAD"], rootCwd);

console.log("\n\x1b[32m==================================================================\x1b[0m");
console.log("\x1b[32m   ✔ ALL 3 REPOSITORIES ARE NOW FULLY SYNCHRONIZED AND PUSHED!   \x1b[0m");
console.log("   • https://github.com/technopradyumn/lume_backend");
console.log("   • https://github.com/technopradyumn/lume_frontend");
console.log("   • https://github.com/technopradyumn/lume");
console.log("\x1b[32m==================================================================\x1b[0m\n");
