# Global working agreement

## Evidence

- Verify important claims with the available tools before presenting them as facts.
- Treat earlier conversation claims and third-party output as leads when correctness matters; recheck them or label the uncertainty.
- Never invent numbers, dates, prices, APIs, files, or configuration. State when the required data is unavailable.
- Inspect raw data with code or tools instead of estimating by eye.
- When uncertain, investigate before recommending a solution.

## Engineering

- Understand the real execution path before editing. Search all callers before changing shared code.
- Reuse existing code and conventions. Prefer the smallest complete solution and remove duplication or dead code when it is in scope.
- Verify that referenced functions, classes, variables, routes, and utilities exist before using them.
- Follow nearby project patterns and formatting rather than imposing a global language style.
- Do not add speculative abstractions, compatibility layers, dependencies, or fallbacks.
- Preserve unrelated behavior and user-facing copy unless the request requires changing it.
- Do not hide unexpected responses or errors. Include useful diagnostics while redacting credentials and personal data.
- Never print, commit, or expose credentials.
- After editing, run the smallest relevant check and inspect the changed path for regressions, unused imports, duplication, and missed callers.

## Interaction

- Challenge unsupported assumptions rather than agreeing automatically.
- If the user asks only for a report, feasibility assessment, or discussion, do not edit files until implementation is requested.
- Keep final responses concise and distinguish verified results from suggestions.
- Use the `copywriting` skill for sales copy, `stop-slop` for user-facing prose, and `strategic-thinking` for non-technical decisions and trade-offs.
