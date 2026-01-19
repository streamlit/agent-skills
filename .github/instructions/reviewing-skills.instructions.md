---
applyTo: "developing-with-streamlit/**"
excludeAgent: "coding-agent"
---

# Skill writing review instructions

When reviewing skill files in the `developing-with-streamlit/` directory, follow these guidelines:

## Spelling and grammar

- Check for spelling mistakes in all markdown files and comments
- Flag grammatical errors and suggest corrections
- Ensure consistent capitalization (e.g., "Streamlit" not "streamlit" in prose)
- **Use sentence casing for all titles and headers** - Only the first word and proper nouns should be capitalized (e.g., "Creating a new skill" not "Creating a New Skill")

## Clarity and wording

- Suggest improvements for unclear or verbose sentences
- Prefer concise, direct language
- Ensure instructions are actionable and unambiguous
- Flag jargon that may need explanation

## Agent skills best practices

Verify compliance with the [Agent Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices.md):

- **Name field**: Lowercase letters, numbers, and hyphens only; max 64 chars; no XML tags; cannot contain "anthropic" or "claude"
- **Description field**: Non-empty; max 1024 chars; no XML tags; should describe what the skill does AND when to use it; must be written in third person
- **SKILL.md length**: Should be under 500 lines; suggest splitting into reference files if exceeded
- **File references**: Should be one level deep from SKILL.md
- **Descriptions**: Should use third person (e.g., "Processes files" not "I can process files")

## Streamlit-specific guidelines

For Streamlit-related skills, check against the guidelines in `/AGENTS.md`:

- Code examples should target the latest Streamlit version
- Verify suggestions against current Streamlit API patterns
- Flag deprecated methods or outdated patterns
- Reference: [docs.streamlit.io/llms-full.txt](https://docs.streamlit.io/llms-full.txt) (large file - LLM-optimized Streamlit docs)

## Consistency

- Ensure terminology is consistent throughout the skill
- Check that code examples match the documented patterns
- Verify links are valid, publicly accessible, and point to existing resources

## Documentation updates

When skills are added or renamed, verify that documentation is updated:

- **`README.md`** - The "Available skills" table should list the new/renamed skill
- **`developing-with-streamlit/SKILL.md`** - The "Skill map" table should reflect the change
