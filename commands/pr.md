---
description: PR operations — auto review+fix+push, manual review, fix comments
argument-hint: <PR number> [auto|review|fix|comment]
---

Activate the `pr` skill for PR: $ARGUMENTS

Modes:
- `/pr 123` or `/pr 123 auto` → full auto flow
- `/pr 123 review` → review only, present findings
- `/pr 123 review comment` → review and post inline comments
- `/pr 123 fix` → fix existing review comments, push, reply, resolve
