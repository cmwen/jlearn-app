# JSON Schemas for LLM Content Generation

**Created**: 2025-12-04  
**Status**: Draft  
**Version**: 1.0  
**Related Docs**: REQUIREMENTS_LLM_INTEGRATION.md, USER_STORIES_MVP.md  

---

## Overview

This document defines the standardized JSON schemas that LLMs must generate for JLearn App to parse and render learning content. These schemas are included in prompts to ensure consistent output.

## Design Principles

1. **Simple and Clear**: Easy for LLMs to generate correctly
2. **Flexible**: Support optional fields for enhanced content
3. **Versioned**: Include schema version for future evolution
4. **Validatable**: Clear required vs optional fields
5. **Extensible**: Room for future enhancements without breaking changes

## Schema Versioning

All schemas include a `schema_version` field to enable backward compatibility as schemas evolve.

Current version: `"1.0"`

## Common Fields

All content types include these base fields:

```json
{
  "schema_version": "1.0",
  "type": "content_type",
  "language": "ISO 639-1 code (e.g., 'ja', 'es', 'fr')",
  "level": "CEFR level (A1, A2, B1, B2, C1, C2)",
  "metadata": {
    "created_at": "ISO 8601 timestamp (optional)",
    "topic": "Topic name (optional)",
    "tags": ["tag1", "tag2"]
  }
}
```

---

## 1. Flashcard Set Schema

### Purpose
Generate vocabulary flashcards with front/back content, examples, and pronunciation.

### Schema

```json
{
  "schema_version": "1.0",
  "type": "flashcard_set",
  "language": "ja",
  "level": "A2",
  "metadata": {
    "topic": "Daily Greetings",
    "tags": ["vocabulary", "conversation"],
    "description": "Common Japanese greetings for everyday use"
  },
  "cards": [
    {
      "id": "uuid-or-index",
      "front": "おはようございます",
      "back": "Good morning (formal)",
      "pronunciation": "ohayou gozaimasu",
      "example": "おはようございます。今日はいい天気ですね。",
      "example_translation": "Good morning. It's nice weather today.",
      "notes": "Use before noon, formal setting",
      "image_prompt": "sunrise over Japanese city (optional for future)"
    }
  ]
}
```

### Field Specifications

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `schema_version` | string | Yes | Must be "1.0" |
| `type` | string | Yes | Must be "flashcard_set" |
| `language` | string | Yes | ISO 639-1 language code |
| `level` | string | Yes | CEFR level (A1-C2) |
| `metadata.topic` | string | No | Topic or category name |
| `metadata.tags` | array | No | Tags for organization |
| `metadata.description` | string | No | Brief description of set |
| `cards` | array | Yes | Array of flashcard objects (min 1) |
| `cards[].id` | string | Yes | Unique identifier for card |
| `cards[].front` | string | Yes | Question/prompt side |
| `cards[].back` | string | Yes | Answer/translation side |
| `cards[].pronunciation` | string | No | Romanization or phonetic guide |
| `cards[].example` | string | No | Example sentence in target language |
| `cards[].example_translation` | string | No | Translation of example |
| `cards[].notes` | string | No | Additional context or usage notes |
| `cards[].image_prompt` | string | No | For future image generation |

### Validation Rules

- Minimum 1 card, recommended 5-20 cards per set
- `front` and `back` must not be empty
- `id` must be unique within the set
- If `example` provided, `example_translation` recommended
- Maximum field lengths: `front/back` 200 chars, `example` 500 chars

### Example Prompt Template

```
Generate a flashcard set for learning [LANGUAGE] at [LEVEL] level.
Topic: [TOPIC]
Number of cards: [COUNT]

Format your response as JSON following this exact schema:
{
  "schema_version": "1.0",
  "type": "flashcard_set",
  "language": "[LANGUAGE_CODE]",
  "level": "[LEVEL]",
  "metadata": {
    "topic": "[TOPIC]",
    "tags": ["relevant", "tags"]
  },
  "cards": [
    {
      "id": "1",
      "front": "word or phrase in target language",
      "back": "translation or explanation",
      "pronunciation": "romanization (if applicable)",
      "example": "example sentence using this word",
      "example_translation": "translation of example",
      "notes": "usage notes or context"
    }
  ]
}

Important: 
- Provide ONLY valid JSON, no markdown formatting
- Include at least [COUNT] cards
- Focus on practical, commonly used vocabulary
- Consider my current level: [LEVEL]
```

---

## 2. Quiz Schema

### Purpose
Generate multiple-choice quizzes to test comprehension and knowledge.

### Schema

```json
{
  "schema_version": "1.0",
  "type": "quiz",
  "language": "ja",
  "level": "B1",
  "metadata": {
    "topic": "Past Tense Verbs",
    "tags": ["grammar", "verbs"],
    "time_limit": 300,
    "description": "Test your knowledge of Japanese past tense conjugations"
  },
  "questions": [
    {
      "id": "q1",
      "question": "What is the past tense of '食べる' (to eat)?",
      "question_audio": "audio-url (optional for future)",
      "options": [
        "食べた",
        "食べます",
        "食べて",
        "食べない"
      ],
      "correct_answer": "食べた",
      "explanation": "食べた is the past tense (-ta form) of 食べる. The stem is 食べ and we add た for past tense.",
      "points": 1,
      "difficulty": "medium"
    }
  ]
}
```

### Field Specifications

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `schema_version` | string | Yes | Must be "1.0" |
| `type` | string | Yes | Must be "quiz" |
| `language` | string | Yes | ISO 639-1 language code |
| `level` | string | Yes | CEFR level (A1-C2) |
| `metadata.topic` | string | No | Quiz topic or category |
| `metadata.tags` | array | No | Tags for organization |
| `metadata.time_limit` | number | No | Suggested time in seconds |
| `metadata.description` | string | No | Brief quiz description |
| `questions` | array | Yes | Array of question objects (min 1) |
| `questions[].id` | string | Yes | Unique question identifier |
| `questions[].question` | string | Yes | The question text |
| `questions[].question_audio` | string | No | Audio URL (future) |
| `questions[].options` | array | Yes | Array of answer choices (2-6) |
| `questions[].correct_answer` | string | Yes | Must match one option exactly |
| `questions[].explanation` | string | Yes | Explanation of correct answer |
| `questions[].points` | number | No | Point value (default 1) |
| `questions[].difficulty` | string | No | easy, medium, hard |

### Validation Rules

- Minimum 1 question, recommended 5-15 questions
- `options` array must contain 2-6 choices
- `correct_answer` must exactly match one option
- `question` and `explanation` must not be empty
- No duplicate options within a question
- `id` must be unique within the quiz

### Example Prompt Template

```
Generate a multiple-choice quiz for learning [LANGUAGE] at [LEVEL] level.
Topic: [TOPIC]
Number of questions: [COUNT]

Format your response as JSON following this exact schema:
{
  "schema_version": "1.0",
  "type": "quiz",
  "language": "[LANGUAGE_CODE]",
  "level": "[LEVEL]",
  "metadata": {
    "topic": "[TOPIC]",
    "tags": ["relevant", "tags"],
    "time_limit": 300
  },
  "questions": [
    {
      "id": "q1",
      "question": "Question text here",
      "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
      "correct_answer": "Option 2",
      "explanation": "Detailed explanation of why this answer is correct",
      "difficulty": "medium"
    }
  ]
}

Important:
- Provide ONLY valid JSON, no markdown formatting
- Include exactly [COUNT] questions
- Ensure correct_answer exactly matches one option
- Provide clear, educational explanations
- Mix difficulty levels appropriately for [LEVEL]
- Make distractors plausible but clearly incorrect
```

---

## 3. Conversation Schema

### Purpose
Generate dialogue-based content for practicing natural conversation patterns.

### Schema

```json
{
  "schema_version": "1.0",
  "type": "conversation",
  "language": "ja",
  "level": "A2",
  "metadata": {
    "topic": "Ordering at a Restaurant",
    "tags": ["conversation", "food", "practical"],
    "context": "A customer orders food at a casual restaurant in Tokyo",
    "characters": ["Customer", "Waiter"]
  },
  "messages": [
    {
      "id": "msg1",
      "speaker": "Waiter",
      "text": "いらっしゃいませ。何名様ですか？",
      "translation": "Welcome. How many people?",
      "pronunciation": "irasshaimase. nan-mei-sama desu ka?",
      "notes": "Standard greeting in Japanese restaurants"
    },
    {
      "id": "msg2",
      "speaker": "Customer",
      "text": "二人です。",
      "translation": "Two people.",
      "pronunciation": "futari desu",
      "notes": "Simple response for party size"
    }
  ],
  "practice_prompts": [
    "Try ordering your favorite dish in Japanese",
    "How would you ask for the menu?",
    "Practice saying 'I'll have...' using ～をお願いします"
  ],
  "vocabulary": [
    {
      "word": "いらっしゃいませ",
      "translation": "Welcome (formal)",
      "pronunciation": "irasshaimase"
    }
  ]
}
```

### Field Specifications

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `schema_version` | string | Yes | Must be "1.0" |
| `type` | string | Yes | Must be "conversation" |
| `language` | string | Yes | ISO 639-1 language code |
| `level` | string | Yes | CEFR level (A1-C2) |
| `metadata.topic` | string | Yes | Conversation topic |
| `metadata.tags` | array | No | Tags for organization |
| `metadata.context` | string | Yes | Situation description |
| `metadata.characters` | array | Yes | List of speaker names |
| `messages` | array | Yes | Array of message objects (min 2) |
| `messages[].id` | string | Yes | Unique message identifier |
| `messages[].speaker` | string | Yes | Must match a character name |
| `messages[].text` | string | Yes | Message in target language |
| `messages[].translation` | string | Yes | English translation |
| `messages[].pronunciation` | string | No | Romanization or phonetic |
| `messages[].notes` | string | No | Cultural or usage notes |
| `practice_prompts` | array | No | Follow-up practice suggestions |
| `vocabulary` | array | No | Key vocabulary from conversation |

### Validation Rules

- Minimum 2 messages (realistic conversation)
- `speaker` must be in `metadata.characters` array
- Messages should alternate between speakers (generally)
- `text` and `translation` must not be empty
- Recommended 6-15 messages for good practice length

### Example Prompt Template

```
Generate a realistic conversation for learning [LANGUAGE] at [LEVEL] level.
Situation: [SITUATION_DESCRIPTION]
Number of exchanges: [COUNT]

Format your response as JSON following this exact schema:
{
  "schema_version": "1.0",
  "type": "conversation",
  "language": "[LANGUAGE_CODE]",
  "level": "[LEVEL]",
  "metadata": {
    "topic": "[TOPIC]",
    "context": "[DETAILED_SITUATION]",
    "characters": ["Character A", "Character B"]
  },
  "messages": [
    {
      "id": "msg1",
      "speaker": "Character A",
      "text": "Text in target language",
      "translation": "English translation",
      "pronunciation": "romanization (if applicable)",
      "notes": "Cultural or usage notes"
    }
  ],
  "practice_prompts": [
    "Practice suggestion 1",
    "Practice suggestion 2"
  ]
}

Important:
- Provide ONLY valid JSON, no markdown formatting
- Create a natural, realistic conversation
- Include cultural context in notes when relevant
- Keep language appropriate for [LEVEL]
- Alternate between speakers naturally
- Include practical, usable phrases
```

---

## 4. Grammar Explanation Schema

### Purpose
Generate structured grammar lessons with rules, examples, and exercises.

### Schema

```json
{
  "schema_version": "1.0",
  "type": "grammar_lesson",
  "language": "ja",
  "level": "B1",
  "metadata": {
    "topic": "Te-form Conjugation",
    "tags": ["grammar", "verbs", "conjugation"],
    "difficulty": "intermediate",
    "estimated_time": 15
  },
  "title": "Te-form Conjugation in Japanese",
  "summary": "Learn how to conjugate verbs into the te-form, used for connecting actions and making requests.",
  "sections": [
    {
      "heading": "Rule Explanation",
      "content": "The te-form is created differently based on the verb group:\n\n**Group 1 (u-verbs)**: Change the ending based on the final syllable\n**Group 2 (ru-verbs)**: Drop る and add て\n**Group 3 (irregular)**: する→して, くる→きて",
      "type": "text"
    },
    {
      "heading": "Examples",
      "content": "",
      "type": "example_list",
      "examples": [
        {
          "original": "飲む (nomu - to drink)",
          "conjugated": "飲んで (nonde)",
          "translation": "drinking / drink and...",
          "notes": "む→んで"
        },
        {
          "original": "食べる (taberu - to eat)",
          "conjugated": "食べて (tabete)",
          "translation": "eating / eat and...",
          "notes": "る-verb: drop る add て"
        }
      ]
    },
    {
      "heading": "Common Uses",
      "content": "1. Connecting sequential actions: 朝起きて、シャワーを浴びます (Wake up and take a shower)\n2. Making requests: 手伝ってください (Please help)\n3. Giving reasons: 暑くて困りました (It was hot, so I was troubled)",
      "type": "text"
    }
  ],
  "practice_exercises": [
    {
      "instruction": "Convert the following verbs to te-form",
      "items": [
        {
          "prompt": "行く (iku - to go)",
          "answer": "行って (itte)",
          "explanation": "く→って"
        }
      ]
    }
  ],
  "related_topics": [
    "Past Tense Formation",
    "Request Forms",
    "Sequential Actions"
  ]
}
```

### Field Specifications

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `schema_version` | string | Yes | Must be "1.0" |
| `type` | string | Yes | Must be "grammar_lesson" |
| `language` | string | Yes | ISO 639-1 language code |
| `level` | string | Yes | CEFR level (A1-C2) |
| `metadata.topic` | string | Yes | Grammar topic name |
| `metadata.tags` | array | No | Tags for organization |
| `metadata.difficulty` | string | No | beginner, intermediate, advanced |
| `metadata.estimated_time` | number | No | Minutes to complete |
| `title` | string | Yes | Lesson title |
| `summary` | string | Yes | Brief overview of grammar point |
| `sections` | array | Yes | Array of content sections |
| `sections[].heading` | string | Yes | Section heading |
| `sections[].content` | string | Yes | Section text content |
| `sections[].type` | string | Yes | text, example_list, table |
| `sections[].examples` | array | No | For example_list type |
| `practice_exercises` | array | No | Optional practice activities |
| `related_topics` | array | No | Links to related grammar |

### Validation Rules

- Minimum 1 section required
- `summary` should be 1-3 sentences
- Examples should include original, conjugated, and translation
- Practice exercises optional but recommended
- Keep total content digestible (not overwhelming)

### Example Prompt Template

```
Generate a grammar lesson for learning [LANGUAGE] at [LEVEL] level.
Grammar Point: [GRAMMAR_TOPIC]

Format your response as JSON following this exact schema:
{
  "schema_version": "1.0",
  "type": "grammar_lesson",
  "language": "[LANGUAGE_CODE]",
  "level": "[LEVEL]",
  "metadata": {
    "topic": "[GRAMMAR_TOPIC]",
    "tags": ["grammar"],
    "estimated_time": 15
  },
  "title": "[Clear lesson title]",
  "summary": "[Brief 1-2 sentence overview]",
  "sections": [
    {
      "heading": "Rule Explanation",
      "content": "Clear explanation of the grammar rule",
      "type": "text"
    },
    {
      "heading": "Examples",
      "content": "",
      "type": "example_list",
      "examples": [
        {
          "original": "word/phrase",
          "conjugated": "conjugated form",
          "translation": "English translation",
          "notes": "Additional notes"
        }
      ]
    }
  ],
  "practice_exercises": [
    {
      "instruction": "Exercise instructions",
      "items": [
        {
          "prompt": "Question or prompt",
          "answer": "Correct answer",
          "explanation": "Why this is correct"
        }
      ]
    }
  ]
}

Important:
- Provide ONLY valid JSON, no markdown formatting
- Explain clearly for [LEVEL] learners
- Include at least 5 concrete examples
- Make practice exercises practical
- Use markdown formatting in content for readability
- Include linguistic terminology appropriately for level
```

---

## 5. Vocabulary List Schema

### Purpose
Generate themed vocabulary lists with definitions and usage.

### Schema

```json
{
  "schema_version": "1.0",
  "type": "vocabulary_list",
  "language": "ja",
  "level": "A1",
  "metadata": {
    "topic": "Colors",
    "tags": ["vocabulary", "adjectives"],
    "description": "Basic color vocabulary in Japanese"
  },
  "words": [
    {
      "id": "1",
      "word": "赤い",
      "pronunciation": "akai",
      "part_of_speech": "adjective",
      "translations": ["red"],
      "definition": "The color red; describes red objects",
      "example": "赤いりんご",
      "example_translation": "red apple",
      "notes": "い-adjective, can conjugate",
      "image_prompt": "red color swatch"
    }
  ]
}
```

### Field Specifications

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `schema_version` | string | Yes | Must be "1.0" |
| `type` | string | Yes | Must be "vocabulary_list" |
| `language` | string | Yes | ISO 639-1 language code |
| `level` | string | Yes | CEFR level (A1-C2) |
| `metadata.topic` | string | Yes | Vocabulary theme/category |
| `metadata.tags` | array | No | Tags for organization |
| `metadata.description` | string | No | Brief description |
| `words` | array | Yes | Array of word objects (min 1) |
| `words[].id` | string | Yes | Unique identifier |
| `words[].word` | string | Yes | Word in target language |
| `words[].pronunciation` | string | No | Romanization or phonetic |
| `words[].part_of_speech` | string | Yes | noun, verb, adjective, etc. |
| `words[].translations` | array | Yes | English translations (1-3) |
| `words[].definition` | string | No | Detailed definition |
| `words[].example` | string | No | Example usage |
| `words[].example_translation` | string | No | Translation of example |
| `words[].notes` | string | No | Usage notes |
| `words[].image_prompt` | string | No | For future image generation |

---

## Error Handling

### When LLM Output is Invalid

The app should handle these common issues:

1. **Markdown Code Blocks**: Strip ```json and ``` wrappers
2. **Trailing Commas**: Remove before parsing
3. **Escaped Characters**: Handle properly
4. **Missing Required Fields**: Show specific error
5. **Type Mismatches**: Validate and report
6. **Empty Arrays**: Reject with helpful message

### Error Response Format

When parsing fails, app should show:

```
❌ JSON Parsing Error

Issue: Missing required field 'correct_answer' in question 3

Suggestion: Please check that all quiz questions include a 'correct_answer' field that exactly matches one of the options.

[Edit JSON] [Get Help] [Try Again]
```

---

## Versioning Strategy

### Current: Version 1.0
- Initial release schemas
- Core learning components

### Future: Version 1.1 (Planned)
- Add audio URL fields
- Add image URL fields  
- Add video integration
- Enhanced metadata

### Backward Compatibility
- App must support v1.0 indefinitely
- New versions are additive (add fields, don't remove)
- Schema version checked before parsing
- Graceful degradation for unknown fields

---

## Testing & Validation

### LLM Provider Testing Matrix

Test each schema with:
- [ ] ChatGPT (GPT-4)
- [ ] ChatGPT (GPT-3.5)
- [ ] Google Gemini
- [ ] Claude (Anthropic)
- [ ] GitHub Copilot

### Validation Checklist

For each schema:
- [ ] All required fields present
- [ ] Data types correct
- [ ] Array lengths within bounds
- [ ] Cross-references valid (e.g., correct_answer in options)
- [ ] Text fields not empty
- [ ] IDs unique within document
- [ ] Language code valid ISO 639-1
- [ ] Level is valid CEFR (A1-C2)

---

## Implementation Notes

### Dart Model Classes

Each schema should have corresponding Dart model classes with:
- `fromJson()` factory constructor
- `toJson()` method
- Field validation in constructor
- Meaningful error messages

### JSON Parser Requirements

- Use `dart:convert` for parsing
- Wrap in try-catch with specific error types
- Log parsing errors for debugging
- Provide user-friendly error messages
- Support progressive parsing (process valid parts)

---

**Next Steps**:
- Implement Dart model classes for each schema
- Create JSON validators
- Write unit tests for parsing edge cases
- Test with real LLM outputs
- Document common LLM output issues and fixes
