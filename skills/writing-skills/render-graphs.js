#!/usr/bin/env node
/*
 * render-graphs.js - extract DOT fences from Leyline SKILL.md files and render them.
 *
 * Usage:
 *     node skills/writing-skills/render-graphs.js <file-or-directory> [--format svg|png] [--out <dir>]
 *
 * Requires `dot` (graphviz) on PATH.
 *
 * Purpose: skill diagrams are authored as `dot` fenced blocks inside SKILL.md so they
 * render as text in any Markdown viewer AND can be rendered to visuals when needed.
 * This script walks the given path, extracts each `dot` block, and invokes `dot`
 * to produce image files named after the skill + block index.
 */

import { readFileSync, readdirSync, statSync, existsSync, mkdirSync, writeFileSync } from "node:fs";
import { resolve, join, dirname, basename, relative } from "node:path";
import { spawnSync } from "node:child_process";

const args = process.argv.slice(2);
if (args.length === 0) {
    console.error("Usage: render-graphs.js <file-or-directory> [--format svg|png] [--out <dir>]");
    process.exit(2);
}

const target = resolve(args[0]);
const format = getFlag(args, "--format") || "svg";
const outDir = resolve(getFlag(args, "--out") || "rendered-graphs");

if (!existsSync(target)) {
    console.error(`No such path: ${target}`);
    process.exit(2);
}

// Confirm `dot` is available.
const dotCheck = spawnSync("dot", ["-V"], { encoding: "utf8" });
if (dotCheck.status !== 0) {
    console.error("graphviz `dot` not found on PATH. Install graphviz and retry.");
    process.exit(3);
}

mkdirSync(outDir, { recursive: true });

const files = collect(target);
let rendered = 0;
for (const file of files) {
    const blocks = extractDotBlocks(readFileSync(file, "utf8"));
    for (let i = 0; i < blocks.length; i++) {
        const stem = basename(dirname(file)) + "-" + basename(file, ".md") + "-" + String(i + 1).padStart(2, "0");
        const outPath = join(outDir, `${stem}.${format}`);
        const result = spawnSync("dot", [`-T${format}`, "-o", outPath], {
            input: blocks[i],
            encoding: "utf8",
        });
        if (result.status !== 0) {
            console.error(`render failed for ${file} block ${i + 1}: ${result.stderr}`);
            continue;
        }
        console.log(`${relative(process.cwd(), outPath)}`);
        rendered++;
    }
}

if (rendered === 0) {
    console.error("No DOT blocks rendered. Check the target path contains SKILL.md files with ```dot fences.");
    process.exit(1);
}

function collect(path) {
    const s = statSync(path);
    if (s.isFile()) return path.endsWith(".md") ? [path] : [];
    const out = [];
    for (const entry of readdirSync(path, { withFileTypes: true })) {
        const full = join(path, entry.name);
        if (entry.isDirectory()) out.push(...collect(full));
        else if (entry.isFile() && entry.name.endsWith(".md")) out.push(full);
    }
    return out;
}

function extractDotBlocks(text) {
    const blocks = [];
    const re = /^```dot\s*\r?\n([\s\S]*?)\r?\n```/gm;
    let match;
    while ((match = re.exec(text)) !== null) {
        blocks.push(match[1]);
    }
    return blocks;
}

function getFlag(arr, name) {
    const i = arr.indexOf(name);
    return i >= 0 && i + 1 < arr.length ? arr[i + 1] : null;
}
