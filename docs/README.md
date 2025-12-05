# JLearn App - Documentation

**Last Updated**: 2025-12-05  
**Status**: Ready for Implementation

---

## 📋 Overview

JLearn is an **LLM-powered language learning shell** - a framework that leverages Large Language Models for dynamic, personalized content generation while maintaining local-first data ownership.

**Core Philosophy**: 
- **Local-first**: No servers, all data on device
- **User owns data**: 100% ownership, full export anytime
- **Privacy-first**: No tracking, no cloud dependencies
- **LLM-agnostic**: Works with any LLM (ChatGPT, Claude, Gemini, etc.)

---

## 📚 Documentation Index

### Product & Strategy

| Document | Description |
|----------|-------------|
| [PRODUCT_VISION.md](./PRODUCT_VISION.md) | Strategic vision, value proposition, user personas |
| [USER_STORIES_MVP.md](./USER_STORIES_MVP.md) | User stories with acceptance criteria by epic |

### Technical Design

| Document | Description |
|----------|-------------|
| [ARCHITECTURE_OVERVIEW.md](./ARCHITECTURE_OVERVIEW.md) | System architecture, layers, data flow |
| [REQUIREMENTS_LLM_INTEGRATION.md](./REQUIREMENTS_LLM_INTEGRATION.md) | LLM integration specs, prompt system |
| [JSON_SCHEMAS.md](./JSON_SCHEMAS.md) | Content schemas for flashcards, quizzes, etc. |

### UX & Flows

| Document | Description |
|----------|-------------|
| [UX_DESIGN_LLM_SHELL.md](./UX_DESIGN_LLM_SHELL.md) | UI/UX design for LLM shell approach |
| [USER_FLOWS_LLM_SHELL.md](./USER_FLOWS_LLM_SHELL.md) | User flows for content generation workflow |

### Implementation

| Document | Description |
|----------|-------------|
| [IMPLEMENTATION_ROADMAP.md](./IMPLEMENTATION_ROADMAP.md) | Phased development plan with milestones |

### Release History

| Document | Description |
|----------|-------------|
| [releases/](./releases/) | Release notes archive |

---

## 🚀 Quick Start for Development

### Key Concepts

**The LLM Shell Approach**:
```
App → Prompt → User's LLM → JSON → App → Interactive Content → User
                   ↓
            Progress Data → Next Prompt (adaptive)
```

### Integration Phases

1. **MVP: Copy/Paste** - User manually copies prompts to their LLM
2. **Phase 2: BYOK API** - User provides API key for seamless integration
3. **Phase 3: SDK** - OAuth with providers for one-click generation

### MVP Priorities

1. ✅ Product vision defined
2. ✅ Architecture designed
3. ✅ JSON schemas defined
4. [ ] Database schema implementation
5. [ ] Core screens (Home, Generate, Study)
6. [ ] JSON parsing engine
7. [ ] Progress tracking

---

## 📊 Success Metrics

| Milestone | Criteria |
|-----------|----------|
| **MVP (Week 8)** | 2 learning components, >95% JSON parse rate |
| **Beta (Month 3)** | 50+ testers, <1% crash rate |
| **Launch (Month 4)** | 1,000+ users, 4.0+ rating |

---

## 🔧 Tech Stack

- **Framework**: Flutter 3.10.1+
- **Database**: SQLite (sqflite)
- **State**: Provider → Bloc (future)
- **Platform**: Android (iOS in Phase 4)
