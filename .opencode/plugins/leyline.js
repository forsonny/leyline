// Leyline OpenCode plugin shim.
//
// OpenCode resolves `main` from the repo's package.json and imports this file.
// The shim registers Leyline's discovery paths and exposes a minimal API.
// Full plugin behavior lives in skill files, subagent files, and the session-start hook;
// this shim only tells OpenCode where to find them.

import path from "node:path";
import { fileURLToPath } from "node:url";

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, "..", "..");

export default {
    name: "leyline",
    version: "1.2.0",
    manifest: path.join(root, "AGENTS.md"),
    skillsDir: path.join(root, "skills"),
    agentsDir: path.join(root, "agents"),
    commandsDir: path.join(root, "commands"),
    hooks: {
        sessionStart: {
            launcher: {
                posix: path.join(root, "hooks", "session-start"),
                windows: path.join(root, "hooks", "run-hook.cmd"),
            },
            arg: "session-start",
            async: false,
            events: ["startup", "clear", "compact"],
        },
    },
};
