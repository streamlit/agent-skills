---
name: streamlit-chat
description: Streamlit chat interface patterns. Use when building conversational UIs, chatbots, or AI assistants. Covers st.chat_message, st.chat_input, message history, and streaming responses.
license: Apache-2.0
---

# Streamlit Chat Interfaces

Build conversational UIs with Streamlit's chat elements.

## Basic Chat Structure

```python
import streamlit as st

if "messages" not in st.session_state:
    st.session_state.messages = []

# Display chat history
for msg in st.session_state.messages:
    with st.chat_message(msg["role"]):
        st.write(msg["content"])

# Handle new input
if prompt := st.chat_input("Ask a question"):
    st.session_state.messages.append({"role": "user", "content": prompt})

    with st.chat_message("user"):
        st.write(prompt)

    with st.chat_message("assistant"):
        response = get_response(prompt)  # Your LLM call
        st.write(response)

    st.session_state.messages.append({"role": "assistant", "content": response})
```

## Streaming Responses

Use `st.write_stream` for token-by-token display:

```python
with st.chat_message("assistant"):
    response = st.write_stream(get_streaming_response(prompt))

st.session_state.messages.append({"role": "assistant", "content": response})
```
```

## Chat Message Avatars

Customize avatars with icons or images:

```python
with st.chat_message("user", avatar=":material/person:"):
    st.write(user_message)

with st.chat_message("assistant", avatar="logo.png"):
    st.write(assistant_message)
```

## Suggestion Chips

Offer clickable suggestions before the first message:

```python
SUGGESTIONS = {
    ":blue[:material/help:] What is Streamlit?": "Explain what Streamlit is",
    ":green[:material/code:] Show me an example": "Show a simple Streamlit example",
}

if not st.session_state.messages:
    st.pills("Try asking:", list(SUGGESTIONS.keys()), label_visibility="collapsed")
```

## Limiting History Length

Keep context manageable for LLM calls:

```python
HISTORY_LENGTH = 10

recent_history = st.session_state.messages[-HISTORY_LENGTH:]
prompt = build_prompt(question=user_input, history=recent_history)
```

## Related Skills

- `streamlit-snowflake-connection`: Database queries and Cortex chat example
- `streamlit-performance`: Caching strategies for LLM calls
