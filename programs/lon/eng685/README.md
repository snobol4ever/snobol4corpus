# ENG 685 — VBG Exercise

Lon Cherryholmes Sr., ENG 685 linguistics coursework.

`assignment3.py` — Python program using `SNOBOL4python` to classify
*-ing* verb forms (VBG) from Penn Treebank parse trees into:
- Progressive participles (*She was hiking*)
- Gerunds / deverbal nouns (*Writing is fun*)
- Adjectival participles (*The writing style is unique*)
- Undecidable forms (*I like reading*)

The `SNOBOL4python` library brings SNOBOL4 pattern matching into Python:
`treebank` and `claws_info` are full SNOBOL4-style pattern expressions
(using `POS`, `ARBNO`, `BREAK`, `SPAN`, `BAL`, `%` for capture, etc.)
applied directly to string data in Python.

## Data files

| File | Contents | Used |
|------|----------|------|
| `VBGinTASA.dat` | Penn Treebank parse trees (bracket notation), 1977 sentences | ✅ |
| `CLAWS5inTASA.dat` | CLAWS5 POS-tagged text (same sentences) | ✅ |
| `CLAWS7inTASA.dat` | CLAWS7 POS-tagged text (same sentences, CLAWS7 tagset: AT, VVG, NN1, JJ) | included for completeness |
