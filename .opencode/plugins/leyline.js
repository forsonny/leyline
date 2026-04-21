// Leyline OpenCode plugin.
//
// OpenCode plugins are executable modules, not metadata manifests. This plugin
// installs Leyline's native OpenCode assets into the user's config directory and
// injects the Leyline manifest plus entry skill into the system prompt.

import { realpathSync } from "node:fs";
import { copyFile, mkdir, readFile, readdir, writeFile } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { fileURLToPath } from "node:url";

const here = path.dirname(realpathSync(fileURLToPath(import.meta.url)));
const root = path.resolve(here, "..", "..");
const assetDirs = ["skills", "commands", "agents"];

function resolveConfigRoot() {
    return process.env.LEYLINE_OPENCODE_CONFIG_DIR || path.join(os.homedir(), ".config", "opencode");
}

async function copyTree(source, target) {
    const entries = await readdir(source, { withFileTypes: true });
    await mkdir(target, { recursive: true });

    for (const entry of entries) {
        const sourcePath = path.join(source, entry.name);
        const targetPath = path.join(target, entry.name);

        if (entry.isDirectory()) {
            await copyTree(sourcePath, targetPath);
            continue;
        }

        await copyFile(sourcePath, targetPath);
    }
}

function normalizeAgentForOpenCode(content) {
    const withoutInheritedModel = content.replace(/^model:\s*inherit\s*$/m, "").replace(/\n\n\n+/g, "\n\n");

    if (/^mode:\s+/m.test(withoutInheritedModel)) {
        return withoutInheritedModel;
    }

    return withoutInheritedModel.replace(/^description: .*$/m, "$&\nmode: subagent");
}

async function installOpenCodeAgents(configRoot) {
    const sourceDir = path.join(root, "agents");
    const targetDir = path.join(configRoot, "agents");

    await mkdir(targetDir, { recursive: true });

    for (const entry of await readdir(sourceDir, { withFileTypes: true })) {
        if (!entry.isFile()) {
            continue;
        }

        const sourcePath = path.join(sourceDir, entry.name);
        const targetPath = path.join(targetDir, entry.name);
        const content = await readFile(sourcePath, "utf8");

        await writeFile(targetPath, normalizeAgentForOpenCode(content), "utf8");
    }
}

async function installLeylineAssets() {
    const configRoot = resolveConfigRoot();

    for (const assetDir of assetDirs.filter((dir) => dir !== "agents")) {
        await copyTree(path.join(root, assetDir), path.join(configRoot, assetDir));
    }

    await installOpenCodeAgents(configRoot);
}

export const LeylinePlugin = async () => {
    await installLeylineAssets();

    const [manifest, entrySkill] = await Promise.all([
        readFile(path.join(root, "AGENTS.md"), "utf8"),
        readFile(path.join(root, "skills", "using-leyline", "SKILL.md"), "utf8"),
    ]);

    return {
        "experimental.chat.system.transform": async (_input, output) => {
            output.system.push(manifest);
            output.system.push(entrySkill);
        },
    };
};

export default LeylinePlugin;
