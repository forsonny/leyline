import assert from "node:assert/strict";
import { access, mkdtemp, readFile, rm } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import test from "node:test";
import { fileURLToPath, pathToFileURL } from "node:url";

const root = path.resolve(fileURLToPath(new URL("../..", import.meta.url)));
const pluginPath = path.join(root, ".opencode", "plugins", "leyline.js");
const manifestPath = path.join(root, "AGENTS.md");
const entrySkillPath = path.join(root, "skills", "using-leyline", "SKILL.md");

const tempDirs = [];

test.after(async () => {
    for (const dir of tempDirs) {
        await rm(dir, { recursive: true, force: true });
    }
    delete process.env.LEYLINE_OPENCODE_CONFIG_DIR;
});

async function loadPluginModule() {
    return import(`${pathToFileURL(pluginPath).href}?t=${Date.now()}-${Math.random()}`);
}

test("Leyline exports a real OpenCode plugin function", async () => {
    const pluginModule = await loadPluginModule();
    assert.equal(typeof pluginModule.default, "function");
});

test("Leyline syncs OpenCode assets and injects its instructions", async () => {
    const tempDir = await mkdtemp(path.join(os.tmpdir(), "leyline-opencode-"));
    tempDirs.push(tempDir);
    process.env.LEYLINE_OPENCODE_CONFIG_DIR = tempDir;

    const pluginModule = await loadPluginModule();
    const hooks = await pluginModule.default({
        client: {},
        project: {},
        directory: tempDir,
        worktree: tempDir,
        experimental_workspace: { register() {} },
        serverUrl: new URL("https://example.com"),
        $: {},
    });

    await access(path.join(tempDir, "skills", "using-leyline", "SKILL.md"));
    await access(path.join(tempDir, "commands", "brainstorm.md"));
    await access(path.join(tempDir, "agents", "code-reviewer.md"));

    const installedAgent = await readFile(path.join(tempDir, "agents", "code-reviewer.md"), "utf8");
    assert.match(installedAgent, /^mode: subagent$/m);
    assert.doesNotMatch(installedAgent, /^model:\s*inherit$/m);

    const output = { system: [] };
    await hooks["experimental.chat.system.transform"]({}, output);

    const expectedManifest = await readFile(manifestPath, "utf8");
    const expectedEntrySkill = await readFile(entrySkillPath, "utf8");

    assert.ok(output.system.includes(expectedManifest));
    assert.ok(output.system.includes(expectedEntrySkill));
});
