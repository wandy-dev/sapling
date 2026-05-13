# Engineering Team Agent Architecture

## Goal
Create OpenCode agents simulating an engineering team with 5 roles:
- Product Manager
- Architect
- Engineer
- Engineering Manager
- QA Engineer

## Problem
OpenCode supports custom agents via:
1. **JSON config** in `opencode.json` with agent definitions
2. **Markdown files** in `.opencode/agents/` or `~/.config/opencode/agents/`

Each agent can be `primary` (main assistant) or `subagent` (invoked via @mention).

For team simulation with inter-agent communication:
- Subagents can invoke each other via the `Task` tool
- Use `permission.task` to control which subagents each agent can call
- Each needs custom system prompt defining their role, skills, and collaboration protocols

See: https://opencode.ai/docs/agents

---

## Questions

### 1. Scope
Global (all projects) or project-specific?

### 2. Interaction Model
- **Primary + Subagents**: You switch between agents using Tab or @invoke; each has distinct role
- **Orchestrator Pattern**: Main agent delegates to subagents; you interact with one primary
- **Team Channel**: All subagents active in one session, can @mention each other

### 3. Collaboration Protocol
- Should agents have a shared context/thread?
- Do they need explicit meeting/handoff protocols?
- How should they escalate disagreements?

### 4. Skills
Each role could have skills (e.g., `pm-roadmapping`, `qa-test-planning`). Define now or iterate?

### 5. Models
Use same model for all, or different models per role (e.g., faster/cheaper for PM, more capable for Engineer)?